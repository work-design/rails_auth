// todo add identity in location
document.getElementById('mobile_confirm').addEventListener('click', function(e){
  var identity = document.getElementById('identity').value;
  if (/.+/.test(identity)) {
    var countdown = 60;
    var link = new URL(this.href);
    var self = this;

    link.search = '?identity=' + identity;
    this.href = link;
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
    alert('请输入正确的邮箱或者手机号!');
    e.preventDefault();
    e.stopImmediatePropagation();
  }
});
