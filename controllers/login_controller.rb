get '/login' do
	@title = "Login"
	@user = User.new

	erb :'login/login', {:layout => :static_layout}
end

post '/login' do

	if params[:login] == "LinkedIn"
		redirect '/auth/linked_in'
	elsif params[:login] == "Facebook"
		redirect '/auth/facebook'
	end

	user = User.authenticate(params[:session][:email], params[:session][:password])
	if user.nil? 
		# Create an error message and re-render the signin form.
		flash[:error] = "Login failed."
		redirect "/login"
	else
		# Sign the user in and redirect to the user's show page.
		flash[:success] = "Logged in successfully."
		session[:user] = user.id
		redirect "/users/#{user.id}"
	end
end

delete '/logout' do
	sign_out
	redirect '/'
end

get '/recover' do
	erb :'login/recover', {:layout => :static_layout}
end

post '/recover' do
	user = User.first(:email => params[:email])
	if user.nil?
		flash[:error] = "There is no account associated with that email."
		redirect back
	else
		recover_password = PasswordReset.new(:email => params[:email])
		if recover_password.save
			status(202)

			if (ENV['RACK_ENV']) == "zproduction"

				#Send Email
				mail = Mail.new do          
				  to "#{user.name} <#{user.email}>"         
				  from 'Proximate Staff <no-reply@proximate.com>'     
				  subject 'Proximate Password Reset'               
				end  

				html_part = Mail::Part.new do |part| 
		      part.content_type 'text/html; charset=UTF-8' 
		      part.body("
		      	<p>Hello #{user.name},</p>
						<p>Please follow this link to reset your password
						<a href='http://localhost:9292/recover/#{recover_password.slug}'>http://localhost:9292/recover/#{recover_password.slug}</a></p>
						<p>Thank you, <br />
						The Proximate Team
						</p>
		      ") 
	   		end 
	    	mail.html_part = html_part
				mail.deliver
			end

			flash[:success] = "Check your email to reset your password."
			redirect '/'
		else
			status(412)
			recover_password.errors.each do |e|
			    puts e
			end
			flash[:error] = "Please try again."
			redirect back
		end
	end
end

get '/recover/:slug' do
	@recover = PasswordReset.first(:slug => params[:slug])

	if @recover.used?
		flash[:error] = "This password reset has already been used. Try again."
		redirect '/'	
	end

	status(200)
	erb :'login/reset', {:layout => :static_layout}
end

put '/recover/:slug' do
	recover = PasswordReset.first(:slug => params[:slug])

	if recover.used?
		flash[:error] = "This password reset has already been used. Try again."
		redirect '/'	
	end

	user = User.first(:email => recover.email)
	
	if user.update(:password => params[:password])
		status(202)


		recover.update(:used => true)
		flash[:success] = "Password successfully changed. Please try logging in again."
		redirect '/'
	else
		status(412)
		flash[:error] = "Please try again."
		redirect '/'	
	end

	erb :'login/reset', {:layout => :static_layout}
end