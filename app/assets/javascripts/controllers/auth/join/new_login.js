document.getElementById('mobile_confirm').addEventListener('click', function(e){
  var remind_link = new URL(this.href);
  var identity = document.getElementById('identity').value;
  this.href = remind_link.pathname + '?identity=' + identity;
});
