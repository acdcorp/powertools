window.pt ||= tags: []

mask = ->
  $('[pt-mask]').each ->
    $el     = $ this
    attr    = $el.ptAttr()

    unless $el.data 'ptMaskLoaded'
      $el.mask attr.mask

      $el.data 'ptMaskLoaded', true


pt.tags.push
  ready:
    event: 'bind'
    callback: mask
  'page:change':
    event: 'bind'
    callback: mask
