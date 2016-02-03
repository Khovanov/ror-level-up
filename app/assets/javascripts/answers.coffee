# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 
# $ ->
edit_answer = ->
  # $('.edit-answer-link').click (e) ->
  $('.answers').on 'click', '.edit-answer-link', (e) -> 
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('#edit-answer-' + answer_id).show()

vote_answer = ->
  $('.answers').bind 'ajax:success', (e, data, status, xhr) ->
    target = $(e.target).parents('.answer-vote')
    if (target.hasClass('answer-vote'))
      vote = $.parseJSON(xhr.responseText)
      answer_id = $(target).data('answerId')
      # console.log(answer_id)
      $('#answer-vote-count-' + answer_id).html(vote.count)
      $('#answer-vote-rating-' + answer_id).html(vote.rating)
      if (vote.present == true)
        target.addClass("has-vote")
      else
        target.removeClass("has-vote")

$ ->
  edit_answer()
  vote_answer()
