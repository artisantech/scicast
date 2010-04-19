var films
var filterTags = []

$().ready(function() {
  $.getJSON('/admin/films', function(data) {
    films = data
    sortIntoColumns()
  });
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
      $('#filter-tags').html(Jaml.render('tag', filterTags))
      getFilms()
      this[0].selectedIndex = 0
    }
  }
})

$('#filter-tags button').entwine({
  onclick: function() {
    var li = this.closest('li')
    _.remove(filterTags, li.find('span').text())
    if (filterTags.length == 0) {
      $("#filter-tags").html("All")
    } else {
      li.remove()
    }
    getFilms()
  }
})


_.remove = function (array, elem) {
  array.splice(array.indexOf(elem), 1)
  return array
}


// --- Templates ---

Jaml.register('li', function(item) { li(item) })
  
Jaml.register('film', function(film) {
  div({cls:'film', id:"film-" +film.id},
    button({cls:'add-remove'}),
    h3(a({href: '/admin/films/' + film.id}, film.title)),
    div({cls:'ref-code'}, film.reference_code),
    div({cls:'tags'},
      "Tags:",
      ul(Jaml.render('li', film.tag_list))
    )
  )
})

Jaml.register('tag', function(tag) {
  li(
    button('&times;'),
    span(tag)
  )
})

