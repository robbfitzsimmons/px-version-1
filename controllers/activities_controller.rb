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
	end

	if params[:end_ampm].downcase == "pm"
		if params[:end_hour].to_i < 12
			end_hour = params[:end_hour].to_i + 12
		else
			end_hour = params[:end_hour].to_i
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
		flash[:success] = "<em>#{activity.name}</em> added successfully."

		redirect "/#{event.permalink}"
	else
		status(412)
		activity.errors.each do |e|
		    puts e
		end
		flash[:error] = "Please try again."
		# Changes url to /activitys rather than activitys/new
		#erb :'activitys/new'
		redirect back
	end
end

# Create a new actvitity Page
get '/:permalink/activities/:id/edit' do
	@activity = Activity.get(params[:id])
	@event = @activity.session.day.event

	@start_hour = @activity.start_date.hour
	@start_min = @activity.start_date.strftime("%M")

	if @start_hour < 12
		@start_am_pm = "AM"
	elsif @start_hour
			@start_am_pm = "PM"
	else
		@start_hour = @start_hour - 12
		@start_am_pm = "PM"
	end

	@end_hour = @activity.end_date.hour
	@end_min = @activity.end_date.strftime("%M")

	if @end_hour < 12
		@end_am_pm = "AM"
	elsif @start_hour
			@start_am_pm = "PM"
	else
		@end_hour = @end_hour - 12
		@end_am_pm = "PM"
	end


	erb :'activities/edit'
end

put '/activities/:id' do

	activity = Activity.get(params[:id])
	session = activity.session
	event = session.day.event

	activity.attributes = params[:activity]

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
	end

	if params[:end_ampm].downcase == "pm"
		if params[:end_hour].to_i < 12
			end_hour = params[:end_hour].to_i + 12
		else
			end_hour = params[:end_hour].to_i
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

	if activity.save
		status(202)
		flash[:success] = "Activity #{activity.name} updated successfully."
		redirect "/#{event.permalink}"
	else
		status(412)
		activity.errors.each do |e|
	    puts e
		end
		flash[:error] = "Please try again."
		redirect back
	end
end

delete '/activities/:id' do

	activity = Activity.get(params[:id])
	event = activity.session.day.event

	if activity.destroy
		activit
		status(202)
		flash[:success] = "Activity #{activity.name} deleted successfully."
		redirect "/#{event.permalink}"
	else
		status(412)
		session.errors.each do |e|
	    puts e
		end
		flash[:error] = "Please try again."
		redirect back
	end

end
