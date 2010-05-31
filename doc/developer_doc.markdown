# SciCast Developer Documentation

This document describes the internal structure of the application from the developers point of view. It should be useful both as a learning aid for Hobo + Rails developers, and as a starting point for developers looking to repurpose the application for use in an online competition.

Please see the main readme file (README.markdown) for more information about this app and how it was developed.

# Model layer

![model.png]

As this app centres around users submitting films to the competition, the central models are `User` and `Film`.

## User model

 - Mostly a standard Hobo user model

 - Has fields to capture details about the contributor, such as `how_did_you_hear_about_us` and `feedback`
 
 - Two boolean fields `administrator` and `judge` capture the role of the user. The permission system is used to ensure only admins can change these fields.
 
 - A lifecycle is used to manage signup, activation of the account by email, and submission of the first film.
 
## User + Film lifecycle.

A complication of this model came from the need to handle both the User record, and the first Film as part of a single lifecycle. Because Hobo's lifecycles are single-model only, the User model has some features that allow it to act as a proxy for the first film.

The first film is created automatically when the user signs up:

    after_create :create_film
    ...
    def create_film
      films.create!
    end

Non database attributes are declared for capturing the required film-fields on the user model, for example
 
    attr_accessor :film_title, :team_name, :type => :string
   
The `activate` lifecycle transition forwards the values of these attributes to the first film and saves it.

Finally the User permission methods `update_permitted` and `view_permitted` need to take into account that the first film is being accessed via the User object.


## Film model

The film model captures all the details of a single entry to the competition. Repurposing the app to a new kind of competition would centre mainly around this model. At a minimum, a new app would probably

 - Rename this model to something appropriate to the new competition
 
 - Modify the fields in the model according to the details that need to be captured from the contributor
 
 - Modify administrative fields as appropriate for the editorial needs of the new competition.
 
### File attachments

The Paperclip plugin is used to handle file attachments to the film model. These will be stored in the local filesystem of the web-server, or the app can be configured to use Amazon's S3 service.