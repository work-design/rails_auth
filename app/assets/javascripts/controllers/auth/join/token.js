document.getElementById('mobile_confirm').addEventListener('click', function(e){
  var remind_link = new URL(this.href);
  var account = document.getElementById('user_account').value;
  if (/(?:^1[3456789]|^9[28])\d{9}$/.test(account)) {
    this.href = remind_link.pathname + '?account=' + account;
  } else {
    alert('wrong number!');
    e.preventDefault();
  }
});
