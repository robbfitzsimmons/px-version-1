# Sign up Authenticates with OmniAuth via OmniAuthController
get '/signup' do
	erb :'users/sign_up', {:layout => :static_layout}
end

post '/signup' do


	if params[:email] != "name@email.com"
		session[:email] = params[:email]
	else
		session[:email] = nil
	end
	
	if params[:password] != "password"	
		session[:password] = params[:password]
	else
		session[:password] = nil
	end

	if params[:sign_up] == "LinkedIn"
		redirect '/auth/linked_in'
	elsif params[:sign_up] == "Facebook"
		redirect '/auth/facebook'
	elsif params[:sign_up] == "Sign Up"
		redirect '/signup/step2'
	end
end


get '/signup/step2' do
	@user = session[:user]
	@user = User.new() if @user.class != User

	erb :'users/step2', {:layout => :static_layout}
end

post '/signup/step2' do
	@user = User.new(params[:user])

	if @user.save
		status(202)

		@user.invites = Invite.all(:email => @user.email)
		@user.save

		session[:user] = @user.id
		flash[:success] = "Welcome to your dashboard #{@user.name}"
		redirect "/users/#{@user.id}"
	else
		status(412)
		@user.errors.each do |e|
		    puts e
		end
		
		flash[:error] = "Email already registered."
		redirect '/signup/step2'
	end
end

# Show a specific user
get '/users/:id' do
	@title = "Dashboard"
	@user = User.get(params[:id])

	session[:connect] = nil
	
	erb :'users/show'	
end

get '/users/:id/connect' do
	@title = "Connect your other Social Accounts"
	@user = User.get(params[:id])
	
	erb :'users/connect'	
end

post '/connect' do

	session[:connect] = true
	session[:user_info] = nil

	if params[:connect] == "LinkedIn"
		redirect '/auth/linked_in'
	elsif params[:connect] == "Facebook"
		redirect '/auth/facebook'
	end

end

get '/users/:id/approve' do
	@title = "Approve your New Information"
	@user = session[:user_info]
	
	erb :'users/approve'	
end


put '/users/:id' do

	@user = User.get(params[:id])

	if (session[:connect] == true)

		if (params[:user][:description] != nil)
			@user.description = params[:user][:description]
		end

		if (params[:user][:location] != nil)
			@user.location = params[:user][:location]
		end

		if (params[:user][:linked_in] != nil)
			@user.linked_in = params[:user][:linked_in]
			@user.linked_in_uid = params[:user][:linked_in_uid]
		end

		if (params[:user][:facebook] != nil)
			@user.facebook = params[:user][:facebook]
			@user.facebook_uid = params[:user][:facebook]
		end

		if (params[:user][:twitter] != nil)
			@user.facebook = params[:user][:twitter]
			@user.facebook_uid = params[:user][:twitter]
		end

		if @user.save
			status(202)

			session[:connect] = nil

			flash[:success] = "Profile Updated"
			redirect "/users/#{@user.id}"

		else
			status(412)
			@user.errors.each do |e|
		    puts e
			end
			flash[:error] = "Please try again."
			redirect back
		end

	else
		puts "regular puts"

		@user.attributes = params[:user]


		puts params[:user][:location]

		if (!params[:user][:image].nil?)
			puts "Its not nill"
			@user.image = make_paperclip_mash(params[:user][:image])
		end

		if @user.save
			status(202)
			flash[:success] = "Profile Updated"
			redirect "/users/#{@user.id}"
		else
			status(412)
			@user.errors.each do |e|
		    puts e
			end
			flash[:error] = "Please try again."
			redirect back
		end
	end

end

def make_paperclip_mash(file_hash)
  mash = Mash.new
  mash['tempfile'] = file_hash[:tempfile]
  mash['filename'] = file_hash[:filename]
  mash['content_type'] = file_hash[:type]
  mash['size'] = file_hash[:tempfile].size
  mash
end

##############################################################

# Show add new user page
get '/users/new' do
	@title = "New User"
	@user = User.new
	
	erb :'users/new'	
end

# Show edit user page
get '/users/:id/edit' do
	@title = "Edit User"
	@user = User.get(params[:id])
	
	erb :'users/edit'	
end