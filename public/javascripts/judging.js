document.observe("dom:loaded", function() {
  $$('body.category.show-page .movie-icon.enabled').each(function(el) {
    Event.observe(el, "click", function() {
      var player = $('player').innerHTML.replace(/\[MOVIE-SRC\]/g, this.getAttribute('movie-url'))
      var button = "<button class='hider' onclick='this.parentNode.innerHTML=\"\"'>Hide</button>"
      $(this).up('.card').down('.player-placeholder').innerHTML = player + button
    })
  });
});
