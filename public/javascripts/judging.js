document.observe("dom:loaded", function() {
  $$('body.category.show-page .movie-icon.enabled').each(function(el) {});
});

Event.addBehavior({
    
    'body.category.show-page .movie-icon.enabled:click' : function() {
      var player = $('player').innerHTML.replace(/\[MOVIE-SRC\]/g, this.getAttribute('movie-url'))
      $(this).up('.card').down('.player-placeholder').innerHTML = player + "<button class='hider' onclick='this.parentNode.innerHTML=\"\"'>Hide</button>"
    }
    
})
