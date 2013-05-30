window.pt ||= tags: []

for event in ['mouseover', 'mouseout']
  for extraMethod in [false, 'find']
    eventName = if extraMethod then "#{event}-#{extraMethod}" else event
    newEvent = {}
    newEvent[eventName] =
      event: event
      callback: (e) ->
        e.preventDefault()

        $el        = $ this
        attr       = $el.ptAttr()

        data = attr[eventName.camelize(false)].dasherize().split('-')

        loadedName       = "#{eventName}Loaded"
        oppositeBindName = "#{eventName}OppositeBind"

        switch extraMethod
          when 'find'
            [method, action, filter] = data
            $el.find(filter)[method](action)
          else
            [method, action] = data
            $el[method](action)

    pt.tags.push newEvent
