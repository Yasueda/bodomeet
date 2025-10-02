// $(function(){
//   var changeColorEl = document.getElementById("change-color");
//   console.log(changeColorEl);
//   if (!changeColorEl) return;
//   let score = changeColorEl.dataset.score;
//   console.log(changeColorEl.dataset);
//   console.log(score);
//   let color = "#000000";
//   if(score > 0){
//     score = 255 / 10 * score;
//     color = Math.trunc(score).toString(16);
//     color = "#00" + color + "00";
//   }else{
//     score = Math.abs(score);
//     score = 255 / 10 * score;
//     color = Math.trunc(score).toString(16);
//     color = "#" + color + "0000";
//   }
//   console.log(score);
//   console.log(color);
//   changeColorEl.style.color = color;
// });

document.addEventListener('turbolinks:load', function(){
  var changeColorEls = document.querySelectorAll('.change-color');
  if (!changeColorEls) return;
  changeColorEls.forEach(function(element) {
    var score = element.getAttribute('data-score');

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

// $(function(){
//   var changeColorEls = document.querySelectorAll('.change-color');
//   if (!changeColorEls) return;
//   changeColorEls.forEach(function(element) {
//     var id = element.getAttribute('data-id');
//     console.log('ID:', id);

//     var changeColorEl = document.getElementById("change-color-" + id);
//     console.log(changeColorEl);
//     if (!changeColorEl) return;
//     let score = changeColorEl.dataset.score;
//     console.log(changeColorEl.dataset);
//     console.log(score);
//     let color = "#000000";
//     if(score > 0){
//       score = 255 / 10 * score;
//       color = Math.trunc(score).toString(16);
//       color = "#00" + color + "00";
//     }else{
//       score = Math.abs(score);
//       score = 255 / 10 * score;
//       color = Math.trunc(score).toString(16);
//       color = "#" + color + "0000";
//     }
//     console.log(score);
//     console.log(color);
//     changeColorEl.style.color = color;
//   });
// });