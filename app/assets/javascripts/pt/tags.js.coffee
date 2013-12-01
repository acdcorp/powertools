#= require pt/log
#= require pt/bootbox
#= require pt/jquery.maskedinput
#= require pt/jquery.form
#= require pt/select2
#= require pt/jGrowl/jqgrowl.js
#= require pt/bootstrap-datetimepicker
# require twitter/bootstrap
#= require pt/attr
#= require pt/plugin/sugarjs/v1.4.0
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

  # Add authenticity token to every ajax call so rails doesn't freak out :)
  $.ajaxSetup
    data:
      authenticity_token: $('head').find('meta[name = "csrf-token"]').attr('content')
pt.init()
