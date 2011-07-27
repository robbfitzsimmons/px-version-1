# Create a new actvitity Page
get '/activities/new' do
	@event = Event.get(session[:event])

	@session = Session.get(params[:sessions])

	puts @session.name

	# need to get the day
	@activity = Activity.new()

	@title = "Create New Activity"

	erb :'activities/new'
end

# Create an activity action
post '/activities' do
	session = Session.get(params[:session])
	activity = Activity.new(params[:activity])
	event = session.day.event

	if params[:start_ampm].downcase == "pm"
		if params[:start_hour].to_i < 12
			start_hour = params[:start_hour].to_i + 12
		else
			start_hour = params[:start_hour].to_i
		end
	elsif params[:start_ampm].downcase == "am"
		if params[:start_hour].to_i == 12
			start_hour = 0
		else
			start_hour = params[:start_hour].to_i
		end
	else
		puts "UHOH"
	end

	if params[:end_ampm].downcase == "pm"
		if params[:end_hour].to_i < 12
			end_hour = params[:end_hour].to_i + 12
		else
			start_hour = params[:start_hour].to_i
		end
	elsif params[:end_ampm].downcase == "am"
		if params[:end_hour].to_i == 12
			end_hour = 0
		else
			end_hour = params[:end_hour].to_i
		end
	end

	activity.start_date = DateTime.new(session.start_date.year, session.start_date.month, session.start_date.mday, start_hour, params[:start_minute].to_i)
	activity.end_date = DateTime.new(session.start_date.year, session.start_date.month, session.start_date.mday, end_hour, params[:end_minute].to_i)
	activity.session = session

	if(params[:speaker] != "None")
		activity.users << User.get(params[:speaker])
	end

	if activity.save
		status(202)
		flash[:success] = "#{activity.name} Added Successfully."

		redirect "/#{event.permalink}"
	else
		status(412)
		activity.errors.each do |e|
		    puts e
		end
		flash[:error] = "Please Try Again."
		# Changes url to /activitys rather than activitys/new
		#erb :'activitys/new'
		redirect back
	end
end

# Create a new actvitity Page
get '/activities/edit/:id' do
	@activity = Activity.get(params[:id])
	@event = @activity.event

	erb :'activities/edit'
end