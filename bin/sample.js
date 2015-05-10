var url =  phantom.args[0] || 'http://example.com/';
var page = require('webpage').create();

// ブラウザの解像度はシェアが高いものを参考に決定
// refs http://qiita.com/y_minowa/items/1ab5a8b0514d1f45b68c
page.viewportSize = {
  width: 1366,
  height: 768
};

page.open(url, function(status) {
  if(status === "success") {
    page.render('./app/assets/images/screen-shots/' + pageId + '.png');
  }
  console.log(status); //rubyが受け取る返り値
  phantom.exit();
});
