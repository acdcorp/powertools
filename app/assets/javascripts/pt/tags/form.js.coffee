window.pt ||= tags: []

pt.tags.push
  formRemove:
    event: 'click'
    callback: ->
      $el     = $ this
      attr    = $el.ptAttr()

      $el.closest('form').remove()
