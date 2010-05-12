Event.addBehavior({
    
    'body.category.show-page .movie-icon.enabled:click' : function() {
      player = $('player').innerHTML.replace(/\[MOVIE-SRC\]/g, this.getAttribute('movie-url'))
      $(this).up('.card').down('.player-placeholder').innerHTML = player + "<button class='hider' onclick='this.parentNode.innerHTML=\"\"'>Hide</button>"
    }
    
})
