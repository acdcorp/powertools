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
          container: attr.tooltipContainer or 'body'
          trigger: 'manual'

        $el.tooltip 'show'

        $el.data 'ptTooltipLoaded', true
      else
        $el.tooltip 'show'

pt.tags.push
  tooltip:
    event: 'mouseleave'
    callback: ->
      $el = $ this
      attr = $el.ptAttr()
      if not attr.tooltipContainer
        $el.tooltip 'hide'
      else
        $el.closest(attr.tooltipContainer).find('.tooltip').remove()
