# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

comment_question = ->
  $('.question').bind 'ajax:success', (e, data, status, xhr) ->
    target = $(e.target).parents('.question-comments')
    if (target.hasClass('question-comments'))    
      $('.question-comments-errors').empty()
      comment = $.parseJSON(xhr.responseText)
      comment_question_append(comment)

  .bind 'ajax:error', (e, xhr, status, error) ->
    target = $(e.target).parents('.question-comments')
    if (target.hasClass('question-comments')) 
      errors = $.parseJSON(xhr.responseText)
      $('.question-comments-errors').empty()
      $.each errors, (index, value) ->
        $('.question-comments-errors').append(value)     

comment_answer = ->
  $('.answers').bind 'ajax:success', (e, data, status, xhr) ->
    target = $(e.target).parents('.answer-comments')
    if (target.hasClass('answer-comments'))    
      answer_id = $(target).data('answerId')
      $('#answer-comments-errors-' + answer_id).empty()
      comment = $.parseJSON(xhr.responseText)
      comment_answer_append(comment)

  .bind 'ajax:error', (e, xhr, status, error) ->
    target = $(e.target).parents('.answer-comments')
    if (target.hasClass('answer-comments')) 
      errors = $.parseJSON(xhr.responseText)
      answer_id = $(target).data('answerId')
      $('#answer-comments-errors-' + answer_id).empty()
      $.each errors, (index, value) ->
        $('#answer-comments-errors-' + answer_id).append(value)  

comment_pub = ->
  questionId = $('.question').data('questionId');
  channel = '/questions/' + questionId + '/comments'
  PrivatePub.subscribe channel, (data, channel) ->
    # console.log(data)
    comment = $.parseJSON(data['comment'])
    comment_question_append(comment) if comment.commentable_type == 'Question'
    comment_answer_append(comment) if comment.commentable_type == 'Answer'

comment_question_append = (comment) ->
  if document.getElementById('comment-' + comment.id) == null   
    str = '<li class="comment" id="comment-' + comment.id + '">' + comment.body + '</li>'
    $('.question-comments-list ul').append(str)

comment_answer_append = (comment) ->
  if document.getElementById('comment-' + comment.id) == null   
    str = '<li class="comment" id="comment-' + comment.id + '">' + comment.body + '</li>'
    $('#answer-comments-list-' + comment.commentable_id + ' ul').append(str)

$ ->
  comment_question()
  comment_answer()
  comment_pub()
