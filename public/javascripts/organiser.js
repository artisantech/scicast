var films
$().ready(function() {
  $.getJSON('/admin/films', function(data) {
    films = data
    populateFilms()
  });
})

function activeTag() {
  return $('#tag-menu').val()
}

function populateFilms() {
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

Jaml.register('li', function(item) { li(item) })
  
Jaml.register('film', function(film) {
  div({cls:'film', id:"film-" +film.id},
    button({cls:'add-remove'}),
    h3(film.title),
    div({cls:'tags'},
      "Tags:",
      ul(Jaml.render('li', film.tag_list))
    )
  )
})

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


_.remove = function (array, elem) {
  array.splice(array.indexOf(elem), 1)
  return array
}