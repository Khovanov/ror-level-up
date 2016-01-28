# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

edit_question = ->
  $('.question').on 'click', '.edit-question-link', (e) -> 
    e.preventDefault();
    $(this).hide();
    $('.edit-question-form').show();

vote_question = ->
  $('.question').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    target = $(e.target).parent()
    $('#question-vote-count').html(vote.count)
    $('#question-vote-rating').html(vote.rating)
    if (vote.present == true)
      target.addClass("has-vote")
    else
      target.removeClass("has-vote")

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
