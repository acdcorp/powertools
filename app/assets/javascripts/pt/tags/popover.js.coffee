window.pt ||= tags: []

pt.tags.push
  popover:
    event: 'mouseenter'
    callback: ->
      $el = $ this
      $el.data 'ptPopoverFocused', true
      attr = $el.ptAttr()

      setTimeout( ->
        $el = $ $el[0]
        attr = $el.ptAttr()

        log $el.data()

        if not $el.data('ptPopoverLoaded') and $el.data('ptPopoverFocused')
          $el.data 'ptPopoverLoaded', true
          url = attr.popover

          #if not a url assume it's content
          if url.charAt(0)!="/"
            $el.popover
              content: url
              html: true
              trigger: 'manual'
              container: attr.popoverContainer or 'body'
              placement: attr.popoverPlacement or 'right'
            $el.removeData 'ptPopoverLoaded'
            $el.popover 'show' if $el.data 'ptPopoverFocused'
          else
            $.ajax
              url: url
              success: (html) ->
                $el.popover
                  content: html
                  html: true
                  trigger: 'manual'
                  container: attr.popoverContainer or 'body'
                  placement: attr.popoverPlacement or 'right'
                $el.removeData 'ptPopoverLoaded'
                $el.popover 'show' if $el.data 'ptPopoverFocused'
        else if $el.data('ptPopoverFocused')
          if not attr.popoverContainer
            $el.popover 'show'
          else
            $el.closest(attr.popoverContainer).find('.popover').popover 'show'
      , 500)


pt.tags.push
  popover:
    event: 'mouseleave'
    callback: ->
      $el = $ this
      attr = $el.ptAttr()
      $el.removeData 'ptPopoverLoaded'
      $el.removeData 'ptPopoverFocused'
      if not attr.popoverContainer
        $('body').find('.popover').remove()
        # $el.popover 'hide'
      else
        $el.closest(attr.popoverContainer).find('.popover').remove()
