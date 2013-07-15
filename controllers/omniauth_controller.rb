##require 'pp'

get '/auth/:name/callback' do
	auth = request.env['omniauth.auth']

	## This involves signup/ login
	if session[:connect] == false || session[:connect].nil?
	
		#puts auth["provider"]
		##puts PP::pp(auth, $stderr, 50)
		# Search for a user with the name
		if(auth["provider"] == "linked_in")
			@user = User.first(:linked_in_uid => auth["uid"])
		elsif(auth["provider"] == "twitter")
			@user = User.first(:twitter_uid => auth["uid"])
		elsif(auth["provider"] == "facebook")
			@user = User.first(:facebook_uid => auth["uid"])
		end
		
		# If user does not exist create a new one
		if (@user == nil)
		
			@user = User.new
		
			@user.attributes = {
				:name         => auth["user_info"]["name"],
				:description  => auth["user_info"]["description"],
				:location     => auth["user_info"]["location"],
				
				# For twitter drop the _normal for full size, _bigger works too
				:image_url     => auth["user_info"]["image"]
			}

		else
			# The user already exists, so lets log them in :)
			# And redirect them to their profile page
			puts "They exist already"
			session[:user] = @user.id
			flash[:success] = "Welcome back, <em>#{@user.name}</em>."
			puts "Logged them in as user #{session[:user]}"
			session[:invite_event] = nil
			session[:invite] = nil
			redirect "/users/#{@user.id}"
		end
		
		# if it is linked_in and linked_in has not been filled out
		if (auth["provider"] == "linked_in" && @user.linked_in == nil)
			puts "ITS LINKED IN"
			@user.linked_in = auth["user_info"]["urls"]["LinkedIn"]
			@user.linked_in_uid = auth["uid"]
			if (@user.website == nil)
				@user.website = auth["user_info"]["urls"]["Personal Website"]
			end
		
		# if it is twitter and twitter has not been filled out
		elsif (auth["provider"] == "twitter" && @user.twitter == nil)
			puts "ITS TWITTER"
			@user.twitter = auth["user_info"]["urls"]["Twitter"]
			@user.twitter_uid = auth["uid"]
			@user.image_url = @user.image_url.gsub("_normal", "")
				if (@user.website == nil)
					@user.website = auth["user_info"]["urls"]["Website"]
				end

		# if it is facebook and facebook has not been filled out
		elsif (auth["provider"] == "facebook" && @user.facebook == nil)
			puts "ITS FACEBOOK"
			@user.facebook = auth["user_info"]["urls"]["Facebook"]
			@user.facebook_uid = auth["uid"]
			
			if !auth["extra"]["user_hash"]["location"].nil?
				@user.location = auth["extra"]["user_hash"]["location"]["name"]
			end
			image = @user.image_url.split('=')
			@user.image_url = image[0]+"=normal"
				if (@user.website == nil)
					@user.website = auth["user_info"]["urls"]["Website"]
				end
		end

		session[:user] = @user

		redirect '/signup/step2'
	
	# This involves connecting additional accounts
	else
		@user = User.new

		if (current_user.description.blank?)
			@user.description = auth["user_info"]["description"]
		end

		if (current_user.location.blank?)
			@user.location = auth["user_info"]["location"]
		end


		## It is linked in
		if (auth["provider"] == "linked_in")
			@user.linked_in = auth["user_info"]["urls"]["LinkedIn"]
			@user.linked_in_uid = auth["uid"]
			@user.image_url = auth["user_info"]["image"] if (current_user.image.url == "/images/original/missing.png")
		## It is facebook
		elsif (auth["provider"] == "facebook")
			@user.facebook = auth["user_info"]["urls"]["Facebook"]
			@user.facebook_uid = auth["uid"]
			puts "#{@user.facebook_uid} is the uid"
			@user.image_url = auth["user_info"]["image"] if (current_user.image.url == "/images/original/missing.png")
			image = @user.image_url.split('=')	if (current_user.image.url == "/images/original/missing.png")
			@user.image_url = image[0]+"=normal" if (current_user.image.url == "/images/original/missing.png")
		
		elsif (auth["provider"] == "twitter")
			@user.twitter = auth["user_info"]["urls"]["Twitter"]
			@user.twitter_uid = auth["uid"]
			@user.image_url = auth["user_info"]["image"].gsub("_normal", "") if (current_user.image.url == "/images/original/missing.png")
		end

		session[:user_info] = @user

		flash[:success] = "When you save, your #{auth["provider"].capitalize.sub("_", "")} account will be added."


		redirect "/users/#{current_user.id}/approve"
	end

end