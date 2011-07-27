# Create a new Event Page
get '/events/new' do
	@title = "Create New Event"
	@new = true
	
	if @event.nil?
		@event = Event.new()
	end

	erb :'events/new'
end

# Edit an event Page
get '/:permalink/edit' do
	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "Edit #{@event.name}"
	
	erb :'events/edit'
end

# Create an event action
post '/events' do
	@event = Event.new(params[:event])

	start_day = params[:start_day].split("/")
	end_day = params[:end_day].split("/")

	@event.start_date = DateTime.new(start_day[2].to_i, start_day[0].to_i, start_day[1].to_i, 9, 0)
	@event.end_date = DateTime.new(start_day[2].to_i, start_day[0].to_i, start_day[1].to_i, 9, 0)
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

put '/events/:id/rsvp' do

	event = Event.get(params[:id])

	puts params[:attend]

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
put '/events/:id' do

	puts "put"

	event = Event.get(params[:id])

	puts event.name

	event.attributes = params[:event]

	if (!params[:event][:image].nil?)
		event.image = make_paperclip_mash(params[:event][:image])
	end

	if event.save
		status(202)
		flash[:success] = "Event Updated"
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

	@event_dashboard = true
	
	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "#{@event.name}"

	if is_event_admin(@event)
		session[:event] = @event.id
	end
	erb :'events/show'	
end

# Show a specific event
get '/:permalink/attendees' do
	
	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "#{@event.name} Attendees (#{@event.user_event_associations(:attending => true).count})"

	erb :'events/attendees'	
end

# Show events worksheet (list of invites/ checked in)
get '/events/:permalink/worksheet' do
	@event = Event.first(:permalink => params[:permalink].downcase)

	@title = "#{@event.name} Worksheet"

	erb :'events/worksheet'
end

# Show the events questions
get '/:permalink/questions' do

		@event = Event.first(:permalink => params[:permalink].downcase)

    if current_user.questions_this_event(@event).count == 0
    	flash[:warning] = "You have already answered all the questions for this event."
    end

	session[:event] = @event.id

	@title = "#{@event.name} Questions"

	erb :'events/questions/questions'
end

# Show events questions with answer fields for attendee
get '/:permalink/questions/answer' do

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



