(->
  tumblrService = ($http) ->

    # The following line is populated with a real key via
    # the gulp task 'set-key'
    API_KEY = '<consumer-key>'
    BATCH_SIZE = 20
    API_BASE_URL = 'http://api.tumblr.com/v2/'

    getBlog: (blogName) ->
      console.log "Getting blog info for #{blogName}"
      url = API_BASE_URL + "blog/#{blogName}/info/"
      data =
        params:
          api_key: API_KEY
          callback: 'JSON_CALLBACK'
      $http.jsonp url, data
      .then (response) ->
        response.data.response.blog
      , (error) ->
        console.log error

    getPosts: (blogName, batchNum) ->
        console.log "Getting top posts for #{blogName}"
        url = API_BASE_URL + "blog/#{blogName}/posts/"
        data =
          params:
            api_key: API_KEY
            notes_info: true
            reblog_info: true
            notes_info: true
            offset: batchNum * BATCH_SIZE
            limit: BATCH_SIZE
            callback: 'JSON_CALLBACK'
        $http.jsonp url, data
        .then (response) ->
          response.data.response.posts
        , (error) ->
          console.log error

  angular
    .module('tumblrTopApp')
    .service('tumblrService', tumblrService)
)()
