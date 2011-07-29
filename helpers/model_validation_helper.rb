class String
  def strip_tags
      self.gsub( %r{</?[^>]+?>}, '' )
  end
end

def remove_html
  self.attributes.each do |attribute, value|
    if value.class == String
      value = value.strip_tags

      self.attribute_set(attribute, value)
    end
  end
end

# Checks that the end date of an event is after the start
def valid_end_date?
  if @end_date >= @start_date
    return true
  else
    return [false, "Start date must be before end date"]
  end
end

# Creates a unique slug for an Invite
def create_slug
	length = 16
	# Loop while slug is not unique
	begin
		self.slug = (0..(length-1)).map{ rand(36).to_s(36) }.join 
		object = self.class.first(:slug => self.slug) 
	end while(object != nil)
end

def create_permalink
	ret = self.name.strip

    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with underscore
     ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'  

     #convert double underscores to single
     ret.gsub! /_+/,"_"

     #strip off leading/trailing underscore
     ret.gsub! /\A[_\.]+|[_\.]+\z/,""

     ret.downcase!

     self.permalink = ret

end

def validates_image_type
    allowed_mime_types = %w{"image/bmp", "image/gif", "image/jpeg", "image/png"} 
    if self.image.size.nil?
      return true
    elsif allowed_mime_types.one? {|allowed_content_type| allowed_content_type.match(self.image.content_type.to_s)}
      return true
    else
      return [false, "The file provided (#{self.image.content_type.to_s}) is not an acceptable format."]
    end
  end

def validates_image_size
    max_size = 1048576
    if self.image.size.nil?
      return true
    elsif self.image.size < max_size
      return true
    else
      return [false, "Image file size is too big."]
    end
end