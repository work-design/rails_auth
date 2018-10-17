document.getElementById('mobile_confirm').addEventListener('click', function(e){
  var remind_link = new URL(this.href);
  this.href = remind_link.pathname + '?mobile=' + document.getElementById('new_mobile').value
});
