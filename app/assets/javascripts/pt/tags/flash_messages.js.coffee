window.pt ||= tags: []

getAlertClass = (key) ->
  switch key
    when 'notice' then 'alert-info'
    when 'error' then 'alert-error'
    when 'alert' then 'alert-warning'
    when 'success' then 'alert-success'

processMessages = (event, xhr, settings) ->
  $ptFlashContainer = $ '[pt-flash-messages]'
  messages = $.parseJSON xhr.getResponseHeader('X-Flash-Messages')

  for type, message of messages
    $flash = $ '<div>',
      class: "alert #{getAlertClass(type)}"
      html: $ '<p>',
        html: message

    $link = $ '<a>',
      class: 'close'
      html: '×'
      href: 'javascript:{};'

    $link.bind 'click', -> $flash.remove()

    $flash.prepend $link
    $ptFlashContainer.prepend $flash

    $flash.delay(2500).slideUp 'fast', ->
      $(this).remove()

pt.tags.push
  ready:
    event: 'bind'
    callback: ->
      $ptFlashContainer = $ '[pt-flash-messages]'
      if $ptFlashContainer.length and not $ptFlashContainer.data 'loadedFlashMessages'
        $ptFlashContainer.addClass 'pt-flash-messages'
        $ptFlashContainer.data 'loadedFlashMessages', true
        $(document).ajaxSuccess processMessages
        $(document).ajaxError processMessages
