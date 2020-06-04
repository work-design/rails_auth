// todo add identity in location
import { Controller } from 'stimulus'

class LoginController extends Controller {
  static targets = ['identity']

  connect() {
    console.log('Login Controller works!')
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

  countDown(element) {
    let ele = element.target
    let countdown = parseInt(ele.dataset['time'])
    let url = new URL(ele.dataset['url'])
    if (this.hasIdentityTarget) {
      url.searchParams.set('identity', this.identityTarget.value)
    }
    Rails.ajax({ url: url, type: 'POST', dataType: 'script' })

    ele.setAttribute('disabled', '')
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
