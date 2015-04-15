(function () {
  var Posts = React.createClass({displayName: "Posts",
    render: function() {
      return (
        React.createElement("section", null, 
          React.createElement("article", {class: "post_title"}), 
          React.createElement("article", {class: "post_body"}), 
          React.createElement("nav", {class: "blog_category"}), 
          React.createElement("footer", {class: "blog_updateddate"})
        )
      );
    }
  });
  React.render(React.createElement(Posts, null), document.getElementById('main'));
}).call(this);
