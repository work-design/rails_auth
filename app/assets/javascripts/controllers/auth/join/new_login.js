document.getElementById('mobile_confirm').addEventListener('click', function(e){
  var remind_link = new URL(this.href);
  var identity = document.getElementById('identity').value;
  var countdown = 60;
  var self = this;

  this.href = remind_link.pathname + '?identity=' + identity;
  this.classList.add('disabled');
  self.innerText = '重新发送(' + countdown + ')';

  var timer = setInterval(function() {
    countdown--;
    if (countdown <= 0) {
      self.classList.remove('disabled');
      self.innerText = '获取验证码';
      clearInterval(timer);
    } else {
      self.innerText = '重新发送(' + countdown + ')';
    }
  }, 1000, countdown, timer, self);
});
