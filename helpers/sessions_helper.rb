def sign_in(user) 
	current_user = user
end

def current_user
	@current_user ||= user_from_session
end

def sign_out 
	current_user = nil
	session[:user] = nil
end 

	private
		def user_from_session 
			User.get(session[:user])
		end
