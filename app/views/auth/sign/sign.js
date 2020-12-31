// todo add identity in location
import { Controller } from 'stimulus'

class LoginController extends Controller {
  static targets = ['identity']

  connect() {
    console.debug('Login Controller works!')
    this.countDown(this.element)
  }

  assignLocation(element) {
    let identity = element.target.value
    console.log(identity)
    let href = new URL(location.href)
    href.searchParams.set('identity', identity)
    history.pushState({}, document.title, href)
  }

  code(element) {
    if (/.+/.test(this.identityTarget.value)) {
      this.countDown(element)
    } else {
      alert('请输入正确的邮箱或者手机号!')
      e.preventDefault()
      e.stopImmediatePropagation()
    }
  }

  countDown(ele) {
    let countdown = parseInt(ele.dataset['time'])
    ele.innerText = '重新发送(' + countdown + ')'

    let timer = setInterval(function() {
      countdown--
      if (countdown <= 0) {
        ele.removeAttribute('disabled')
        ele.innerText = '获取验证码'
        clearInterval(timer)
      } else {
        ele.innerText = '重新发送(' + countdown + ')'
      }
    }, 1000, countdown, timer, ele)
  }

}

application.register('login', LoginController)
