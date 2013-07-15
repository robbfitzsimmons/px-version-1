# Create a new question Page
get '/:permalink/questions/new' do
	my_permalink?

	@title = "Create New Question"
	@event = Event.first(:permalink => params[:permalink].downcase)
	@question = Question.new()

	erb :'questions/new'
end

# Create an question action
post '/questions' do
	question = Question.new(params[:question])
	event = Event.get(session[:event])

	my_event?(event)

	question.event = event


	if question.save
		status(202)
		flash[:success] = "Question added successfully."
		redirect "/#{event.permalink}"
	else
		status(412)
		question.errors.each do |e|
		    puts e
		end
		flash[:error] = "Please try again."
		# Changes url to /questions rather than questions/new
		#erb :'questions/new'
		redirect "/questions/new"
	end
end

# Edit a question Page
get '/:permalink/questions/:id/edit' do
	my_permalink?

	@question = Question.get(params[:id])
	@event = @question.event

	erb :'questions/edit'
end