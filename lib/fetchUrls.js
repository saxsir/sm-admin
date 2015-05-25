/*
 * 実行した時点でのGoogle検索結果（URLのみ）を出力するスクリプト
 *
 * Usage
 *   $ node search.js '{query}'
 *
 */
var client = require('cheerio-httpcli'),
  query = process.argv[2],
  urls = [];

// 10件の検索結果を取得する
client.fetch('http://www.google.com/search', {
  q: query
}, function(err, $, res) {
  $('h3.r > a').each(function(idx) {
    urls.push($(this).attr('href'));
  });

  var blackList = [
    'ja.wikipedia.org',
    'www.amazon.co.jp'
  ];

  urls = urls.filter(function(url, index, array) {
    var domain = url.match(/^(.+?):\/\/(.+?):?(d+)?(\/.*)?$/)[2];
    return (blackList.indexOf(domain) < 0);
  });
  console.log(JSON.stringify(urls));
});
