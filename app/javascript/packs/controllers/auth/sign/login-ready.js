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
    let identity = this.identityTarget.value
    let ele = element.target

    if (/.+/.test(identity)) {
      let countdown = parseInt(ele.dataset['time'])
      let url = new URL(ele.dataset['url'])
      url.searchParams.set('identity', identity)
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
    } else {
      alert('请输入正确的邮箱或者手机号!')
      e.preventDefault()
      e.stopImmediatePropagation()
    }
  }

}

application.register('login', LoginController)


