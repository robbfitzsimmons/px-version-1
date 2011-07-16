# Sign up Authenticates with OmniAuth via OmniAuthController
get '/signup' do
	erb :'users/sign_up'
end


get '/signup/step2' do
	@user = session[:user]

	erb :'users/step2'
end

post '/signup/step2' do
	@user = User.new(params[:user])

	if @user.save
		status(202)
		redirect "/users/#{@user.id}"
	else
		status(412)
		@user.errors.each do |e|
		    puts e
		end
		redirect '/signup/step2'
	end
end

# Show a specific user
get '/users/:id' do
	@title = "User"
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

# Add new user
post '/users' do
	@user = User.new(params[:user])

	if @user.save
	
	else

	end	
end

# Edit existing user
put '/users/:id' do
	@user = User.find(params[:id])

	if @user.save
	
	else

	end	
end

# Delete existing user
delete '/users/:id' do
	@user = User.find(params[:id])

	if @user.destroy
	
	else

	end	
end