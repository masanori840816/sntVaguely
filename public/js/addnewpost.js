(function () {
  // Angularモジュールを作成する.
  var newPostApp = angular.module('NewPostApp', []);

  // コントローラーの作成.scope、httpを引数とする.
  newPostApp.controller('NewPostCtrl',[
    '$scope', '$http',
    function($scope ,$http) {
      $scope.getTagLists = function()
      {
        // カテゴリ情報をセットする.
        $http({method: 'GET', url: '/gettaglist'}).
          success(function(data){
            console.log(data[0].tagname);
          }).
          error(function(data, status, headers, config) {
            console.log('fail');
          });
      };
      $scope.addPost = function()
      {
        // Postでデータを送信する(タイトル、記事本文をJSONとして送信).
        $http.post('/create', {title: $scope.postTitle, article: $scope.postArticle}).
            success(function(data){
              console.log('success');
            }).
            error(function(data, status, headers, config) {
              console.log('fail');
            });
        // タイトルのテキストボックスを空にする.
        $scope.postTitle = '';
      };
      // ページロード時にカテゴリ情報を取得.
      $scope.getTagLists();
    }
  ]);
}).call(this);
