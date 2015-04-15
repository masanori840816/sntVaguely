(function () {
  var PostLists = React.createClass({displayName: "PostLists",
    getInitialState: function()
    {
      return{
        pageNum: 1,
        postList: []
      };
    },
    getPostItems: function()
    {
      $.ajax({
            type: 'GET',
            url: '/list?page=' + this.state.pageNum,
            dataType: 'json',
            success: function(postData) {
          this.setState({postList: postData});
        }.bind(this),
            error:function() {
                alert('Error');
            }.bind(this)
        });
    },
    componentDidMount: function()
    {
      // Componentのマウント時にAjaxを自動で実行.
      this.getPostItems();
    },
    render: function() {
      return (
        React.createElement(Post, {postList: this.state.postList})
      );
    }
  });
  var Post = React.createClass({displayName: "Post",
    render: function() {
      var posts = this.props.postList.map(function(postItem)
      {
        return (
          React.createElement("section", null, 
            React.createElement("a", {class: "post_title", href: postItem.postUrl}, postItem.postTitle), 
            React.createElement("article", {class: "post"}, postItem.post), 
            React.createElement(Category, {categoryList: postItem.category}), 
            React.createElement("footer", {class: "updateddate"}, postItem.updateDate)
          )
        );
      });
      return (
        React.createElement("div", null, posts)
      );
    }
  });
  var Category = React.createClass({displayName: "Category",
    render: function(){
      var categorys = this.props.categoryList.map(function(categoryItem)
      {
        return (
          React.createElement("a", {href: categoryItem.url}, categoryItem.title)
        );
      });
      return (
        React.createElement("nav", {class: "category"}, categorys)
      );
    }
  });
  React.render(React.createElement(PostLists, null), document.getElementById('main'));
}).call(this);
