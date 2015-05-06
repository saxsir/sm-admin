var url =  phantom.args[0] || 'http://example.com';
var id =  phantom.args[1] || '-1' ;
var page = require('webpage').create();

page.open(url, function(status) {
  if(status === "success") {
    page.render('./app/assets/images/screen-shots/' + id + '.png');
  }
  console.log(status); //rubyが受け取る返り値
  phantom.exit();
});
