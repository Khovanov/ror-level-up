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

$(document).on('page:update', edit_answer) 
