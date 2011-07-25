# Create a new session Page
get '/sessions/new' do
	@title = "Create a New Session"

	@event = Event.get(session[:event])
	@session = Session.new()

	erb :'sessions/new'
end

# Create a new session action
post '/sessions' do
	session = Session.new(params[:session])

	day = Day.get(params[:day])

	session.start_date = DateTime.new(day.date.year, day.date.month, day.date.mday, params[:start_hour].to_i, 0)
	session.end_date = DateTime.new(day.date.year, day.date.month, day.date.mday, params[:end_hour].to_i, 0)
	session.day = day


	if session.save
		status(202)
		flash[:success] = "#{session.name} Added Successfully."

		redirect "/events/#{day.event.permalink}"
	else
		status(412)
		session.errors.each do |e|
		    puts e
		end
		flash[:error] = "Please Try Again."
		redirect "/sessions/new"
	end
end

# Create a new session Page
get '/sessions/edit/:id' do
	@session = session.get(params[:id])
	@event = @session.event

	erb :'activities/edit'
end
