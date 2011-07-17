# Is admin of event ?
def is_event_admin(event)
	current_user.user_event_associations.each do |assoc|
		if assoc.event == event
			if assoc.admin
				return true
			end
		end
	end
	return false
end

def current_event
	@current_event ||= event_from_session
end

	private
		def event_from_session 
			Event.get(session[:event])
		end