// todo add identity in location
import { Controller } from '@hotwired/stimulus'
//import { application } from 'rails_design_engine_ui/javascripts/stimulus'

class LoginController extends Controller {
  static targets = ['identity']

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
