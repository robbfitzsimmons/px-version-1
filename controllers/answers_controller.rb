get '/:permalink/answers' do
	@event = Event.first(:permalink => params[:permalink])

	if @event.questions.answers.count == 0
		flash[:warning] = "No answers recieved yet, check back soon or answer them yourself."
		redirect back
	end

	@title = "Event Answers"
	@questions = @event.questions

	@answers = Hash.new()
	@choices = Hash.new()
	i = 0
	@questions.each do |question|
		@answers[i] = question.answers
		if @answers[i].first.text_answer.nil?
			@choices[i] = Hash.new()
			@choices[i][0] = question.answers(:int_answer => 1).count
			@choices[i][1] = question.answers(:int_answer => 2).count
			@choices[i][2] = question.answers(:int_answer => 3).count
		end
		puts @answers[i]
		i = i + 1
	end

	puts @answers[0].inspect

	erb :'answers/results'

end

post '/answers' do

	# Get the event
	@event = Event.get(session[:event])

	# 1 = Success all answers added, #2 = Some failed, #3 = all failed
	success = 1


	params[:num_questions].to_i.downto(1) { |i| 
		string_answer = "answer#{i}".to_sym
		@answer = Answer.new()
		if(!params[string_answer]["int_answer"].nil?)
			@answer.int_answer = params[string_answer]["int_answer"].to_i
		elsif(!params[string_answer]["text_answer"].nil?)
			@answer.text_answer = params[string_answer]["text_answer"]
		end

		puts params[string_answer]["int_answer"].to_i

		@answer.question_id = params[string_answer]["question_id"]

		@answer.user = current_user
		#@answer.question_event_id = @event.id

		puts @answer.inspect

		if @answer.save
			if success == 1
				success = 1
			else
				success = 2
			end
		else
			@answer.errors.each do |e|
		    puts e
		  end
			if success == 3 || i == (params[:num_questions].to_i)
				success = 3
			else
				success = 2
			end

		end
	}

	if success == 1
		flash[:success] = "Questions answered successfully."
	elsif success == 2
		flash[:warning] = "Some questions answered unsuccessfully."
	elsif success == 3
		flash[:error] = "Questions answered unsuccessfully. Please try again."
	end

	redirect "/#{@event.permalink}"
end