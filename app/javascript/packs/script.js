$(function(){
  $('.over-secondary').mouseover(function(){
    $(this).addClass('bg-secondary');
  });
  $('.over-secondary').mouseout(function(){
    $(this).removeClass('bg-secondary');
  });
});