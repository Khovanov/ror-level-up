# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

edit_question = ->
  $('.question').on 'click', '.edit-question-link', (e) -> 
    e.preventDefault();
    $(this).hide();
    $('.edit-question-form').show();

vote_question = ->
  $('.question-votes').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    $('.question-votes-count').html(vote.count)
    $('.question-votes-rating').html(vote.rating)
    if (vote.present == true)
      $('.question-vote-up-link, .question-vote-down-link').hide()
      $('.question-vote-cancel-link').show()
    else
      $('.question-vote-up-link, .question-vote-down-link').show()
      $('.question-vote-cancel-link').hide()

# vote_rating = (arr) ->
#   return arr.reduce (sum, vote) -> 
#     return sum + vote.value
#   , 0

  # .bind 'ajax:error', (e, xhr, status, error) ->
  #   errors = $.parseJSON(xhr.responseText)
  #   $.each errors, (index, value) ->
  #     $('.answer-errors').append(value)


$(document).on('page:update', edit_question) 
$(document).on('page:update', vote_question) 
