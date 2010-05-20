function playMovie(el) {
  var player = $('player').innerHTML.replace(/\[MOVIE-SRC\]/g, el.getAttribute('movie-url'));
  var button = "<button class='hider' onclick='this.parentNode.innerHTML=\"\"'>Hide</button>";
  var download = " <a href='" + el.getAttribute('movie-url') + "'>Download</a> (right click link to download)"
  $(el).up('.card').down('.player-placeholder').innerHTML = '<div class="film-actions">' + player + button + download + "</div>"
}