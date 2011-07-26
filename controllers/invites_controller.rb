# Send an invite page
get '/invites/new' do
	
	@invite = Invite.new()
	@event = current_event

	erb :'invites/new'
end

post '/invites' do

	puts "admin = #{is_event_admin(current_event)}"
	
	## Remove All White Space
	emails = params[:emails].gsub(/ /,'')
	puts emails
	# Split emails at the commas
	emails = emails.split(',')

	subject = params[:subject]
	message = params[:message]
	admin = current_user
	event = current_event

	# 1 = Success all answers added, #2 = Some failed, #3 = all failed
	success = 1
	i = 0

	## For each name send an invite
	emails.each do |email|
		invite = Invite.new(:email => email, :event => current_event)
		existing_user = User.first(:email => email)
		invite.user = existing_user if (existing_user.nil? == false)

		
		if invite.save
			status(202)
			if (ENV['RACK_ENV']) == "zproduction"
				#Send Email
				mail = Mail.new do          
				  to "<#{invite.email}>"         
				  from 'Proximate Staff <no-reply@proximate.com>'     
				  subject "#{subject}"
				end  

				html_part = Mail::Part.new do |part| 
		      part.content_type 'text/html; charset=UTF-8' 
		      part.body("
		      	<p>Hello #{invite.email},</p>
		      	<p>#{message}</p>
		      	<p>Thank you, <br />
						#{admin.name}</p>
		      	<hr />
						<p>Please follow this link to check out #{admin.name}'s event #{event.name}
						<a href='http://localhost:9292/events/#{event.permalink}'>http://localhost:9292/events/#{event.permalink}</a></p>
						<p>Thank you, <br />
						The Proximate Team
						</p>
		      ") 
		 		end 
		  	mail.html_part = html_part
				mail.deliver
			end
			if success == 1
				success = 1
			else
				success = 2
			end
		else
			status(412)
			invite.errors.each do |e|
			    puts e
			end
			if success == 3 || (emails.count.to_i) == (emails.count.to_i) - i
				success = 3
			else
				success = 2
			end
		end
		i = i + 1
	end

	if success == 1
		flash[:success] = "Invites sent successfully."
	elsif success == 2
		flash[:warning] = "Some invites sent unsuccessfully, please check the attendee worksheet."
	elsif success == 3
		flash[:error] = "Invites sent unsuccessfully."
	end

	redirect "/#{current_event.permalink}"
end

get '/invites/:slug' do
	
	invite = Invite.first(:slug => params[:slug])
	status(200)
	invite.update(:visited =>  true)

	session[:invite_event] = invite.event.id
	session[:invite] = invite.id

	redirect "/#{invite.event.permalink}"
end
