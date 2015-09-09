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
    if (page.injectJs('../lib/smart-markup.segment.js') !== true) {
      var errResponse = {status: 'injectJs error'};
      console.log(JSON.stringify(errResponse));
      phantom.exit();
    };

    // オリジナル画面のキャプチャ処理
    // e.g. http://example.com/hoge/moge/index.html
    var basePath = '/home/vagrant/workspace/sm-admin/public/image/';
    var saveDirPath = url.replace(/^http(s)?:\/\//, '')    // 'example.com/hoge/moge/index.html'
        .split('/')    // ['example.com', 'hoge', 'moge', 'index.html']
        .slice(0, -1)    // ['example.com', 'hoge', 'moge']
        .join('-');    // 'example.com-hoge-moge
    // gyazoにアップロードするまでの一時的な保存場所
    var tmpOriginalImageFilePath = basePath + saveDirPath + '-original.png';
    page.render(tmpOriginalImageFilePath);

    // レイアウトデータの取得
    var layoutData = page.evaluate(function() {
      // 最小ブロックに分割
      SmartMarkup.divideIntoMinimumBlocks();

      // レイアウトデータの計算
      SmartMarkup.getLayoutData();

      return SmartMarkup.layoutData;
    });

    // 分割後のキャプチャを撮影
    page.evaluate(function() {
      SmartMarkup.debug();    // ページを書き換え
    });
    var tmpSeparatedImageFilePath = basePath + saveDirPath + '-separated.png';
    page.render(tmpSeparatedImageFilePath);

    var res = {
        status: status,
        original_image_file_path: tmpOriginalImageFilePath,
        separated_image_file_path: tmpSeparatedImageFilePath,
        layout_data: JSON.stringify(layoutData)
    };
    console.log(JSON.stringify(res));    // rubyが受け取る返り値
    phantom.exit();
  }, 1000);
});
