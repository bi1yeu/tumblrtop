(->
  tumblrService = ($http) ->

    API_KEY = 'del3t3MeeeeEEE3'

    getPosts: (blogName) ->
        console.log "Getting top posts for #{blogName}.tumblr.com"
        url = "http://api.tumblr.com/v2/blog/#{blogName}.tumblr.com/posts/photo?api_key=#{API_KEY}&notes_info=true&callback=JSON_CALLBACK";
        $http.jsonp url

  angular
    .module('tumblrTopApp')
    .service('tumblrService', tumblrService)
)()
