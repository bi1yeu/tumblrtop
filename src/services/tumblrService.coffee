(->
  tumblrService = ($http) ->

    # The following line is populated with a real key via
    # the gulp task 'set-key'
    API_KEY = ''
    BATCH_SIZE = 5

    getPosts: (blogName, batchNum) ->
        console.log "Getting top posts for #{blogName}.tumblr.com"
        url = "http://api.tumblr.com/v2/blog/#{blogName}.tumblr.com/posts/"
        data =
          params:
            api_key: API_KEY
            notes_info: true
            reblog_info: true
            notes_info: true
            offset: batchNum * BATCH_SIZE
            limit: BATCH_SIZE
            callback: 'JSON_CALLBACK'
        promise = $http.jsonp url, data
        .then (response) ->
          response.data.response.posts
        , (error) ->
          alert 'Error getting posts!'
          console.log error
          promise.$promise.reject(error)

  angular
    .module('tumblrTopApp')
    .service('tumblrService', tumblrService)
)()
