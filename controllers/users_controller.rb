# Sign up Authenticates with OmniAuth via OmniAuthController
get '/signup' do
	erb :'users/sign_up', {:layout => :sessions_layout}
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
	elsif params[:sign_up] == "Twitter"
		redirect '/auth/twitter'
	elsif params[:sign_up] == "Facebook"
		redirect '/auth/facebook'
	elsif params[:sign_up] == "Sign Up"
		redirect '/signup/step2'
	end
end

get '/signup/step2' do
	@user = session[:user]
	@user = User.new() if @user.class != User

	erb :'users/step2', {:layout => :sessions_layout}
end

post '/signup/step2' do
	@user = User.new(params[:user])

	@user.email = @user.email.downcase
	
	admin_emails = %w{"pdudley89@gmail.com", "philip.dudley@quinnipiac.edu", "sarahcanieso@gmail.com" "scanieso@gmail.com", "fongandrew@gmail.com", "hugo.vanvuuren@gmail.com", "rvfitzsimmons@gmail.com"} 
	@user.curator = true if admin_emails.one? {|admin_email| admin_email.match(@user.email)}

	if @user.save
		status(202)

		session[:invite_event] = nil
		session[:invite] = nil

		@user.invites = Invite.all(:email => @user.email)

		## TEMP FIX
		## Add people to event automatically
		if @user.invites.count != 0
			event = @user.invites.events.first
			event.users << @user
			event.save
			invite = @user.invites.first(:event => event)
			invite.hide = true
			invite.save
			assoc = event.user_event_associations.first(:user => @user)
			assoc.attending = true
			assoc.save
			puts "done"
		end
		## END TEMP FIX

		@user.save

		session[:user] = @user.id
		flash[:success] = "Welcome to your dashboard, <em>#{@user.name}</em>."
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
	my_account?

	@user_dashboard = true
	@title = "Dashboard"
	@user = User.get(params[:id])



	@matches = @user.people_matches
	@total_matches = current_user.organizations.users(:id.not => current_user.id) + current_user.interests.users(:id.not => current_user.id)

	count = 0

	count += 1 if (!@user.email.blank?)					#1
	count += 1 if (!@user.name.blank?)					#2
	count += 1 if (!@user.description.blank?)		#3
	count += 1 if (!@user.location.blank?)			#4
	count += 1 if (!@user.education.blank?)			#5
	count += 1 if (!@user.work.blank?)					#6
	count += 1 if (!@user.website.blank?)				#7
	count += 1 if (!@user.interests.empty?)			#8
	count += 1 if (!@user.organizations.empty?)	#9
	count += 1 if (!@user.facebook.blank?)			#10
	count += 1 if (!@user.linked_in.blank?)			#11
	count += 1 if (!@user.twitter.blank?)			#12
	count += 1 if (@user.image.url != "/images/original/missing.png")	#13

	@progress = ((count/13.0) * 100).round(0) 

	session[:connect] = nil
	
	erb :'users/show'	
end

get '/users/:id/connect' do
	my_account?

	@title = "Connect Your Social Accounts"
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
	elsif params[:connect] == "Twitter"
		redirect '/auth/twitter'
	end

end

get '/users/:id/approve' do

	@title = "Approve New Information"
	@user = session[:user_info]
	
	erb :'users/approve'	
end


put '/users/:id' do
	my_account?
	

	@user = User.get(params[:id])

	## Handle Interests
	@old_interests = @user.interests
	if !params[:interests].nil?
		@interests = params[:interests].squeeze(" ").strip.split(",")
		@interests.each do |interest|
			@old_interests.delete_if{ |old_interest| (old_interest.name == interest)}
		end
		# Old interests now contains interests that are to be removed
		@old_interests.each do |old_interest|
			@link = InterestUser.get(old_interest.id, @user.id)

			## If No one else likes it, remove the interest, if someone does just remove it for this user
			if @link.interest.users.count == 1
				@link.interest.destroy
			else
				@user.interests.delete_if{ |interest| (old_interest.name == interest.name)}
				@user.save
			end
		end
		@interests.each do |interest|
			@user.interests << Interest.first_or_create(:name => interest)
		end
	end

	## Handle Organizations
	@old_organizations = @user.organizations
	if !params[:organizations].nil?
		@organizations = params[:organizations].squeeze(" ").strip.split(",")
		@organizations.each do |organization|
			@old_organizations.delete_if{ |old_organization| (old_organization.name == organization)}
		end
		# Old organizations now contains organizations that are to be removed
		@old_organizations.each do |old_organization|
			@link = OrganizationUser.get(old_organization.id, @user.id)

			## If No one else likes it, remove the organization, if someone does just remove it for this user
			if @link.organization.users.count == 1
				@link.organization.destroy
			else
				@user.organizations.delete_if{ |organization| (old_organization.name == organization.name)}
				@user.save
			end
		end
		@organizations.each do |organization|
			@user.organizations << Organization.first_or_create(:name => organization)
		end
	end




	puts @user.attribute_dirty?(:password)

	if (session[:connect] == true)

		if (params[:user][:image_url] != nil)
			@user.image_url = params[:user][:image_url]
		end

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
			@user.facebook_uid = params[:user][:facebook_uid]
		end

		if (params[:user][:twitter] != nil)
			@user.twitter = params[:user][:twitter]
			@user.twitter_uid = params[:user][:twitter_uid]
		end

		if @user.save
			status(202)

			session[:connect] = nil

			flash[:success] = "Profile updated successfully."
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
		puts @user.attribute_dirty?(:password)

		@user.attributes = params[:user]
		#@user.password = params[:password]

		if (!params[:user][:image].nil?)
			@user.image = make_paperclip_mash(params[:user][:image])
		end

		if @user.save
			puts @user.password
			puts @user.salt
			status(202)
			flash[:success] = "Profile updated successfully."
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



##############################################################

# Show add new user page
get '/users/new' do

	@title = "New User"
	@user = User.new
	
	erb :'users/new'	
end

# Show edit user page
get '/users/:id/edit' do
	my_account?

	@title = "Edit Nametag"
	@user = User.get(params[:id])

	@all_interests = Interest.all(:order => [ :name.asc])
	@all_organizations = Organization.all(:order => [ :name.asc])
	
	erb :'users/edit'	
end

# Show nametag
get '/users/:id/nametag' do
	my_account?

	@user = User.get(params[:id])
	@title = "#{@user.name}'s Nametag"
	
	erb :'users/nametag'	
end