User.fix(:phil) {{
  :name                  => "Philip Dudley",
  :description           => "Boyfriend of Best Girlfriend",
  :email                 => "pdudley89@gmail.com",
  :password              => "unicorn",

  :linked_in_uid         => "gwe6WwjtFw"

  # The /\w+/.gen notation is part of the randexp gem:
  # http://github.com/benburkert/randexp/
  
  #:events   => 10.of {Event.make}
}}

User.fix {{
  :name                  => %w(Sarah Phil Mal Max Brandon Shirley Christopher Ryan Karen Brian Ollie Stephen Hugo)[rand(13)] + " " + %w(Black White Orange Green Blue Yellow Nistelrooy Toodlepipps)[rand(8)]+ /\w{3}/.gen,
  :description           => (description = /\w+/.gen),
  :email                 => "#{description}@example.com",
  :password              => "unicorn",

  # The /\w+/.gen notation is part of the randexp gem:
  # http://github.com/benburkert/randexp/
  
  #:events   => 10.of {Event.make}
}}

Event.fix {{
  :name                  => /\w{3}/.gen + " " + /\w+/.gen,
  :description           => (description = /\w+/.gen),
  :permalink             => (description),
  :location              => /\w{3}/.gen + " " + /\w+/.gen,
  :color                 => %w(blue dark-gray dark-gray-blue forest-green light-gray lime-popsicle mac-n-cheese pink purple red sunset-orange turquoise)[rand(12)],
  :start_date            => (start = DateTime.new(2011 + rand(2), 1 + rand(12), 1 + rand(25), 9, 0)),
  :end_date              => DateTime.new(start.year, start.month, start.day + rand(3), 9, 0)
}}


UserEventAssociation.fix {{

  :admin                => %w(true false)[rand(2)],
  :attending            => %w(true false)[rand(2)],
  :checked_in            => %w(true false)[rand(2)],



 :user                 => User.pick,
 :event                 => Event.pick

}}



Interest.fix {{
   :name                => /\w+/.gen,
   
   :users              => (0..10).of {User.pick}
}}


Organization.fix {{
   :name                  => /\w{3}/.gen + " " + /\w+/.gen,
   
   :users                => (0..10).of {User.pick}
}}

Question.fix(:select) {{
  :type                  => "select",
  :text                  => /[:sentence:]/.gen[0..49],
  :option1               => /\w+/.gen,
  :option2               => /\w+/.gen,
  :option3               => /\w+/.gen,

  :event                 => Event.pick,
  :answers               => 50.of {Answer.gen(:int)}
}}

Question.fix(:radio) {{
  :type                  => "radio",
  :text                  => /[:sentence:]/.gen[0..49],
  :option1               => /\w+/.gen,
  :option2               => /\w+/.gen,
  :option3               => /\w+/.gen,

  :event                 => Event.pick,
  :answers               => 50.of {Answer.gen(:int)}
}}

Question.fix(:text) {{
  :type                  => "radio",
  :text                  => /[:sentence:]/.gen[0..49],

  :event                 => Event.pick,
  :answers               => 50.of {Answer.gen(:text)}
}}



Answer.fix(:int) {{

  :int_answer           =>  1+rand(3),

  :user                 => User.pick

  #belongs_to :question
  #belongs_to :user
}}

Answer.fix(:text) {{
  :text_answer           => /[:sentence:]/.gen[0..49],

  :user                 => User.pick

 #belongs_to :question
  #belongs_to :user

}}

# if (User.count < 1)
#   100.times {User.gen}
#   100.times {Event.gen}
#   1000.times {UserEventAssociation.gen}

#   400.times {Interest.gen}
#   400.times {Organization.gen}
# end

# 300. times {Question.gen(:radio)}
# 300. times {Question.gen(:text)}
# 300. times {Question.gen(:select)}
