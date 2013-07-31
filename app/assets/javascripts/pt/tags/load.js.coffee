window.pt ||= tags: []

ptLoad = ->
  $('[pt-load]').each ->
    $el        = $ this
    attr       = $el.ptAttr()
    url        = attr.load

    unless $el.data 'ptLoadLoaded'
      $el.data 'ptLoadLoaded', true

      $.ajax
        url: url
        success: (html) ->
          $el.html html
          # $el.data 'ptLoadLoaded', false
          $(document).trigger 'page:change'

  ptChange()

ptChange = ->
  $('[pt-change-load]').each ->
      $el               = $ this
      attr              = $el.ptAttr()
      url               = attr.changeLoad

      unless $el.data 'ptChangeLoadLoaded'
        $el.data 'ptChangeLoadLoaded', true
        name_split = $el.attr('name').split '['
        if name_split.length > 1
          name = name_split.last().slice(0,-1)
        else
          name = name_split.first()

        $el.on 'change', ->
          $self = $ this

          if not $self.is(':checkbox')
            value = $self.val()
          else
            value = $self.is(':checked')


          data =
            field: name
            value: value
            pt_ajax: 'change-load'

          $.ajax
            url: url
            type: attr.changeLoadType || 'GET'
            data: data
            success: (newHtml) ->
              if ($newHtml = $(newHtml).find(attr.loadContainer)) and $newHtml.length > 0
                html = $newHtml.html()
              else
                html = newHtml

              if $container = $(attr.loadContainer)
                $container.html(html).show().removeClass 'hidden'
              else
                $self.html(html).show().removeClass 'hidden'

              $(document).trigger 'page:change'

pt.tags.push
  ready:
    event: 'bind'
    callback: ptLoad

  'page:change':
    event: 'bind'
    callback: ptLoad
