window.pt ||= tags: []

select2 = ->
  $('[pt-select2]').each ->
    $el        = $ this
    attr       = $el.ptAttr()
    url        = attr.load

    unless $el.data 'ptSelect2Loaded'
      $el.data 'ptSelect2Loaded', true
      options = {}
        # width: $el.css('width')

      if Object.has attr, 'select2Add'
        options['multiple']           = false
        options['data']               = if attr.select2Data then jQuery.parseJSON(attr.select2Data) else []
        options['createSearchChoice'] = (term, data) ->
          if $(data).filter(->
            @text.localeCompare(term) is 0
          ).length is 0
            id: term
            text: "#{term} #{attr.select2Add || '(Not yet created)'}"

      $el.select2 options
      $el.select2 'val', attr.select2Selected if attr.select2Selected

pt.tags.push
  ready:
    event: 'bind'
    callback: select2

  'page:change':
    event: 'bind'
    callback: select2
