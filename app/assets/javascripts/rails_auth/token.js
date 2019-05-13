document.getElementById('mobile_confirm').addEventListener('click', function(e){
  var remind_link = new URL(this.href);
  var identity = document.getElementById('identity').value;
  if (/(?:^1[3456789]|^9[28])\d{9}$/.test(identity)) {
    this.href = remind_link.pathname + '?identity=' + identity;
  } else {
    alert('wrong number!');
    e.preventDefault();
  }
});
