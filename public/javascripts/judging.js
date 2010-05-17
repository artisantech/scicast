function playMovie(el) {
  var player = $('player').innerHTML.replace(/\[MOVIE-SRC\]/g, el.getAttribute('movie-url'));
  var button = "<button class='hider' onclick='this.parentNode.innerHTML=\"\"'>Hide</button>";
  $(el).up('.card').down('.player-placeholder').innerHTML = player + button;
}