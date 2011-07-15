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
		invite = Invite.first(:slug => self.slug) 
	end while(invite != nil)
end

def create_permalink
		str = self.name
		# accents = { 
		#   ['á','à','â','ä','ã'] => 'a',
		#   ['Ã','Ä','Â','À','�?'] => 'A',
		#   ['é','è','ê','ë'] => 'e',
		#   ['Ë','É','È','Ê'] => 'E',
		#   ['í','ì','î','ï'] => 'i',
		#   ['�?','Î','Ì','�?'] => 'I',
		#   ['ó','ò','ô','ö','õ'] => 'o',
		#   ['Õ','Ö','Ô','Ò','Ó'] => 'O',
		#   ['ú','ù','û','ü'] => 'u',
		#   ['Ú','Û','Ù','Ü'] => 'U',
		#   ['ç'] => 'c', ['Ç'] => 'C',
		#   ['ñ'] => 'n', ['Ñ'] => 'N'
		#   }
		# accents.each do |ac,rep|
		#   ac.each do |s|
		# 	str = str.gsub(s, rep)
		#   end
		# end
		str = str.gsub(/[^a-zA-Z0-9 ]/,"")
		
		str = str.gsub(/[ ]+/," ")
		

		str = str.gsub(/ /,"-")
		str = str.downcase
		
		self.name = str
	end