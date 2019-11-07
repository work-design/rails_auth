import './login'

$('.ui.form').form({
    fields: {
      password: {
          rules: [
              { type: 'empty', prompt: '密码不能为空' },
          ]
      },
      password_confirmation: {
          rules: [
              { type: 'match[password]', prompt: '两次输入不同' },
          ]
      },
      token: {
          rules: [
              { type: 'empty', prompt: '验证码不能为空' }
          ]
      }
    },
    revalidate: true,
    preventLeaving: true
  })
;
