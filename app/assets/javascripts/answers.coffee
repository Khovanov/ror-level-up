# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 
# $ ->
edit_answer = ->
  # $('.edit-answer-link').click (e) ->
  $('.answers').on 'click', '.edit-answer-link', (e) -> 
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('#edit-answer-' + answer_id).show();

vote_answer = ->
  $('.answer-vote').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    answer_id = $(this).data('answerId');
    $('#answer-vote-count-' + answer_id).html(vote.count)
    $('#answer-vote-rating-' + answer_id).html(vote.rating)
    if (vote.present == true)
      $('#answer-vote-up-link-' + answer_id).hide()
      $('#answer-vote-down-link-' + answer_id).hide()
      $('#answer-vote-cancel-link-' + answer_id).show()
    else
      $('#answer-vote-up-link-' + answer_id).show()
      $('#answer-vote-down-link-' + answer_id).show()
      $('#answer-vote-cancel-link-' + answer_id).hide()

$(document).on('page:update', edit_answer) 
$(document).on('page:update', vote_answer) 