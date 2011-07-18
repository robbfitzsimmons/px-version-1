# Create a new actvitity Page
get '/activities/new' do
	@activity = Activity.new()

	erb :'activities/new'
end

# Create an activity action
post '/activities' do
	activity = Activity.new(params[:activity])
	event = Event.get(session[:event])

	activity.start_date = DateTime.new(2011, 8, params[:start_day].to_i, params[:start_hour].to_i, 0)
	activity.end_date = DateTime.new(2011, 8, params[:end_day].to_i, params[:end_hour].to_i, 0)
	activity.event = event


	if activity.save
		status(202)
		flash[:success] = "Activity Added Successfully."

		redirect "/events/#{event.permalink}"
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