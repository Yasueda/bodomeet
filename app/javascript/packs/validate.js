document.addEventListener('turbolinks:load', function(){
  const formControlEls = document.querySelectorAll('.form-control');
  if (!formControlEls) return;
  formControlEls.forEach(function(element) {
    let errors = element.getAttribute('errors');
    if(errors){
      if(errors != "false"){
        $(element).addClass('is-invalid');
      }
    }
  });
});
