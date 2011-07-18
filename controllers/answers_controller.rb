post '/answers' do

	# Get the event
	@event = Event.get(session[:event])

	

	params[:num_questions].downto(1) { |i| 
		string_answer = "answer#{i}".to_sym
		@answer = Answer.create(params[string_answer])
	}


	redirect "/events/#{@event.permalink}"
end