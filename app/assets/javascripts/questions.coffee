# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

edit_question = ->
  $('.question').on 'click', '.edit-question-link', (e) -> 
    e.preventDefault();
    $(this).hide();
    $('.edit-question-form').show();

vote_question = ->
  $('.question').on 'ajax:success', (e, data, status, xhr) ->
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

subscribe_question = ->
  $('.question').on 'ajax:success', (e, data, status, xhr) ->
    target = $(e.target).parents('.question-subscription')
    if (target.hasClass('question-subscription'))
      subscription = $.parseJSON(xhr.responseText)
      # console.log(subscription.subscribed)
      if (subscription.subscribed == true)
         target.addClass('subscribed')
      else
         target.removeClass('subscribed')

question_pub = ->
  PrivatePub.subscribe '/questions', (data, channel) ->
    # console.log('Question pub:' + data)
    question = $.parseJSON(data['question'])
    str = '<p>' + question.title + ' <a href="/questions/' + question.id + '">Details</p>'
    $('.questions').append(str)

# vote_rating = (arr) ->
#   return arr.reduce (sum, vote) -> 
#     return sum + vote.value
#   , 0

$ ->
  edit_question()
  vote_question()
  subscribe_question()
  question_pub()