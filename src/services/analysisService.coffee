(->
  analysisService = ->

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
      seriesData = _.map posts, (post) ->
        if (originalOnly and post.original) or not originalOnly
          [+post.timestamp * 1000, post.noteCount]
      seriesData = _.filter seriesData, (datum) ->
        datum?
      _.sortBy seriesData, (datum) ->
        datum[0]

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
