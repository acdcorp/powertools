#= require pt/log
#= require pt/bootbox
#= require pt/jquery.maskedinput
#= require pt/jquery.form
#= require pt/select2
#= require pt/bootstrap-datetimepicker
#= require twitter/bootstrap
#= require pt/attr
#= require pt/sugarjs
#= require_tree ./tags

window.pt ||= tags: []

pt['init'] = ->
  for tagObj in pt.tags
    for name, tag of tagObj
      name     = name.dasherize() unless name.has ':'

      event    = tag['event'] || false
      callback = tag['callback'] || false

      switch event
        when 'bind'
          $(document).bind name, callback

          # Makes it work with turbolinks
          if name == 'ready'
            $(document).bind 'page:load', callback
        when 'onload'
          $(document).on 'ready', callback
        else
          $(document).on event, "[pt-#{name}]", callback
pt.init()
