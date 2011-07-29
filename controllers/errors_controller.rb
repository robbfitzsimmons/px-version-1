not_found do
    'This is nowhere to be found.'
end

error 403 do
    'Access forbidden'
end

error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
end