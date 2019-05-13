document.getElementById('mobile_confirm').addEventListener('click', function(e){
  var remind_link = new URL(this.href);
  var identity = document.getElementById('identity').value;
  var countdown = 5;
  var self = this;
  this.href = remind_link.pathname + '?identity=' + identity;

  this.setAttribute('disabled', true);

  var timer = setInterval(function() {
    countdown--;
    if (countdown <= 0) {
      //self.removeAttribute('disabled');
      self.innerText = '获取验证码';
      clearInterval(timer);
    } else {
      self.innerText = '重新发送(' + countdown + ')';
    }
  }, 1000, countdown, timer, self);
});
