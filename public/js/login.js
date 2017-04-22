'use strict';

document.addEventListener('DOMContentLoaded', () => {
  $$('form-login').addEventListener('submit', (event) => {
    event.preventDefault();

    let body = new FormData();
    body.append('user', $$('input-user').value);
    body.append('pass', $$('input-pass').value);

    let process = result => {
      if (result.name) {
        // ログイン成功
        localStorage.setItem('name', result.name);
        localStorage.setItem('icon', result.icon);
        top.location = '/'; // メイン画面を表示
      } else {
        // ログイン失敗
        $$('div-errors').innerHTML = '';
        result.errors.forEach(value => $$('div-errors').innerHTML += `<p class="bg-danger text-danger">${value}</p>` );
      }
    }

    fetcher('/sessions' ,{method: 'POST', body: body}, process);
  });
});