get '/login' do
	@title = "Login"
	@user = User.new

	erb :'sessions/login', {:layout => :static_layout}
end

post '/login' do
	user = User.authenticate(params[:session][:email], params[:session][:password])
	if user.nil? 
		# Create an error message and re-render the signin form.
		flash[:error] = "Log in failed."
		redirect "/login"
	else
		# Sign the user in and redirect to the user's show page.
		flash[:success] = "Logged in Successfully."
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
	if (User.first(:email => params[:email]).nil?)
		flash[:error] = "There is no account associated with that email."
		redirect back
	else
		recover_password = PasswordReset.new(:email => params[:email])
		if recover_password.save
			status(202)
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