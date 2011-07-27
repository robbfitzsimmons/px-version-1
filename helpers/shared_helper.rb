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