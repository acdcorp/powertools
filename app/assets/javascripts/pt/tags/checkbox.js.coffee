window.pt ||= tags: []

pt.tags.push
  checkboxAll:
    event: 'click'
    callback: ->
      $el          = $ this
      attr         = $el.ptAttr()
      checkboxName = attr.checkboxAll
      isChecked    = $el.is ':checked'
      checkBoxes   = $("[pt-checkbox-wrap='#{checkboxName}']:visible [pt-checkbox='#{checkboxName}']:checked")

      checkBoxes.prop 'checked', isChecked

  checkboxAction:
    event: 'click'
    callback: (e) ->
      e.preventDefault()
      $el          = $ this
      attr         = $el.ptAttr()
      checkboxName = attr.checkboxAction
      isChecked    = $el.is ':checked'
      checkBoxes   = $("[pt-checkbox-wrap='#{checkboxName}']:visible [pt-checkbox='#{checkboxName}']:checked")
      url          = $el.attr 'href'

      checkBoxes.each (i, checkbox) ->
        id = $(checkbox).attr 'pt-checkbox-id'
        log url.replace(':id', id)
        false
