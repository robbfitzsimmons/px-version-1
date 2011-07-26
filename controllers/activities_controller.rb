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

	activity.start_date = DateTime.new(session.start_date.year, session.start_date.month, session.start_date.mday, params[:start_hour].to_i, 0)
	activity.end_date = DateTime.new(session.start_date.year, session.start_date.month, session.start_date.mday, params[:end_hour].to_i, 0)
	activity.session = session
	activity.users << User.get(params[:speaker])


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
		redirect "/activities/new"
	end
end

# Create a new actvitity Page
get '/activities/edit/:id' do
	@activity = Activity.get(params[:id])
	@event = @activity.event

	erb :'activities/edit'
end