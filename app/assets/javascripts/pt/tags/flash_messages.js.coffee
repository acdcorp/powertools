window.pt ||= tags: []

getAlertClass = (key) ->
  switch key
    when 'notice' then 'alert-info'
    when 'error' then 'alert-error'
    when 'alert' then 'alert-warning'
    when 'success' then 'alert-success'

redirect_messages = false

processLocalMessages = ->
  $ptFlashContainer = $ '[pt-flash-messages]'
  if redirect_messages = $.cookie 'redirect_messages'
    $.removeCookie 'redirect_messages'
    for type, message of $.parseJSON redirect_messages
      $.jGrowl message, { theme: getAlertClass(type) }

processMessages = (event, xhr, settings) ->
  return $.cookie 'redirect_messages', xhr.getResponseHeader('X-Flash-Messages') if xhr.status is 278
  $ptFlashContainer = $ '[pt-flash-messages]'
  messages = $.parseJSON xhr.getResponseHeader('X-Flash-Messages')


  for type, message of messages
    $.jGrowl message, { theme: getAlertClass(type) }
    # $flash = $ '<div>',
    #   class: "alert #{getAlertClass(type)}"
    #   html: $ '<p>',
    #     html: message

    # $link = $ '<a>',
    #   class: 'close'
    #   html: '×'
    #   href: 'javascript:{};'

    # $link.bind 'click', -> $flash.remove()

    # $flash.prepend $link
    # $ptFlashContainer.prepend $flash

    # $flash.delay(2500).slideUp 'fast', ->
    #   $(this).remove()
  # debugger
  # if xhr.status is 278
  #   Turbolinks.visit( xhr.getResponseHeader( 'Location' ) )

addFlashClasses = ->
  $ptFlashContainer = $ '[pt-flash-messages]'
  $ptFlashContainer.addClass 'pt-flash-messages'

pt.tags.push
  oneTime:
    event: 'onload'
    callback: ->
      addFlashClasses()
      processLocalMessages()
      $(document).ajaxComplete processMessages
  ready:
    event: 'bind'
    callback: -> addFlashClasses()

  'page:load':
    event: 'bind'
    callback: ->
      addFlashClasses()
      processLocalMessages()
