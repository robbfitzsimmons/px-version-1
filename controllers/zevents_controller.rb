# Create a new Event Page
get '/events/new' do


	if not current_user.curator
		flash[:error] = "This feature is currently private."
		redirect back
	end


	@title = "Create New Event"
	@new = true
	
	if @event.nil?
		@event = Event.new()
	end

	erb :'events/new'
end

# Edit an event Page
get '/:permalink/edit' do
	my_permalink?

	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "Edit #{@event.name}"
	
	erb :'events/edit'
end

# Create an event action
post '/events' do

		if not current_user.curator
		flash[:error] = "This feature is currently private."
		redirect back
	end

	@event = Event.new(params[:event])

	start_day = params[:start_day].split("/")
	end_day = params[:end_day].split("/")

	@event.start_date = DateTime.new(start_day[2].to_i, start_day[0].to_i, start_day[1].to_i, 9, 0)
	@event.end_date = DateTime.new(end_day[2].to_i, end_day[0].to_i, end_day[1].to_i, 9, 0)
	@event.users << current_user

	if (!params[:event][:image].nil?)
			@event.image = make_paperclip_mash(params[:event][:image])
	end


	if @event.save
		status(202)
		flash[:success] = "Event added successfully."

		# Make Admin of their Created Event
		@event.user_event_associations.each do |assoc|
			if assoc.event == @event
				assoc.admin = true
				assoc.attending = true
				assoc.save
			end
		end
		current_user.events << @event
		current_user.save
		session[:event] = @event.id

		redirect "/#{@event.permalink}"
	else
		status(412)
		@event.errors.each do |e|
		    puts e
		end
		flash[:error] = "Please try again."
		# Changes url to /events rather than events/new
		#erb :'events/new'
		redirect "/events/new"
	end
end

put '/:permalink/rsvp' do
	invited_to_event?

	event = Event.first(:permalink => params[:permalink].downcase)

	if params[:attend] != "Attend"
		event.users << current_user
		if event.save
			current_user.user_event_associations.first(:event => event).update(:attending => false)
			flash[:success] = "You are now not attending <em>#{event.name}</em>."
			if !session[:invite].nil?
				invite = Invite.get(session[:invite])
				invite.update(:hide => true)
				session[:invite_event] = nil
			end
		else
			status(412)
			event.errors.each do |e|
		    puts e
			end
			flash[:error] = "Please try again."
		end
	else
		event.users << current_user
		if event.save
			status(202)
			current_user.user_event_associations.first(:event => event).update(:attending => true)
			flash[:success] = "You are now attending <em>#{event.name}</em>."
			if !session[:invite].nil?
				invite = Invite.get(session[:invite])
				invite.update(:hide => true)
				session[:invite_event] = nil
			end
		else
			status(412)
			event.errors.each do |e|
		    puts e
			end
			flash[:error] = "Please try again."
		end
	end
	redirect "/#{event.permalink}"

end

# Used for updating an event
put '/:permalink' do
	invited_to_event?

	event = Event.first(:permalink => params[:permalink].downcase)
	event.attributes = params[:event]

	if (!params[:event][:image].nil?)
		event.image = make_paperclip_mash(params[:event][:image])
	end

	if event.save
		status(202)
		flash[:success] = "Event updated successfully."
		redirect "/#{event.permalink}"
	else
		status(412)
		event.errors.each do |e|
	    puts e
		end
		flash[:error] = "Please try again."
		redirect back
	end
end

