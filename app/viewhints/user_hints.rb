class UserHints < Hobo::ViewHints

  children :films
  
  field_help :email       => "You'll need to collect email from here to finish your submission, so please use a real account! <b>Your email address will not be shared with other organisations</b>, and will be used to contact you only regarding SciCast.",
             :institution => "Your school, university, company - leave blank if it doesn't apply",
             :feedback    => "How's SciCast been for you? Enjoyed it? Found it useful? Think there's something we can do better? Please let us know!",
             :password    => "Choose a password for your SciCast account; you'll need it to complete your submission, and to check its progress through the system.",
             :first_time  => "Is this the first time your institution has entered SciCast?",

             # File fields
             :post_film        => "Can't upload? Click this, and send your film by post. You'll need to send us a little paperwork later anyway.",
             :film_description => "We'll publish your comments here alongside your film, so give us as much detail as you'd like. Where did your ideas come from? How did the filming go? What would you do differently next time?",
             :production_date  => "It's useful for us to know when you made your film, but whatever you enter here won't affect your entry into the competition.",
             :license          => "We need your permission to publish your film, and use <a target='_blank' href='http://creativecommons.org'>Creative Commons</a> licenses for this. We prefer the CC 'BY' license, but if you'd rather restrict commercial use of your film, choose 'BY NC SA' here. Read <a target='_blank' href='http://www.planet-scicast.com/film_school/production_-_licensing.cfm'>our notes on the choice</a>.",
             :team_name        => "We'll use this to credit your team throughout the site.",
             :team_info        => "How many people were in the team? What ages were they? Did you have any help from teachers, technicians, parents, etc?",
             :others_material => "Have you used anyone else's material in your film (music, photos, video clips)? If so, tell us here - give us as much information as you can. Ideally, include a link to the web page for the material."
             
  field_names :others_material => "Material used"
             
end
