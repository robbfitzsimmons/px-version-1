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


	@event_dashboard = true
	
	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "Event: #{@event.name}"

	count = 0

	count += 1 if (!@event.name.blank?)					#1
	count += 1 if (!@event.description.blank?)					#2
	count += 1 if (!@event.location.blank?)		#3
	count += 1 if (!@event.start_date.blank?)			#4
	count += 1 if (!@event.color.blank?)			#5
	count += 1 if (@event.image.url != "/images/original/missing.png")	#6
	count += 1 if  (!@event.invites.empty?)	#7

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

	total = 7.0 + i

	@progress = ((count/total) * 100).round(0) 

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



