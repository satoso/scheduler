function ready() {
  $('#all-ok')       .on('click', function(){ $('form [type="radio"]').val(["ok"]);        });
  $('#all-pending')  .on('click', function(){ $('form [type="radio"]').val(["pending"]);   });
  $('#all-ng')       .on('click', function(){ $('form [type="radio"]').val(["ng"]);        });
  $('#all-no_answer').on('click', function(){ $('form [type="radio"]').val(["no_answer"]); });
  $('.rbtn-container').on('click', function(){
    $(this).children('[type="radio"]').prop('checked',true);
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);
