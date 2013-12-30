window.pt ||= tags: []

addImages = ($el, accepted_cards) ->
  $card_images = $ '<div/>'
  for card_type in accepted_cards
    $card_images.append $ '<img>',
      src: window.pt.images.cc[card_type]
      alt: card_type

  $el.parent().append $card_images

validateCC = ->
  $('[pt-validate-cc]').each ->
    $el     = $ this
    attr    = $el.ptAttr()

    unless $el.data 'ptValidateCCLoaded'
      if attr.validateCc and attr.validateCc isnt 'true'
        accepted_cards = attr.validateCc.compact().split(',')
      else
        accepted_cards = [
          'visa',
          'mastercard',
          'amex',
          'discover',
          'diners_club_international',
          'jcb'
        ]

      if not $el.data('ptValidateCCImagesLoaded')
        $.ajax
          url: '/assets/pt/cc_images.js'
          dataType: "script"
          async: false
          complete: ->
            $el.data 'ptValidateCCImagesLoaded', true
            addImages $el, accepted_cards
      else
        addImages $el, accepted_cards

      $el.validateCreditCard ((result) ->
      ), accept: accepted_cards

      $el.data 'ptValidateCCLoaded', true

pt.tags.push
  ready:
    event: 'bind'
    callback: validateCC
  'page:change':
    event: 'bind'
    callback: validateCC
