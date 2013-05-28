window.pt ||= tags: []

select2 = ->
  $('[pt-select2]').each ->
    $el        = $ this
    attr       = $el.ptAttr()
    url        = attr.load

    unless $el.data 'ptSelect2Loaded'
      $el.data 'ptSelect2Loaded', true

      $el.select2
        width: $el.css('width')

pt.tags.push
  ready:
    event: 'bind'
    callback: select2

  'page:change':
    event: 'bind'
    callback: select2
