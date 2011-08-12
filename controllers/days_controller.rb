# Create a new session Page
get '/:permalink/days/:id/edit' do

	my_permalink?

	@edit = true

	@title = "Edit Day"

	@day = Day.get(params[:id])
	@event = @day.event

	erb :'days/edit'
end

put '/days/:id' do

	day = Day.get(params[:id])
	event = day.event

	my_event?(event)

	day.attributes = params[:day]

	if day.save
		status(202)
		flash[:success] = "Day <em>#{day.name}</em> updated successfully."
		redirect "/#{event.permalink}"
	else
		status(412)
		day.errors.each do |e|
	    puts e
		end
		flash[:error] = "Please try again."
		redirect back
	end
end
