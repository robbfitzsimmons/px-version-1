## Step 1 Authenticate with Linked in
get '/signup' do

	erb :'users/sign_up'
end


get '/auth/:name/callback' do
	auth = request.env['omniauth.auth']
	
	# PP::pp(auth, $stderr, 50)
	# Search for a user with the name
	@user = User.first(:name => auth["user_info"]["name"])
	
	# If user does not exist create a new one
	if (@user == nil)
	
		@user = User.new
	
		@user.attributes = {
			:name         => auth["user_info"]["name"],
			:description  => auth["user_info"]["description"],
			:location     => auth["user_info"]["location"],
			
			# For twitter drop the _normal for full size, _bigger works too
			:image     => auth["user_info"]["image"]
		}
		
	end
	
	# if it is linked_in and linked_in has not been filled out
	if (auth["provider"] == "linked_in" && @user.linked_in == nil)
		puts "ITS LINKED IN"
		@user.linked_in = auth["user_info"]["urls"]["LinkedIn"]
		
		if (@user.website == nil)
			@user.website = auth["user_info"]["urls"]["Personal Website"]
		end
	end
	
	# if it is twitter and twitter has not been filled out
	if (auth["provider"] == "twitter" && @user.twitter == nil)
		puts "ITS TWITTER"
		@user.twitter = auth["user_info"]["urls"]["Twitter"]
			if (@user.website == nil)
				@user.website = auth["user_info"]["urls"]["Website"]
			end
	end
	
	puts @user.linked_in

	session[:user] = @user

	redirect '/signup/step2'

end

get '/signup/step2' do
	@user = session[:user]

	erb :'users/step2'
end

post '/signup/step2' do
	@user = User.new(params[:user])

	if @user.save
		status(202)
		redirect '/users/#{@user.id}'
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