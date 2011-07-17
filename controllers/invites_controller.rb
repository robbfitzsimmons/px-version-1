# Send an invite page
get '/invites/new' do
	
	@invite = Invite.new()

	erb :'invites/new'
end

post '/invites' do

	puts "admin = #{is_event_admin(current_event)}"
	puts params[:emails]
	
	## Remove All White Space
	emails = params[:emails].gsub(/ /,'')
	puts emails
	# Split emails at the commas
	emails = emails.split(',')
	puts emails

	## For each name send an invite
	emails.each do |email|
		invite = Invite.new(:email => email, :event => current_event)
		existing_user = User.first(:email => email)
		invite.user = existing_user if (existing_user.nil? == false)
		
		if invite.save
			status(202)
			puts "Sent to #{email}"
		else
			status(412)
			invite.errors.each do |e|
			    puts e
			end
		end
	end
	redirect "/events/#{current_event.permalink}"
end