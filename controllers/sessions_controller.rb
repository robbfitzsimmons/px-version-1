get '/login' do
	@title = "Login"
	@user = User.new

	erb :'sessions/login'
end

post '/login' do
	user = User.authenticate(params[:session][:email], params[:session][:password])
	if user.nil? 
		# Create an error message and re-render the signin form.
		flash[:error] = "Log in failed."
		redirect "/login"
	else
		# Sign the user in and redirect to the user's show page.
		flash[:success] = "Logged in Successfully."
		session[:user] = user
		redirect "/user/show"
	end
end

delete '/logout' do
	sign_out
	redirect '/'
end
