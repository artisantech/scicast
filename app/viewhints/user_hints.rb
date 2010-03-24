class UserHints < Hobo::ViewHints

  children :films
  
  field_help :email       => "You'll need to collect email from here to finish your submission, so please use a real account!",
             :institution => "Your school, university, company - leave blank if it doesn't apply",
             :feedback    => "How's SciCast been for you? Enjoyed it? Found it useful? Think there's something we can do better? Please let us know!",
             :password    => "Choose a password for your SciCast account; you'll need it to complete your submission, and to check its progress through the system."
end
