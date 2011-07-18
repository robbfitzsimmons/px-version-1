# Create a new question Page
get '/questions/new' do
	@event = Event.get(session[:event])
	@question = Question.new()

	erb :'questions/new'
end

# Create an question action
post '/questions' do
	question = Question.new(params[:question])
	event = Event.get(session[:event])

	question.event = event


	if question.save
		status(202)
		flash[:success] = "Question Added Successfully."
		redirect "/events/#{event.permalink}"
	else
		status(412)
		question.errors.each do |e|
		    puts e
		end
		flash[:error] = "Please Try Again."
		# Changes url to /questions rather than questions/new
		#erb :'questions/new'
		redirect "/questions/new"
	end
end

# Edit a question Page
get '/questions/edit/:id' do
	@question = Question.get(params[:id])
	@event = @question.event

	erb :'questions/edit'
end