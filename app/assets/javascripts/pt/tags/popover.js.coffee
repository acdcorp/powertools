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

        if not $el.data('ptPopoverLoading') and $el.data('ptPopoverFocused')
          $el.data 'ptPopoverLoading', true
          url = attr.popover

          #if not a url assume it's content
          if url.charAt(0)!="/"
            $el.popover
              content: url
              html: true
              trigger: 'manual'
              container: attr.popoverContainer or 'body'
              placement: attr.popoverPlacement or 'right'
            $el.data 'ptPopoverLoaded', true
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
                $el.data 'ptPopoverLoaded', true
                $el.popover 'show' if $el.data 'ptPopoverFocused'
        else if $el.data('ptPopoverFocused')
          $el.popover 'show'
      , 500)


pt.tags.push
  popover:
    event: 'mouseleave'
    callback: ->
      $el = $ this
      attr = $el.ptAttr()
      $el.removeData 'ptPopoverFocused'
      if $el.data 'ptPopoverLoaded'
        $el.popover 'hide'
      # if not attr.popoverContainer
      #   $('body').find('.popover').popover 'hide'
      # else
      #   $el.closest(attr.popoverContainer).popover 'hide'
