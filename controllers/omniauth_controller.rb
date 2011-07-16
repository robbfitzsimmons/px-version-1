get '/auth/:name/callback' do
	auth = request.env['omniauth.auth']
	
	# PP::pp(auth, $stderr, 50)
	# Search for a user with the name
	if(auth["provider"] == "linked_in")
		@user = User.first(:linked_in => auth["user_info"]["urls"]["LinkedIn"])
	elsif(auth["provider"] == "twitter")
		@user = User.first(:twitter => auth["user_info"]["urls"]["Twitter"])
	end
	
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

	else
		# The user already exists, so lets log them in :)

		# And redirect them to their profile page
		session[:user] = @user
		redirect "/users/#{@user.id}"
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