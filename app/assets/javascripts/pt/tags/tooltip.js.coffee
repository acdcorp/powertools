window.pt ||= tags: []

pt.tags.push
  tooltip:
    event: 'mouseenter'
    callback: ->
      $el     = $ this
      attr    = $el.ptAttr()

      if not $el.data 'ptTooltipLoaded'
        $el.tooltip
          html: true
          title: attr.tooltip
          placement: attr.tooltipPlacement or 'right'
          container: 'body'
          trigger: 'manual'

        $el.tooltip 'show'

        $el.data 'ptTooltipLoaded', true
      else
        $el.tooltip 'show'

pt.tags.push
  tooltip:
    event: 'mouseleave'
    callback: -> $(this).tooltip 'hide'
