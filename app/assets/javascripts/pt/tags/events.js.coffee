window.pt ||= tags: []

for event in ['mouseover', 'mouseout', 'change']
  for extraMethod in [false, 'find', 'put']
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
          when 'put'
            $.ajax
              url: data.first()
              type: 'PUT'
              data:
                field: $el.attr 'name'
                value: $el.val()
          else
            [method, action] = data
            $el[method](action)

    pt.tags.push newEvent
