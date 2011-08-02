def partial(template,locals=nil)
  if template.is_a?(String) || template.is_a?(Symbol)
    template=('_' + template.to_s).to_sym
  else
    locals=template
    template=template.is_a?(Array) ? ('_' + template.first.class.to_s.downcase).to_sym : ('_' + template.class.to_s.downcase).to_sym
  end
  if locals.is_a?(Hash)
    erb(template,{:layout => false},locals)      
  elsif locals
    locals=[locals] unless locals.respond_to?(:inject)
    locals.inject([]) do |output,element|
      output << erb(template,{:layout=>false},{template.to_s.delete("_").to_sym => element})
    end.join("\n")
  else 
    erb(template,{:layout => false})
  end
end

def logged_in?
  if current_user.nil?
    status 403
    flash[:error] = "Please login first."
    redirect "/"
  end
end


def my_account?

  logged_in?

  if current_user.id != params[:id].to_i
    status 403
    flash[:error] = "You do not have permission to look at this page."
    redirect "/users/#{current_user.id}"
  end


end

def invited_to_event?

  event = Event.first(:permalink => params[:permalink])

  if (session[:invite_event] != event.id)
    logged_in?

    if current_user.invites.events(:permalink => params[:permalink]).empty? && current_user.events(:permalink => params[:permalink]).empty?
      status 403
      flash[:error] = "You do not have permission to look at this page."
      redirect "/users/#{current_user.id}"
    end
  end

end

def my_permalink?

  logged_in?

  if current_user.user_event_associations(:admin => true).events(:permalink => params[:permalink]).empty?
    status 403
    flash[:error] = "You do not have permission to look at this page."
    redirect "/users/#{current_user.id}"
  end

end

def my_event?(event)

  logged_in?

  if current_user.user_event_associations(:admin => true).events(:permalink => event.permalink).empty?
    status 403
    flash[:error] = "You do not have permission to look at this page."
    redirect "/users/#{current_user.id}"
  end

end