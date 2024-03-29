/**
 * @overview
 *   - Webページを最小ブロックに分割するライブラリ
 *
 * @usage
 *   - SmartMarkup.run() : 全処理が走る（ページ分割、レイアウトデータ取得、HTMLの書き換え）
 *
 * @author saxsir
 */

(function() {

    function SmartMarkup() {
      this.minimumBlocks = [];
      this.hiddenBlocks = [];
      this.layoutData = {
        body: {},
        nodes: []
      };
    }

    SmartMarkup.prototype.run = function() {
        this.divideIntoMinimumBlocks();
        this.getLayoutData();
        this.debug();
    };

    /**
     * 最小ブロックに分割する関数
     */
    SmartMarkup.prototype.divideIntoMinimumBlocks = function() {
      // 最小ブロック候補をbodyから再帰的に探す
      this.minimumBlocks = findTmpMinimumBlocksWithDFS();
      // console.log(this.minimumBlocks.length); // debug

      // overflow:hiddenで隠れているブロックをbodyから再帰的に探す
      this.hiddenBlocks = findHiddenBlocksWithDFS();
      // console.log(this.hiddenBlocks.length); // debug

      // 最小ブロック候補から隠れブロックを除いたものを返す
      // 隠れブロックの子要素に関してもチェックする（取り除く）
      for (var i = 0; i < this.hiddenBlocks.length; i++) {
        var node = this.hiddenBlocks[i];
        this.removeHiddenBlock(node);
        this.minimumBlocks.push(node.parentNode);
      }

      // console.log(this.minimumBlocks.length);    // debug
    }

    /**
     * minimumBlocksから隠れノードを削除する関数
     */
    SmartMarkup.prototype.removeHiddenBlock = function(hNode) {
      this.minimumBlocks = this.minimumBlocks.filter(function(b) {
        return b !== hNode;
      });

      for (var i = 0; i < hNode.children.length; i++) {
        this.removeHiddenBlock(hNode.children[i]);
      }
    }

    /**
     * レイアウトデータを計算する関数
     */
    SmartMarkup.prototype.getLayoutData = function() {
      this.layoutData.body = getBodyLayoutData();
      for (var i = 0; i < this.minimumBlocks.length; i++) {
        this.layoutData.nodes.push(getNodeLayoutData(this.minimumBlocks[i]));
      }
    }

    /**
     * 取得したレイアウトデータを再描画して分割結果を確認する関数
     */
    SmartMarkup.prototype.debug = function() {
      var head = document.getElementsByTagName('head')[0],
        body = document.getElementsByTagName('body')[0];

      for (var i = head.children.length - 1; i >= 0; i--) {
        head.removeChild(head.children[i]);
      }
      for (var i = body.children.length - 1; i >= 0; i--) {
        body.removeChild(body.children[i]);
      }

      // bodyのレイアウトデータを反映
      var style = '';
      style += 'width:' + this.layoutData.body.width + 'px;';
      style += 'height:' + this.layoutData.body.height + 'px;';
      style += 'list-style:none;';
      style += 'color:rgb(' + this.layoutData.body.red + ',' + this.layoutData.body.green + ',' + this.layoutData.body.blue + ');';
      style += 'font-size:' + this.layoutData.body.fontSize + 'px;';
      style += 'font-weight:' + this.layoutData.body.fontWeight + ';';
      body.setAttribute('style', style);

      // bodyに子要素を追加
      for (var i = 0; i < this.layoutData.nodes.length; i++) {
        var n = this.layoutData.nodes[i];
        var element = document.createElement('div');
        var style = '';
        style += 'position:absolute;';
        style += 'top:' + n.top + 'px;';
        style += 'left:' + n.left + 'px;';
        style += 'width:' + n.width + 'px;';
        style += 'height:' + n.height + 'px;';
        style += 'color:rgb(' + n.color.red + ',' + n.color.green + ',' + n.color.blue + ');';
        style += 'font-size:' + n.fontSize + 'px;';
        style += 'font-weight:' + n.fontWeight + ';';
        style += 'border:1px solid black;';

        element.setAttribute('style', style);
        body.appendChild(element);
      }
    }

    /**
     * 最小ブロック候補の配列を返す
     */
    function findTmpMinimumBlocksWithDFS() {
      var _minimumBlocks = [];
      findTmpMinimumBlocksWithDFS_r(document.body);
      return _minimumBlocks;

      // 受け取ったノードから最小ブロックにぶつかるまで再帰的に探索する
      function findTmpMinimumBlocksWithDFS_r(node) {
        if (isMinimumBlock(node) === true) {
          return _minimumBlocks.push(node);
        }

        for (var i = 0; i < node.children.length; i++) {
          findTmpMinimumBlocksWithDFS_r(node.children[i]);
        }
      }
    }


    /**
     * 最小ブロック候補かどうか判定する関数
     */
    function isMinimumBlock(node) {
      // 有効ノードじゃなければfalse
      if (isEnableNode(node) !== true) {
        return false;
      }

      if (isBlockElement(node) === true) {
        // 子要素がなければtrue
        if (node.children.length === 0) {
          return true;
        }

        // 子要素にブロック要素があったらfalse
        for (var i = 0; i < node.children.length; i++) {
          if (isBlockElement(node.children[i])) {
            return false;
          }
        }

        // 子要素にブロック要素がなければtrue
        return true
      } else if (hasMinimumBlockSiblings(node)) {
        return true;
      }

      return false;
    }

    /**
     * 有効ノードか判定する関数
     */
    function isEnableNode(node) {
      if (node.tagName.toLowerCase() === 'script') {
        return false;
      }

      var style = getComputedStyle(node);
      if (style.display === 'none' ||
        style.visibility === 'hidden' ||
        style.opacity === '0') {
        return false;
      }

      var bounds = node.getBoundingClientRect();
      if (bounds.width <= 1 && bounds.height <= 1) {
        return false;
      }
      if (bounds.right <= 0 && bounds.bottom <= 0) {
        return false;
      }
      // TODO: leftが画面全体より右, topが画面全体より下にある場合の処理はしなくて大丈夫なのか？

      return true;
    }

    /**
     * ブロック要素か判定する関数
     */
    function isBlockElement(node) {
      if (isEnableNode(node) !== true) {
        return false;
      }

      var style = getComputedStyle(node);
      if (style.display === 'block') {
        return true;
      }

      // FIXME: style.displayが指定されていない場合は下記の処理でいいが, block以外に指定されている場合はfalseを返す
      // block, inline, inline-blockが多そう（それ以外もあるが...）

      var blockElements = [
        'p', 'blockquote', 'pre', 'div', 'noscript', 'hr', 'address', 'fieldset', 'legend',
        'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'ul', 'ol', 'li', 'dl', 'dt', 'dd',
        'table', 'caption', 'thead', 'tbody', 'colgroup', 'col', 'tr', 'th', 'td', 'embed',
        'section', 'article', 'nav', 'aside', 'header', 'footer', 'address'
      ];
      if (blockElements.indexOf(node.tagName.toLowerCase()) !== -1) {
        return true;
      }

      // TODO: spanだけど中にdivが入ってる厄介なやつがいる...
      // 暫定的に、1階層下まで見てブロック要素があったらブロック要素判定する
      for (var i=0; i<node.children.length; i++) {
          if (isBlockElement(node.children[i])) {
              return true;
          }
      }

      return false;
    }

    /**
     * 兄弟ブロックに最小ブロックがあるか判定する関数
     */
    function hasMinimumBlockSiblings(node) {
      var siblings = node.parentNode.children;
      for (var i = 0; i < siblings.length; i++) {
        var sibling = siblings[i];
        // TODO: ここisMinimumBlockで判定しちゃダメなの？
        if (node !== sibling && isBlockElement(node)) {
          if (sibling.children.length === 0) {
            return true;
          }

          var minBlockFlg = true;
          for (var j = 0; j < sibling.children.length; j++) {
            var child = sibling.children[j];
            if (isBlockElement(child)) {
              minBlockFlg = false;
            }
            if (minBlockFlg === true) {
              return true;
            }
          }
        }
      }

      return false;
    }

    /**
     * 隠れブロックの配列を返す
     */
    function findHiddenBlocksWithDFS() {
      var _hiddenBlocks = [];
      findHiddenBlocksWithDFS_r(document.body);
      return _hiddenBlocks;

      function findHiddenBlocksWithDFS_r(node) {
        // FIXME: この条件いれたら意味なくないか？最小ブロック判定されたのに隠れてるノードを見つけたいのに...
        if (isMinimumBlock(node) === true) {
          return null
        }

        var style = getComputedStyle(node);
        if (style.overflow === 'hidden') {
          var parentBounds = node.getBoundingClientRect();
          var top = parentBounds.top,
            left = parentBounds.left,
            right = parentBounds.right,
            bottom = parentBounds.bottom;

          for (var i = 0; i < node.children.length; i++) {
            var child = node.children[i];
            var childBounds = child.getBoundingClientRect();
            // TODO: 条件を見直す
            // やっぱり最初の方が正しい気がする...
            // if (childBounds.right > right ||
            // childBounds.bottom > bottom ||
            // childBounds.left < left ||
            // childBounds.top < top) {
            // childBounds.left > left ||
            // childBounds.top > top) {
            if (childBounds.left < right &&
                left < childBounds.right &&
                childBounds.top < bottom &&
                top < childBounds.bottom) {

            _hiddenBlocks.push(child);
          }
        }
      }

      for (i = 0; i < node.children.length; i++) {
        findHiddenBlocksWithDFS_r(node.children[i]);
      }
    }
  }

  /**
   * bodyのレイアウト情報を取得する
   */
  function getBodyLayoutData() {
    var body = document.body,
      style = window.getComputedStyle(body),
      bounds = body.getBoundingClientRect(),
      color = style.color.split(',');

    return {
      color: {
        r: color[0].replace(/\D/g, ''),
        g: color[1].replace(/\D/g, ''),
        b: color[2].replace(/\D/g, '')
      },
      width: bounds.width,
      height: bounds.height,
      fontSize: style.fontSize,
      fontWeight: style.fontWeight
    };
  }

  /**
   * ノードのレイアウト情報を返す
   */
  function getNodeLayoutData(node) {
    var style = getComputedStyle(node),
      color = style.color.split(','),
      bounds = node.getBoundingClientRect();

    var tagName = node.tagName.toLowerCase(),
      fontSize = style.fontSize,
      text = node.innerHTML.replace(/<[^>]*?>/g, ''),
      width = bounds.width,
      height = bounds.height;

    return {
      color: {
        r: color[0].replace(/\D/g, ''),
        g: color[1].replace(/\D/g, ''),
        b: color[2].replace(/\D/g, '')
      },
      width: bounds.width,
      height: bounds.height,
      top: bounds.top,
      left: bounds.left,
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      // innerHTML: text,
    };
  }

  window.SmartMarkup = new SmartMarkup();
})();
