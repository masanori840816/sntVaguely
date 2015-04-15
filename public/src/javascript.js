(function () {
  var PostLists = React.createClass({
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
        <Post postList={this.state.postList} />
      );
    }
  });
  var Post = React.createClass({
    render: function() {
      var posts = this.props.postList.map(function(postItem)
      {
        return (
          <section>
            <a class='post_title' href={postItem.postUrl}>{postItem.postTitle}</a>
            <article class='post'>{postItem.post}</article>
            <Category categoryList={postItem.category} />
            <footer class='updateddate'>{postItem.updateDate}</footer>
          </section>
        );
      });
      return (
        <div>{posts}</div>
      );
    }
  });
  var Category = React.createClass({
    render: function(){
      var categorys = this.props.categoryList.map(function(categoryItem)
      {
        return (
          <a href={categoryItem.url}>{categoryItem.title}</a>
        );
      });
      return (
        <nav class='category'>{categorys}</nav>
      );
    }
  });
  React.render(<PostLists/>, document.getElementById('main'));
}).call(this);
