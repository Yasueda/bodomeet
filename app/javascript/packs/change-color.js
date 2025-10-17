document.addEventListener('turbolinks:load', function(){
  const changeColorEls = document.querySelectorAll('.change-color');
  if (!changeColorEls) return;
  changeColorEls.forEach(function(element) {
    let score = element.getAttribute('data-score');

    let color = "#000000";
    if(score > 0){
      score = 255 * score;
      color = Math.trunc(score).toString(16);
      color = "#00" + color + "00";
    }else{
      score = Math.abs(score);
      score = 255 * score;
      color = Math.trunc(score).toString(16);
      color = "#" + color + "0000";
    }

    element.style.color = color;
  });
});
