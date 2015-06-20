angular.module('tumblrTopApp').directive 'mainDirective',
  ($templateCache) ->
    restrict: 'E'
    replace: true
    template: $templateCache.get('directive.main.html')
    controllerAs: 'view'
    controller: ($http) ->
      view = @
      view.posts = []
      view.getPosts = () ->
        console.log "Getting top posts for #{view.blogName}.tumblr.com"
        url = "http://api.tumblr.com/v2/blog/#{view.blogName}.tumblr.com/posts/photo?api_key=#{apiKey}&notes_info=true&callback=JSON_CALLBACK";

        $http.jsonp url
        .success (data) ->
          view.posts = data.response.posts
          console.log view.posts
        .error (data) ->
          console.log JSON.stringify(data, null, 2)
      return view
    link: () ->
      console.log 'hey!'