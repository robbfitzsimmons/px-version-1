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
		flash[:warning] = "Facebook is not currently supported"
		redirect '/signup/step2'
	elsif params[:sign_up] == "Sign Up"
		redirect '/signup/step2'
	end
end


get '/signup/step2' do
	@user = session[:user]

	@user = User.new() if @user.nil?

	erb :'users/step2', {:layout => :static_layout}
end

post '/signup/step2' do
	@user = User.new(params[:user])

	if @user.save
		status(202)
		session[:user] = @user.id
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
	
	erb :'users/show'	
end

##############################################################
# Show all users
get '/users' do

	@title = "All Users"
	@users = User.all
	
	erb :'users/index'	
end



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