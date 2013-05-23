$.fn.ptAttr = ->
  $el          = $ this
  attributes   = $el[0].attributes
  ptAttributes = {}

  $.each attributes, (i, attr) ->
    name = attr.nodeName
    val  = attr.nodeValue
    regex = /^pt-.*$/
    if name.match(regex)
      ptAttributes[name.replace('pt-', '').camelize(false)] = val

  ptAttributes
