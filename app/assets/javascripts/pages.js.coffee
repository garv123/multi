window.validate_and_post = ->
  $("#flashmsg").removeClass("error notice success").empty()
  member = $("select#select_member").val()
  if member == "" 
    $("#flashmsg").addClass("flash error").text("Please select a member. ").show()
    return false
  amount = $("input#amount").val()
  if amount == "" 
    $("#flashmsg").addClass("flash error").text("Please enter an amount. ").show()
    return false
  description = $("textarea#description").val()
  if description == "" 
    $("#flashmsg").addClass("flash error").text("Please enter a description. ").show()
    return false

  dataString = 'description='+description+'&amount='+amount
  $.ajax 
    type: "POST"
    url: $("#chargeform").attr("action")
    data: dataString
    success: ->
      $("select#select_member").val("")
      $("input#amount").val("")
      $("textarea#description").val("")
      $("#flashmsg").removeClass("error notice").empty()
      $("#flashmsg").addClass("flash success").text("Charges successful.").show()

jQuery ->
  $.ajaxSetup ->
    cache: false

