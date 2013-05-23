window.pt ||= tags: []

pt.tags.push
  mask:
    event: 'click'
    callback: ->
      $el     = $ this
      attr    = $el.ptAttr()

      unless $el.data 'ptMaskLoaded'
        $el.mask attr.mask

        $el.data 'ptMaskLoaded', true
