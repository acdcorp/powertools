window.pt ||= tags: []

pt.tags.push
  formRemove:
    event: 'click'
    callback: ->
      $el     = $ this
      attr    = $el.ptAttr()
      if attr.formRemove
      	$(attr.formRemove).remove()
      else
      	$el.closest('form').remove()
