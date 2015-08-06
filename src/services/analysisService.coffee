(->
  analysisService = ->

    _removeReblogs = (posts) ->
      _.filter posts, (post) ->
        post.original

    isOriginalPost: (post) ->
      if post.reblogged_from_id?
        return false

      # Some posts with deleted source blogs don't have a
      # reblogged_from_id; this is an attempt to still
      # differentiate those reblogs
      if post.trail?.length > 0 and post.trail[0]?.content.indexOf('.tumblr.com/') isnt -1
        return false

      return true

    countPostsOfType: (posts, type, originalOnly = false) ->
      count = 0
      countPost = (post) ->
        if originalOnly
          return post.type is type and post.originalOnly
        return post.type is type

      for post in posts when countPost post
        count += 1

      return count

    getNotesOverTimeSeriesData: (posts, originalOnly = true) ->
      if originalOnly
        posts = _removeReblogs posts
      seriesData = _.map posts, (post) ->
        x: +post.timestamp * 1000
        y: post.noteCount
        url: post.url
        type: post.type
      seriesData = _.filter seriesData, (datum) ->
        datum?

    getPostTypeSeriesData: (posts, originalOnly = true) ->
      if originalOnly
        posts = _removeReblogs posts
      counts = _.countBy posts, (post) ->
        post.type
      seriesData = []
      for type, count of counts
        seriesData.push
          name: type[0].toUpperCase() + type.slice(1)
          y: count
      _.sortBy seriesData, (datum) ->
        datum.name

    countNotesOfType: (posts, type) ->
      count = 0
      if type is 'like'
        for post in posts when post.likeCount?
          count += post.likeCount
      else if type is 'reblog'
        for post in posts when post.reblogCount?
          count += post.reblogCount

      return count

  angular
    .module('tumblrTopApp')
    .service('analysisService', analysisService)
)()
