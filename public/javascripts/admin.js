Event.addBehavior({
    
    'select.film__status:change' : function() {
      var el = $(this)
      el.removeClassName('pass')
      el.removeClassName('fail')
      el.removeClassName('in-progress')
      el.removeClassName('not-started')
      el.addClassName(this.value.gsub('_', '-'))
    }
    
})