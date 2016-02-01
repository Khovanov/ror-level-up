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
    # target = $(e.target).parent()
    target = $(e.target).parents('.question-vote')
    if (target.hasClass('question-vote'))
      vote = $.parseJSON(xhr.responseText)
      $('#question-vote-count').html(vote.count)
      $('#question-vote-rating').html(vote.rating)
      if (vote.present == true)
        target.addClass("has-vote")
      else
        target.removeClass("has-vote")

comment_question = ->
  $('.question').bind 'ajax:success', (e, data, status, xhr) ->
    target = $(e.target).parents('.question-comments')
    if (target.hasClass('question-comments'))    
      obj = $.parseJSON(xhr.responseText)
      $('.question-comments-errors').empty()
      $('.question-comments-list ul').append('<li>' + obj.comment.body + '</li>')

  .bind 'ajax:error', (e, xhr, status, error) ->
    target = $(e.target).parents('.question-comments')
    if (target.hasClass('question-comments')) 
      errors = $.parseJSON(xhr.responseText)
      $('.question-comments-errors').empty()
      $.each errors, (index, value) ->
        $('.question-comments-errors').append(value)     

# vote_rating = (arr) ->
#   return arr.reduce (sum, vote) -> 
#     return sum + vote.value
#   , 0

# $(document).on('page:update', edit_question) 
# $(document).on('page:update', vote_question) 
# $(document).on('page:update', comment_question) 
$ ->
  edit_question()
  vote_question()
  comment_question()
