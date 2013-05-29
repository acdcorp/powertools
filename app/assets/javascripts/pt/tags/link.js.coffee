window.pt ||= tags: []

pt.tags.push
  link:
    event: 'click'
    callback: (event) ->
      event.preventDefault()

      $el        = $ this
      attr       = $el.ptAttr()
      $container = $("##{attr.link}")
      url        = $el.attr 'href'

      unless $el.data 'ptLinkLoading'
        $el.data 'ptLinkLoading', true

        $.ajax
          url: url
          success: (html) ->
            $container.html html
            $(document).trigger 'page:change'
            $el.data 'ptLinkLoading', false