# Show a specific event
get '/:permalink' do
	
	dissallowed_names = %w{"/auth", "/login", "/logout", "/recover", "/users", "/invites", "/activities", "/questions", "/events", "/sessions"} 
	pass if dissallowed_names.one? {|dissallowed_name| dissallowed_name.match(request.path_info)}

	invited_to_event?


	@event_dashboard = true
	
	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "Event: #{@event.name}"

	all_attendees = @event.user_event_associations(:attending => true)
	@attendees = []
	if all_attendees.count < 4
		@attendees = all_attendees
	else
		while(@attendees.count < 4) do 
			random = rand(all_attendees.length)
		  @attendees << all_attendees[random] if (!@attendees.include? all_attendees[random])
		end
	end

	count = 0

	count += 1 if (!@event.name.blank?)					#1
	count += 1 if (!@event.description.blank?)					#2
	count += 1 if (!@event.location.blank?)		#3
	count += 1 if (!@event.start_date.blank?)			#4
	count += 1 if (!@event.color.blank?)			#5
	count += 1 if (@event.image.url != "/images/original/missing.png")	#6
	count += 1 if  (!@event.invites.empty?)	#7
	count += 1 if  (!@event.questions.empty?)	#8

	i = 0.0
	@event.days.each do |day|
		count += 1 if (!day.sessions.empty?)
		i += 1.0
	end

	if !@event.days.sessions.nil?
		@event.days.sessions.each do |session|
			count += 1 if (!session.activities.empty?)
			i += 1.0
		end
	end

	total = 8.0 + i

	@progress = ((count/total) * 100).round(0) 

	
		puts "NORMAL"
		puts session[:invite]
		if is_event_admin(@event)
			session[:event] = @event.id
		end
		erb :'events/show'
end

# Show a specific event
get '/:permalink/preview' do

	if !current_user.nil?
		redirect "/#{params[:permalink]}"
	end

	@event_dashboard = true
	
	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "Event: #{@event.name}"

	all_attendees = @event.user_event_associations(:attending => true)
	@attendees = []
	if all_attendees.count < 4
		@attendees = all_attendees
	else
		while(@attendees.count < 4) do 
			random = rand(all_attendees.length)
		  @attendees << all_attendees[random] if (!@attendees.include? all_attendees[random])
		end
	end 

		puts "JUST AN INVITE"
		puts session[:invite]
		erb :'events/preview', {:layout => :sessions_layout}
end

# Show a specific event
get '/:permalink/attendees' do

	invited_to_event?
	
	@attendee = true
	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "#{@event.name} Attendees (#{@event.user_event_associations(:attending => true).count})"

	erb :'events/attendees'	
end

get '/:permalink/nametags' do
		
		my_permalink?

	 @event = Event.first(:permalink => params[:permalink].downcase)
	 @users = @event.user_event_associations(:attending => true).users


	 erb :'events/nametags', {:layout => :print_layout}
end

get '/:permalink/nametags.pdf' do

	 	content_type 'application/pdf'
    kit = PDFKit.new("http://localhost:9292/#{params[:permalink]}/nametags")
    kit.to_pdf
 
end

# Show events worksheet (list of invites/ checked in)
get '/:permalink/worksheet' do

	my_permalink?
	@event = Event.first(:permalink => params[:permalink].downcase)

	@title = "#{@event.name} Worksheet"

	erb :'events/worksheet'
end

# Show the events questions
get '/:permalink/questions' do

	my_permalink?

	@event = Event.first(:permalink => params[:permalink].downcase)

	session[:event] = @event.id

	@title = "#{@event.name} Questions"

	erb :'events/questions/questions'
end

# Show events questions with answer fields for attendee
get '/:permalink/questions/answer' do

		invited_to_event?

		@event = Event.first(:permalink => params[:permalink].downcase)
		@answer = Answer.new()

    if current_user.questions_this_event(@event).count == 0
    	flash[:warning] = "You have already answered all the questions for this event."
    	redirect back
    end

	session[:event] = @event.id

	@title = "#{@event.name} Questions"

	erb :'events/questions/answer'
end

# Delete an event
delete '/:permalink' do

	dissallowed_names = %w{"/login", "/logout", "/recover", "/users", "/invites", "/activities", "/questions", "/events", "/sessions"} 
	pass if dissallowed_names.one? {|dissallowed_name| dissallowed_name.match(request.path_info)}

	my_permalink?
	
	event = Event.first(:permalink => params[:permalink].downcase)

	event.days.sessions.activities.presentations.destroy
	event.days.sessions.activities.destroy
	event.days.sessions.destroy
	event.days.destroy

	event.invites.destroy
	event.user_event_associations.destroy

	event.questions.answers.destroy
	event.questions.destroy

	if event.destroy
		
		status(202)
		flash[:success] = "#{event.name} deleted successfully."
		redirect "/users/#{current_user.id}"
	else
		status(412)
		event.errors.each do |e|
	    puts e
		end
		flash[:error] = "Please try again."
		redirect back
	end

end
