window.pt ||= tags: []

pt.tags.push
  modal:
    event: 'click'
    callback: ->
      $el     = $ this
      attr    = $el.ptAttr()
      buttons = []
      title   = attr.modalTitle

      if Object.has attr, 'modalSave'
        buttons.push
          label: attr.modalSave or 'Save'
          id: 'ptModalSave'
          callback: -> $('#pt-modal-body').find('form').submit()

      unless $el.data 'ptModalLoaded'
        $el.data 'ptModalLoaded', true
        url = attr.modal

        $.ajax
          url: url
          success: (html) ->
            $html = $ html
            $bootbox = bootbox.dialog html, buttons, { header: title, keyboard: true  }
            $bootbox.find('.modal-body').attr id: 'pt-modal-body'
            $el.data 'ptModalLoaded', false
