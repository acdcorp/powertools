window.pt ||= tags: []

pt.tags.push
  ready:
    event: 'bind'
    callback: ->
      $('[pt-load]').each ->
        $el        = $ this
        attr       = $el.ptAttr()
        url        = attr.load

        unless $el.data 'ptLoadLoaded'
          $el.data 'ptLoadLoaded', true

          $.ajax
            url: url
            success: (html) ->
              $el.html html
              $el.data 'ptLoadLoaded', false
