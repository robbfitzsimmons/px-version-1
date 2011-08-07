# Send an invite page
get '/:permalink/invites/new' do
	my_permalink?

	@title = 'Send Invites'
	@invite = Invite.new()
	@event = Event.first(:permalink => params[:permalink].downcase)

	erb :'invites/new'
end

post '/invites' do

	event = current_event

	my_event?(event)

	## Remove All White Space
	emails = params[:emails].gsub(/ /,'')
	puts emails
	# Split emails at the commas
	emails = emails.split(',')

	subject = params[:subject]
	message = params[:message]
	admin = current_user
	

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
			if (ENV['RACK_ENV']) == "production"

				initialize_email

				#Send Email
				mail = Mail.new do          
				  to "<#{invite.email}>"         
				  from 'Proximate Staff <no-reply@proximate.com>'     
				  subject "#{subject}"
				end  

				html_part = Mail::Part.new do |part| 
		      part.content_type 'text/html; charset=UTF-8' 
		      part.body("
					<div style='background: #f9f9f9;' leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>
						<center>
							<table style='padding: 50px 0' width='656' height='182' border='0' cellpadding='0' cellspacing='0'>
								<tr>
									<td rowspan='2'>
										<img src='http://bulldozer.heroku.com/images/mailer/proximate_logo.png' width='330' height='182' alt=''></td>
									<td>
										<img src='http://bulldozer.heroku.com/images/mailer/your_invited.png' width='326' height='40' alt=''></td>
								</tr>
								<tr>
									<td style='padding: 10px 4px'>
										<p style='font-size: 16px; line-height: 1.5em; color: #a4a4a4; font-family: Helvetica, Arial, sans-serif;'>Hello #{invite.email},</p>
										<p style='font-size: 16px; line-height: 1.5em; color: #a4a4a4; font-family: Helvetica, Arial, sans-serif;'>#{message}<br />
										#{admin.name}
										</p>
										<hr style='background: #fff; border: none; border-bottom: 1px solid #e6e6e6; height: 1px;' />
										<p style='font-size: 13px; line-height: 1.5em; color: #a4a4a4; font-family: Helvetica, Arial, sans-serif;'>Please follow this link to check out #{admin.name}'s, <em>#{event.name}</em>.
												<a href='http://bulldozer.heroku.com/invites/#{invite.slug}'>http://bulldozer.heroku.com/invites/#{invite.slug}</a>
										</p>
										<p style='font-size: 13px; line-height: 1.5em; color: #a4a4a4; font-family: Helvetica, Arial, sans-serif;'>Thank you,<br /> 
										The Proximate Team</p>	
									</td>
								</tr>
							</table>
						</center>
						</div>

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
		flash[:warning] = "Some invites sent unsuccessfully. Please check the attendee worksheet."
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

	redirect "/#{invite.event.permalink}/preview"
end
