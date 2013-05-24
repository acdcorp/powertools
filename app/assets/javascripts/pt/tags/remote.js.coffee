window.pt ||= tags: []

pt.tags.push
  remote:
    event: 'submit'
    callback: (event) ->
      $el        = $ this
      attr       = $el.ptAttr()

      unless $el.data 'ptRemoteSending'
        $(this).ajaxSubmit
          success: (html) ->
            $el.parent().html html
            $(document).trigger 'page:change'
        return false
