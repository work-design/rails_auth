$('#mobile_confirm').click(function(e){
  var remind_link = new URL(this.href);
  $(this).attr('href', remind_link.pathname + '?mobile=' + $('#mobile').val())
});
