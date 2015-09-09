var casper = require('casper').create({
  "viewportSize": {
    width: 980
  }
});
var url = casper.cli.get('url');

casper.start(url, function() {
  var basePath = '/home/vagrant/workspace/sm-admin/public/image/';
  var saveDirPath = url.replace(/^http(s)?:\/\//, '')
    .split('/')
    .slice(0, -1)
    .join('-');

  var originalFp = basePath + saveDirPath + '-original.jpg';
  this.capture(originalFp, undefined, {
    format: 'jpg',
    quality: 75
  });

  console.log(JSON.stringify({
    httpStatus: this.status().currentHTTPStatus,
    originalImageFilePath: originalFp
  }));
});

casper.run();
