(->
  tumblrService = ($http, $q) ->

    # The following line is populated with a real key via
    # the gulp task 'set-key'
    # Please don't abuse my key! You can authorize your own app here:
    #   https://www.tumblr.com/oauth/apps
    API_KEY = '<consumer-key>'
    BATCH_SIZE = 20
    API_BASE_URL = 'http://api.tumblr.com/v2/'

    getBlog: (blogName) ->
      deferred = $q.defer()
      url = API_BASE_URL + "blog/#{blogName}/info/"
      data =
        params:
          api_key: API_KEY
          callback: 'JSON_CALLBACK'
      $http.jsonp url, data
      .then (response) ->
        deferred.resolve response.data.response.blog
      , (error) ->
        deferred.reject error
      deferred.promise

    getPosts: (blogName, batchNum) ->
      deferred = $q.defer()
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
        deferred.resolve response.data.response.posts
      , (error) ->
        deferred.reject error
      deferred.promise

  angular
    .module('tumblrTopApp')
    .service('tumblrService', tumblrService)
)()
