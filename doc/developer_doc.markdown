# SciCast Developer Documentation

This document describes the internal structure of the application from the developers point of view. It should be useful both as a learning aid for Hobo + Rails developers, and as a starting point for developers looking to repurpose the application for use in an online competition.

Please see the main readme file (README.markdown) for more information about this app and how it was developed.

# Model Layer

![Model Diagram](model.png)

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

 - Rename this model to something appropriate to the new competition. 
 
 - Modify the fields in the model according to the details that need to be captured from the contributor, such as:

        title       :string
        description :text
        team_name   :string
        team_info   :text
        license     License
        ...
  
 - Modify administrative fields as appropriate for the editorial needs of the new competition, such as:
        
        editorial_notes :text

        music_status     Status
        video_status     Status
        stills_status    Status
        safety_status    Status
        paperwork_status Status

    (note that the `Status` fields are used to manage the progress of films on the Film Status page in the admin site)
 
 
### File attachments

The Paperclip plugin is used to handle file attachments to the film model. These will be stored in the local filesystem of the web-server, or the app can be configured to use Amazon's S3 service.

It is likely that repurposing the app for a new competition would involve changing the files associated with this model. i.e this code from film.rb:

    with_options(paperclip_options) do |o|
      o.has_attached_file :movie
      o.has_attached_file :processed_movie
      o.has_attached_file :thumbnail, :styles => { :small => "38x35#", :large => "100x100#" }
    end

# Controller Layer

There are three groups of controllers - for the contributor, admin and judging sites.

## Contributor site controllers

This is the 'front site' in Hobo parlance.

The contributor site controllers are typical for a Hobo app. Most of the work is handled by Hobo, with a few customisations, mainly to redirect to the appropriate page after form submissions.

In `FilmsController` a Hobo web-method is used to receive the uploaded film file from the swf-upload widget.

    # This action recieves the POST from the swf-upload file uploader.
    web_method :upload do
      @this.movie = params[:Filedata]
      @this.save(false)
      render :nothing => true
    end
    

## Admin site controllers.

There are only 4 - for users, films, comments and categories. The users and films controllers have the typical extensions seen to support Hobo's `<table-plus>` tag. I.e. they user `apply_scopes` to enable searching and sorting of the table.

The films controller uses Hobo's web-methods to provide `tag` and `untag` actions to support the organiser.

    web_method :tag do
      this.tag_list.add params[:name]
      this.save
      render :nothing => true
    end

    web_method :untag do
      this.tag_list.remove params[:name]
      this.save
      render :nothing => true
    end
    

## Judging site controllers

The judging site is very simple - the controllers only deal with categories and category-comments. There is also a user controller which only exists to provide a separate login page for the judges. In fact the normal login page (in the front site) works perfectly well for judges, but it was required that the judges see their own login page in the judging site style, in order to avoid any confusion.

# View Layer

The app uses DRYML throughout for rendering HTML pages, except in the tag organiser in the admin site, which is essentially a little javascript app that manages it's own user interface entirely in script, and communicates with the server via JSON ajax calls.

## Global application library

The global tag library pulls in the `paperclip` taglib so that both the contributor site and the admin site have access to the file-upload form control. The following two tags are also defined here, as they are used by both the admin and judging site: `<movie-thumbnail>` and `<video-player>`.

## Sub-site tag libraries

The taglibs `front_site.dryml`, `admin_site.dryml` and `judging_site.dryml` define shared tags for the contributor, administration and judging sites respectively.

Each of these taglibs redefines the `<page>` tag so that the correct CSS and javascript assets are pulled in for each of the three sites. For example, in `admin_site.dryml`:
  
  - The contributor theme (in `application.css`) and global search are removed
  - `admin.css` and `admin.js` are loaded.
  - A "View Site" link is added to the page footer

As follows:
  
    <extend tag="page">
      <old-page merge without-app-stylesheet without-live-search>
        <append-stylesheets:>
          <stylesheet name="admin"/>
        </append-stylesheets:>
        <append-scripts:>
          <javascript name="admin"/>
        </append-scripts:>
        <footer:>
          <a href="#{base_url}/">View Site</a>
        </footer:>
      </old-page>
    </extend>
    
## SWFUpload Templates

The SWFUpload plugin provides ERB partials to render its user interface. Rather than re-invent the wheel by porting these to DRYML, we have stuck with ERB. The customisations to the SWFUpload user-interface can be found in `app/views/shared`

## Dynamic movie players

The site makes wide use of movie players that appear on demand in response to JavaScript events. This is achieved by rendering the player HTML into a `<script type="text/html">` tag, as can be seen in `<video-player>` tag definition:
  
    <def tag="video-player" attrs="id, width, height, src">
      <% id ||= "player"; src ||= "[MOVIE-SRC]"; height ||= "384"; width ||= "480" -%>
      <script merge-attrs id="#{id}" type="text/html">
        <object ...>
          ...
        </object>
      </script>
    </def>
    
This means the HTML is not rendered, but is available to JavaScript code. The HTML source code to play a particular movie is generated by javascript such as the following (e.g. see `judging.js`)

    var player = $('player').innerHTML.replace(/\[MOVIE-SRC\]/g, "URL-to-the-movie");
    
`$('player').innerHTML` retrieves the HTML from the `<script>` block. A global find-and-replace is used to insert the actual movie URL in place of a token `[MOVIE-SRC]` that has been placed by the `<video-player>` tag.

This HTML can then be simply inserted into the document, e.g.

    myElement.innerHTML = player
    
## Tag Organiser

The tag organiser's UI uses a basic page template in DRYML, but the rest of the HTML is created dynamically in JavaScript. We have used the JavaScript template library [JAML][1].

[1]: http://github.com/edspencer/jaml

The templates are quite readable once you get used to them. For example, here is a link to the detail page of the film, and the film's title as the text of the link.
  
    a({href: homeUrl + '/' + film.id}, film.title)
  
And here is the same link inside an `<h3>` tag:
  
    h3(a({href: homeUrl + '/' + film.id}, film.title)),
  
The Tag Organiser also uses [JQuery][1], [Underscore][2] for general JavaScript utilities, and [JQuery Entwine][3] for event handling.

[1]: http://jquery.com
[2]: http://documentcloud.github.com/underscore/
[3]: http://github.com/hafriedlander/jquery.entwine

# Email Configuration

The file `config/initializers/app_emails.rb` should be edited to customise email addresses and web-links that appear in emails.
