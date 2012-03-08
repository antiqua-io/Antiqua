$ ->
  $( '#payment-form' ).submit ( event ) ->
    $form          = $ event.target
    $submit_button = $ '.submit-button'

    $submit_button.attr 'disabled' , 'disabled'

    stripe_response_handler = ( status , response ) ->
      if response.error
        $form.find( 'input[ type = "text" ]' ).val ''
        $submit_button.removeAttr 'disabled'
        alert_html = HoganTemplates[ 'antiqua/templates/user/payment_alert' ].render error_message: response.error.message
        $( '.payment-errors' ).html alert_html
      else
        token = response.id
        $form.append "<input type='hidden' name='stripe_token' value='#{ token }' />"
        $form.get( 0 ).submit()

    Stripe.createToken
      number:    $( '.card-number' ).val()
      cvc:       $( '.card-cvc' ).val()
      exp_month: $( '.card-expiry-month' ).val()
      exp_year:  $( '.card-expiry-year' ).val()
    , stripe_response_handler

    false

  $( '#destroy-subscription-form' ).submit ( event ) ->
    if confirm "Are you sure?"
      $( event.target ).get( 0 ).submit()
