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
    // e.g. http://example.com/hoge/moge/index.html
    var basePath = '/tmp/asm-images/';
    var saveDirPath = url.replace(/^http(s)?:\/\//, '')    // 'example.com/hoge/moge/index.html'
        .split('/')    // ['example.com', 'hoge', 'moge', 'index.html']
        .slice(0, -1)    // ['example.com', 'hoge', 'moge']
        .join('/');    // 'example.com/hoge/moge

    // gyazoにアップロードするまでの一時的な保存場所
    var tmpImageFilePath = basePath + saveDirPath + '/original.png';
    page.render(tmpImageFilePath);

    // TODO: レイアウト情報を取得してJSONで吐き出す
    var res = {
        status: status,
        image_file_path: tmpImageFilePath
    };
    console.log(JSON.stringify(res));    // rubyが受け取る返り値
  } else {
    // ページを開けなかった場合はstatusだけ返す
    var errResponse = {
        status: status
    };
    console.log(JSON.stringify(errResponse));
  }

  phantom.exit();
});
