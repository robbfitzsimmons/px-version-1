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

def make_paperclip_mash(file_hash)
  mash = Mash.new
  mash['tempfile'] = file_hash[:tempfile]
  mash['filename'] = file_hash[:filename]
  mash['content_type'] = file_hash[:type]
  mash['size'] = file_hash[:tempfile].size
  mash
end

	private
		def event_from_session 
			Event.get(session[:event])
		end