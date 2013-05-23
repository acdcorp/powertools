window.pt ||= tags: []

pt.tags.push
  popover:
    event: 'mouseenter'
    callback: ->
      $el = $ this
      $el.data 'ptPopoverFocused', true
      attr = $el.ptAttr()

      if not $el.data 'ptPopoverLoaded'
        $el.data 'ptPopoverLoaded', true
        url = attr.popover

        $.ajax
          url: url
          success: (html) ->
            $el.popover
              content: html
              html: true
              trigger: 'manual'
              container: attr.popoverContainer or 'body'
              placement: attr.popoverPlacement or 'right'
            $el.data 'ptPopoverLoaded', false
            $el.popover 'show' if $el.data 'ptPopoverFocused'

pt.tags.push
  popover:
    event: 'mouseleave'
    callback: ->
      $el = $ this
      $el.data 'ptPopoverFocused', false
      $el.popover 'hide'
