var films
var filterTags = _(location.hash.substr(1).replace(/\+/g, ' ').split(',')).filter(function(t) { return t.length > 0 })

$().ready(function() {
  getFilms()
  renderFilterTags()
})

function activeTag() {
  return $('#tag-menu').val()
}

function getFilms() {
  url = filterTags.length == 0 ? '/admin/films' : '/admin/films?tags=' + filterTags.join(',')
  $.getJSON(url, function(data) {
    films = data
    sortIntoColumns()
  });
}

function sortIntoColumns() {
  $('#available').empty()
  $('#selected').empty()
  
  tag = activeTag()
  _(films).each(function(film) {
    if (film.tag_list.indexOf(tag) == -1) {
      $('#available').append(renderFilm(film))
    } else {
      $('#selected').append(renderFilm(film))
    }
  })
}

function renderFilm(film) {
  var html = Jaml.render('film', film)
  return $(html).data('film', film)
}

$('.film').entwine({
  "& .add-remove": {
    onmatch: function() {
      this.html("&raquo;")
    },

    onclick: function() {
      this.owner().addTag(activeTag())
      $('#selected').append(this.owner().render())
      this.owner().remove()
    }
  },
  
  '& .movie-icon.enabled': {
    onclick: function() {
      this.owner().find('.player-placeholder').html(this.owner().playerHtml())
      this.addClass('open')
    }
  },

  '& .movie-icon.enabled.open': {
    onclick: function() {
      this.owner().find('.player-placeholder').empty()
      this.removeClass('open')
    }
  },

  playerHtml: function() {
    return $('#player').text().replace(/\[MOVIE-SRC\]/g, this.film().web_movie_url)
  },
  
  film: function() {
    return this.data('film')
  },
  
  addTag: function(tag) {
    if (!this.hasTag(tag)) {
      this.film().tag_list.push(tag)
      $.post('/admin/films/' + this.film().id + '/tag', {name:tag}) 
    }
  },
  
  removeTag: function(tag) {
    if (this.hasTag(tag)) {
      _.remove(this.film().tag_list, tag)
      $.post('/admin/films/' + this.film().id + '/untag', {name:tag}) 
    }
  },
  
  hasTag: function(tag) {
    return this.film().tag_list.indexOf(tag) != -1
  },
  
  render: function() {
    return renderFilm(this.film())
  }

});

$('#selected .film').entwine({
  '& .add-remove': {
    onmatch: function() {
      this.html("&laquo;")
    },

    onclick: function() {
      this.owner().removeTag(activeTag())
      $('#available').append(this.owner().render())
      this.owner().remove()
    }
  },
  
})

$('#tag-menu').entwine({
  onchange: function() {
    if (this.val() == 'New tag...') {
      tag = prompt("New tag")
      if (tag) {
        this.append($("<option></option>").text(tag));
        $('#show-menu').append($("<option></option>").text(tag));
        this.val(tag)
      } else {
        this[0].selectedIndex = 0
      }
    }
    sortIntoColumns()
  }
})

$('#show-menu').entwine({
  onchange: function() {
    if (this[0].selectedIndex != 0) {
      filterTags.push(this.val())
      setLocationHash()
      renderFilterTags()
      getFilms()
      this[0].selectedIndex = 0
    }
  }
})

$('#filter-tags button').entwine({
  onclick: function() {
    var li = this.closest('li')
    _.remove(filterTags, li.find('span').text())
    setLocationHash()
    renderFilterTags()
    getFilms()
  }
})

_.remove = function (array, elem) {
  array.splice(array.indexOf(elem), 1)
  return array
}

function setLocationHash() {
  location.hash = filterTags.join(',').replace(/ /g, '+')
}

function renderFilterTags() {
  $("#filter-tags").html(
    filterTags.length == 0 ? "All" : Jaml.render('tag', filterTags)
  )
}

// --- Templates ---

Jaml.register('li', function(item) { li(item) })
  
Jaml.register('film', function(film) {
  hasMovie = film.web_movie_url;
  hasThumb = film.thumbnail_url;
  
  div({cls:'film', id:"film-" +film.id},
    img({cls: (hasMovie ? 'movie-icon enabled' : 'movie-icon disabled'),
         src: (hasThumb ? film.thumbnail_url : '/images/movie-small.png')
       }),
    button({cls:'add-remove'}),
    h3(a({href: '/admin/films/' + film.id}, film.title)),
    div({cls:'ref-code'}, film.reference_code),
    div({cls:'tags'},
      "Tags:",
      ul(Jaml.render('li', film.tag_list))
    ),
    div({cls:'player-placeholder'})
  )
})

Jaml.register('tag', function(tag) {
  li(
    button('&times;'),
    span(tag)
  )
})

