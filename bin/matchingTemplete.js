var url =  phantom.args[0] || 'http://example.com/';
var page = require('webpage').create();

// ブラウザの解像度はシェアが高いものを参考に決定
// refs http://qiita.com/y_minowa/items/1ab5a8b0514d1f45b68c
page.viewportSize = {
  width: 1366,
  height: 768
};

page.open(url, function(status) {
  if (status !== 'success') {
    var errResponse = {status: status};
    console.log(JSON.stringify(errResponse));
    phantom.exit();
  }

  // ajaxでコンテンツを取得しているページ対策(1秒は主観)
  setTimeout(function() {
    if (page.injectJs('../lib/app.js') !== true) {
      var errResponse = {status: 'injectJs error'};
      console.log(JSON.stringify(errResponse));
      phantom.exit();
    };

    // レイアウトデータの取得
    var templateId = page.evaluate(function() {
      return window.T;
    });

    console.log(JSON.stringify({
      status: status,
      templateId: templateId
    }));    // rubyが受け取る返り値
    phantom.exit();
  }, 1000);
});
