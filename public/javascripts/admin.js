Event.addBehavior({
    
    'select.film__status:change' : function() {
      var el = $(this)
      el.removeClassName('pass')
      el.removeClassName('fail')
      el.removeClassName('in-progress')
      el.removeClassName('not-started')
      el.addClassName(this.value.gsub('_', '-'))
    },
    
    'body.film.edit-page select.tag-menu:change' : function() {
      if (this.selectedIndex != 0) {
        var tag = this.value == "New tag..." ? prompt("New Tag") : this.value
        
        if (tag) {
          if ($$('#tags li').length == 0) {
            // Clear "None" text
            $('tags').innerHTML = ""
          }
          
          $('tags').insert({bottom: "<li><button>&times;</button><span>" + tag + "</span></li>"});
          new Ajax.Request(location.href.replace('/edit', '/tag'), { parameters: { name: tag } })
        }
      }
      this.selectedIndex = 0
    },
    
    'body.film.edit-page ul.tags li button:click' : function() {
      var tag = $(this).up('li').down('span').innerHTML
      $(this).up('li').remove();
      new Ajax.Request(location.href.replace('/edit', '/untag'), { parameters: { name: tag } })
    },
    
    'body.film.show-page .movie-icon.enabled:click' : function() {
      if ($('player-placeholder').innerHTML == "") {
        $('player-placeholder').innerHTML = $('player').innerHTML
      } else {
        $('player-placeholder').innerHTML = ""
      }
    },

    'body.film.index-page .movie-icon.enabled:click' : function() {
      var player = $('player').innerHTML.replace(/\[MOVIE-SRC\]/g, this.getAttribute('movie-url'))
      $('player-placeholder').innerHTML = player + "<button class='hider' onclick='this.parentNode.innerHTML=\"\"'>Hide</button>"
    }
    
})
