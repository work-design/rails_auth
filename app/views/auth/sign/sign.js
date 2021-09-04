// todo add identity in location
import { Controller } from '@hotwired/stimulus'

class LoginController extends Controller {
  static targets = ['identity']


  connect() {
    console.debug('local controller connected:', this.identifier)
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

}

application.register('login', LoginController)
