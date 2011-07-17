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