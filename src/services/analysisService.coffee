(->
  analysisService = ->

    _removeReblogs = (posts) ->
      _(posts).filter 'original'

    isOriginalPost: (post) ->
      if post.reblogged_from_id?
        return false

      # Some posts with deleted source blogs don't have a
      # reblogged_from_id; this is an attempt to still
      # differentiate those reblogs
      if post.trail? and post.trail.length > 0 and post.trail[0]? and
          post.trail[0].content.indexOf('.tumblr.com/') isnt -1
        return false

      # Others have a reblog tree with links
      if post.reblog? and post.reblog.tree_html.indexOf('.tumblr.com/') isnt -1
        return false

      true

    getPostsOverTimeSeriesData: (posts, whatToCount, originalOnly = true) ->
      if originalOnly
        posts = _removeReblogs posts
      seriesData = _(posts).map (post) ->
        x: +post.timestamp * 1000
        y: if whatToCount is 'posts'\
          then 1\
          else if whatToCount is 'notes'
            +post.note_count
        url: post.post_url
        type: post.type

      _(seriesData).filter (datum) -> datum?

    getPostsByTypeSeriesData: (posts, whatToCount, originalOnly = true) ->
      if originalOnly
        posts = _removeReblogs posts

      grouped = _(posts).groupBy (post) ->
        post.type

      counted = []
      for type, posts of grouped
        counted.push
          name: type[0].toUpperCase() + type.slice 1
          y: if whatToCount is 'posts'\
            then posts.length\
            else if whatToCount is 'notes'
              _(posts).reduce (prev, curr) ->
                prev + curr.note_count
              , 0

      _(counted).sortBy (datum) -> datum.name

    getPostsByTagSeriesData: (posts, whatToCount, originalOnly = true) ->
      if originalOnly
        posts = _removeReblogs posts

      allTags = []
      for post in posts
        for tag in post.tags
          allTags.push
            name: tag.toLowerCase()
            y: if whatToCount is 'posts'\
              then 1\
              else if whatToCount is 'notes'
                post.note_count

      grouped = _(allTags).groupBy 'name'
      summed = _(grouped).map (count, key) ->
        name: key,
        y: _(count).reduce (prev, curr) ->
          prev + curr.y
        , 0

      _(summed).sortBy('y').reverse()[0..20]

  angular
    .module('tumblrTopApp')
    .service('analysisService', analysisService)
)()
