var page = require('webpage').create();
page.open('http://www.yahoo.co.jp/', function(status) {
  console.log("Status: " + status);
  if(status === "success") {
    page.render('example.png');
  }
  phantom.exit();
});
