not_found do
	erb :'errors/404', {:layout => :static_layout}
end

error 403 do
    'Access forbidden'
end

error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
end