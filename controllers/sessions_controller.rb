# Create a new session Page
get '/sessions/new' do
	@title = "Create New Session"

	@event = Event.get(session[:event])
	@session = Session.new()

	erb :'sessions/new'
end

# Create a new session action
post '/sessions' do
	session = Session.new(params[:session])

	day = Day.get(params[:day])


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

	session.start_date = DateTime.new(day.date.year, day.date.month, day.date.mday, start_hour, params[:start_minute].to_i)
	session.end_date = DateTime.new(day.date.year, day.date.month, day.date.mday, end_hour, params[:end_minute].to_i)

	session.day = day


	if session.save
		status(202)
		flash[:success] = "<em>#{session.name}</em> added successfully."

		redirect "/#{day.event.permalink}"
	else
		status(412)
		session.errors.each do |e|
		    puts e
		end
		flash[:error] = "Please try again."
		redirect "/sessions/new"
	end
end

# Create a new session Page
get '/:permalink/sessions/:id/edit' do

	@edit = true

	@title = "Edit Session"

	@session = Session.get(params[:id])
	@event = @session.day.event

	erb :'sessions/edit'
end

put '/sessions/:id' do

	session = Session.get(params[:id])
	event = session.day.event

	session.attributes = params[:session]

	if session.save
		status(202)
		flash[:success] = "Session #{session.name} updated successfully."
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

delete '/sessions/:id' do

	session = Session.get(params[:id])
	event = session.day.event

	if session.destroy
		status(202)
		flash[:success] = "Session #{session.name} deleted successfully."
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
