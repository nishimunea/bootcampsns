'use strict';

function fetcher(url, request, callback) {
  let headers = new Headers();
  headers.append('X-Requested-With', 'Fetch');
  request['headers'] = headers;
  request['credentials'] = 'include';
  request['cache'] = 'no-cache';

  let process = response => {
    if(response.status === 403) {
      // サーバからセッションエラー(403)が返却されたら強制ログアウト
      localStorage.removeItem('name');
      localStorage.removeItem('icon');
      top.location = '/'; // ページをリロードしてログイン画面を表示
      return;
    }
    let contentType = response.headers.get('content-type');
    if(contentType && contentType.indexOf('application/json') !== -1) {
      return response.json().then(json => json);
    }
  };

  fetch(url ,request).then(process).then(callback);
}

var $$ = (id) => document.getElementById(id);

Node.prototype.prependChild = function(e){ this.insertBefore(e,this.firstChild); }
