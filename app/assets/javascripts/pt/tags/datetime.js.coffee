window.pt ||= tags: []

pt.tags.push
  datetime:
    event: 'click'
    callback: ->
      $el     = $ this
      attr    = $el.ptAttr()

      unless $el.data 'ptDatetimeLoaded'
        $el.datetimepicker
          format: 'mm/dd/yyyy HH:ii P'
          showMeridian: true
          autoclose: true

        $el.data 'ptDatetimeLoaded', true
        $el.datetimepicker 'show'
  date:
    event: 'click'
    callback: ->
      $el     = $ this
      attr    = $el.ptAttr()

      unless $el.data 'ptDateLoaded'
        $el.datetimepicker
          format: 'mm/dd/yyyy'
          showMeridian: true
          autoclose: true
          minView: 2

        $el.data 'ptDateLoaded', true
        $el.datetimepicker 'show'
