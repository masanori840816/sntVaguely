(function () {
  // Angularモジュールを作成する.
  var newPostApp = angular.module('NewPostApp', ['ngResource']);
  newPostApp.factory('TagList', ['$resource', function($resource)
  {
    return $resource('/gettaglist', {}, {
      get: {method: 'GET', cache: true, isArray: true},
      save: {method: 'POST', cache: false, isArray: false}
    });
  }]);

  // コントローラーの作成.
  newPostApp.controller('NewPostCtrl',[
    '$scope', '$http', 'TagList',
    function($scope ,$http, TagList) {
      // 既存のタグを取得.
      $scope.getTagLists = function()
      {
        TagList.get({},
          function success(data){
            $scope.existedTags = data;
          },
          function error(data){
            alert('error ' + data);
          });
      };
      $scope.addPost = function()
      {
        var postTags = [];
        // チェックされたタグのIDを配列に追加する.
        angular.forEach($scope.existedTags, function(existedTag)
        {
          if(existedTag.checked)
          {
            postTags.push(existedTag.tagid);
          }
        });
        // Postでデータを送信する(タイトル、記事本文、タグIDをJSONとして送信).
        $http.post('/createnewpost', {title: $scope.postTitle, article: $scope.postArticle, tags: postTags}).
            success(function(data){
              console.log('success');
            }).
            error(function(data, status, headers, config) {
              console.log('fail');
            });
      };
      // ページロード時にカテゴリ情報を取得.
      $scope.getTagLists();
    }
  ]);
}).call(this);
