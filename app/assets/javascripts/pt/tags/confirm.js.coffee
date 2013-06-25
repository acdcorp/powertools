window.pt ||= tags: []

confirm = ($el, type = 'confirm') ->
    attr = $el.ptAttr()

    switch type
      when 'delete'
        buttonName = attr.confirmButton or 'Delete'
        ajaxType = 'DELETE'
        url  = attr.confirmDelete
      when 'post'
        buttonName = attr.confirmButton or 'Save'
        ajaxType = 'POST'
        url  = attr.confirmPost
      else
        buttonName = attr.confirmButton or 'Yes'
        ajaxType = 'PUT'
        url = attr.confirm

    if attr.confirmContainer
      $confirmContainer = $el.closest(attr.confirmContainer)

    unless $el.data 'ptConfirmLoaded'
      $el.data 'ptConfirmLoaded', true

      $html = $ '<div>',
        style: 'text-align: center;'

      $deleteButton = $ '<button>',
        class: 'btn btn-danger confirm'
        style: 'margin-right: 10px;'
        text: buttonName
      $html.append $deleteButton

      $cancelButton = $ '<button>',
        class: 'btn cancel'
        text: 'Cancel'
      $html.append $cancelButton

      $confirmContainer.on 'click', '.popover-content .confirm', ->
        $.ajax
          url: url
          type: ajaxType
          success: ->
            $confirmContainer.popover 'hide'

      $confirmContainer.on 'click', '.popover-content .cancel', ->
        $confirmContainer.find('.popover').remove()
        # $confirmContainer.popover 'hide'

      $confirmContainer.popover
        content: $html
        html: true
        trigger: 'manual'
        title: attr.confirmTitle or 'Are you sure?'
        placement: attr.confirmPlacement or 'right'
        container: $confirmContainer

    $confirmContainer.popover 'show'


pt.tags.push
  confirmPost:
    event: 'click'
    callback: ->
      confirm $(this), 'post'
  confirmDelete:
    event: 'click'
    callback: ->
      confirm $(this), 'delete'
  confirm:
    event: 'click'
    callback: -> confirm $(this)
#
#       buttons = [
#         {
#           label: 'Yes'
#           class: 'btn-primary'
#           callback: ->
#             $.ajax
#               url: url
#               type: 'DELETE'
#               success: ->
#                 $('#pt-modal-body').closest('.bootbox').modal('hide')
#         }
#         {
#           label: 'Cancel'
#           callback: -> $('#pt-modal-body').closest('.bootbox').modal('hide')
#         }
#       ]
#
#       $bootbox = bootbox.dialog false, buttons, { header: attr.confirmTitle or 'Are you sure?', keyboard: true  }
#       $bootbox.find('.modal-body').remove()
#       $bootbox.find('.modal-footer a:last').removeClass 'btn-primary'
