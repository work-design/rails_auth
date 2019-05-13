document.getElementById('mobile_confirm').addEventListener('click', function(e){
  var identity = document.getElementById('identity').value;
  if (/.+/.test(identity)) {
    var countdown = 60;
    var self = this;

    this.href += '?identity=' + identity;
    this.classList.add('disabled');
    this.innerText = '重新发送(' + countdown + ')';

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
  } else {
    alert('wrong number!');
    e.preventDefault();
    e.stopImmediatePropagation();
  }
});
