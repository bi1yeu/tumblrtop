(->
  tumblrService = ($http, $q) ->

    # The following line is populated with a real key via
    # the gulp task 'set-key'
    # Please don't abuse my key! You can authorize your own app here:
    #   https://www.tumblr.com/oauth/apps
    API_KEY = '<consumer-key>'
    BATCH_SIZE = 20
    API_BASE_URL = 'http://api.tumblr.com/v2/'
    defaultParams =
      api_key: API_KEY
      callback: 'JSON_CALLBACK'

    getBlog: (blogName) ->
      deferred = $q.defer()
      url = API_BASE_URL + "blog/#{blogName}/info/"
      data =
        params: defaultParams
      $http.jsonp url, data
      .then (response) ->
        deferred.resolve response.data.response.blog
      , (error) ->
        deferred.reject error
      deferred.promise

    getAvatarUrl: (blogName) ->
      deferred = $q.defer()
      url = API_BASE_URL + "blog/#{blogName}/avatar/64"
      data =
        params: defaultParams
      $http.jsonp url, data
      .then (response) ->
        deferred.resolve response.data.response.avatar_url
      , (error) ->
        deferred.reject error
      deferred.promise

    getPosts: (blogName, batchNum) ->
      deferred = $q.defer()
      url = API_BASE_URL + "blog/#{blogName}/posts/"
      data =
        params: angular.extend {}, defaultParams,
          reblog_info: true
          offset: batchNum * BATCH_SIZE
          limit: BATCH_SIZE
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
