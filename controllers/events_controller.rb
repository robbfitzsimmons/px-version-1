
# Create a new Event Page
get '/events/new' do
	@title = "Create New Event"
	if @event.nil?
		@event = Event.new()
	end

	erb :'events/new'
end

# Create an event action
post '/events' do
	@event = Event.new(params[:event])

	@event.start_date = DateTime.new(2011, 8, params[:start_day].to_i, 9, 0)
	@event.end_date = DateTime.new(2011, 8, params[:end_day].to_i, 9, 0)
	@event.users << current_user


	if @event.save
		status(202)
		flash[:success] = "Event Added Successfully."

		# Make Admin of their Created Event
		@event.user_event_associations.each do |assoc|
			if assoc.event == @event
				assoc.admin = true
				assoc.save
			end
		end
		current_user.events << @event
		current_user.save
		session[:event] = @event.id

		redirect "/events/#{@event.permalink}"
	else
		status(412)
		@event.errors.each do |e|
		    puts e
		end
		flash[:error] = "Please Try Again."
		# Changes url to /events rather than events/new
		#erb :'events/new'
		redirect "/events/new"
	end
end

put '/events/:id/rsvp' do

	event = Event.get(params[:id])

	## Attending to Not Attending
	if !current_user.user_event_associations.first(:event => event).nil?
		current_user.user_event_associations.first(:event => event).destroy
		flash[:success] = "You are now not attending #{event.name}."

		redirect "/events/#{event.permalink}"
	
	## Not attending to Attending
	else
		event.users << current_user

		if event.save
			status(202)
			flash[:success] = "You are now attending #{event.name}."
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
			flash[:error] = "Please Try Again."
		end

		redirect "/events/#{event.permalink}"

	end

end

# Used for updating an event, including adding a user
put '/events/:id' do

	event = Event.get(params[:id])

	if event.save
		status(202)
		flash[:success] = "You have now updated #{event.name}."
	else
		status(412)
		event.errors.each do |e|
		    puts e
		end
		flash[:error] = "Please Try Again."
	end

	redirect "/events/#{event.permalink}"
end

# Show a specific event
get '/events/:permalink' do

	@event_dashboard = true
	
	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "#{@event.name}"

	if is_event_admin(@event)
		session[:event] = @event.id
	end
	erb :'events/show'	
end

# Show events worksheet (list of invites/ checked in)
get '/events/:permalink/worksheet' do
	@event = Event.first(:permalink => params[:permalink].downcase)

	@title = "#{@event.name} Worksheet"

	erb :'events/worksheet'
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



