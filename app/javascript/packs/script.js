$(function(){
  $('.nav-link').on("mouseover",function(){
    $(this).addClass('bg-secondary');
  });
  $('.nav-link').on("mouseout",function(){
    $(this).removeClass('bg-secondary');
  });
});
