(->
  tumblrService = ($http, $sce) ->

    # The following line is populated with a real key via
    # the gulp task 'set-key'
    API_KEY = '<consumer-key>'

    _filterUnoriginal = (response) ->
      posts = response.data.response.posts
      filteredPosts = []
      for post in posts
        if not post.reblogged_from_id?
          if post.body?
            post.body = $sce.trustAsHtml post.body
          filteredPosts.push post
      filteredPosts

    getPosts: (blogName) ->
        console.log "Getting top posts for #{blogName}.tumblr.com"
        url = "http://api.tumblr.com/v2/blog/#{blogName}.tumblr.com/posts/"
        data =
          params:
            api_key: API_KEY
            notes_info: true
            reblog_info: true
            callback: 'JSON_CALLBACK'
        $http.jsonp url, data
        .then _filterUnoriginal

  angular
    .module('tumblrTopApp')
    .service('tumblrService', tumblrService)
)()
