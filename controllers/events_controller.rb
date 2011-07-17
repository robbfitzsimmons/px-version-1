
# Create a new Event Page
get '/events/new' do
	if @event.nil?
		puts "NEW EVENT"
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

# Show a specific event
get '/events/:permalink' do
	
	@event = Event.first(:permalink => params[:permalink].downcase)
	@title = "#{@event.name}"

	erb :'events/show'	
end