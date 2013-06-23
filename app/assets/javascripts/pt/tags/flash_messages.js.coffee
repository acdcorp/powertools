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

addFlashClasses = ->
  $ptFlashContainer = $ '[pt-flash-messages]'
  $ptFlashContainer.addClass 'pt-flash-messages'

pt.tags.push
  oneTime:
    event: 'onload'
    callback: ->
      addFlashClasses()
      $(document).ajaxSuccess processMessages
      $(document).ajaxError processMessages
  ready:
    event: 'bind'
    callback: -> addFlashClasses()
