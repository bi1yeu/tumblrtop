describe 'Analysis Service', ->
  analysisService = null

  _posts = [
    noteCount: 3086
    original: false
    tags: [
      'comedy'
      'news'
      'interview'
      'politics'
    ]
    timestamp: 1438956026
    type: 'photo'
    url: 'http://testblog.tumblr.com/post/126094961620/post-0'
  ,
    noteCount: 474
    original: true
    tags: [
      'math'
      'mobius strip'
      'gif'
      'breakfast'
      'carbs'
    ]
    timestamp: 1438963222
    type: 'photo'
    url: 'http://testblog.tumblr.com/post/126094961621/post-1'
  ,
    noteCount: 164
    original: true
    tags: [
      'North Korea'
      'Time Zone'
    ]
    timestamp: 1438970418
    type: 'link'
    url: 'http://testblog.tumblr.com/post/126094961622/post-2'
  ,
    noteCount: 175
    original: false
    tags: []
    timestamp: 1438977626
    type: 'text'
    url: 'http://testblog.tumblr.com/post/126094961623/post-3'
  ,
    noteCount: 992
    original: false
    tags: [
      'punk'
      'conversation'
      'podcast'
      'gender'
      'identity'
      'feminist'
    ]
    timestamp: 1438988432
    type: 'photo'
    url: 'http://testblog.tumblr.com/post/126094961624/post-4'
  ]

  _notesOverTimeSeriesData = [
    x: 1438956026000
    y: 3086
    url: 'http://testblog.tumblr.com/post/126094961620/post-0'
    type: 'photo'
  ,
    x: 1438963222000
    y: 474
    url: 'http://testblog.tumblr.com/post/126094961621/post-1'
    type: 'photo'
  ,
    x: 1438970418000
    y: 164
    url: 'http://testblog.tumblr.com/post/126094961622/post-2'
    type: 'link'
  ,
    x: 1438977626000
    y: 175
    url: 'http://testblog.tumblr.com/post/126094961623/post-3'
    type: 'text'
  ,
    x: 1438988432000
    y: 992
    url: 'http://testblog.tumblr.com/post/126094961624/post-4'
    type: 'photo'
  ]

  beforeEach ->
    module 'tumblrTopApp'

  beforeEach inject (_analysisService_) ->
    analysisService = _analysisService_

  describe 'determining reblog status', ->
    it 'detects original post', ->
      originalPost =
        title: 'Some post'
        id: 12345
        trail: [
          content: 'test'
        ]
        reblog:
          tree_html: 'nothing here :)'

      result = analysisService.isOriginalPost originalPost
      expect(result).toBeTruthy()

    it 'detects reblogged post', ->
      rebloggedPost =
        title: 'Some other post'
        id: 12346
        reblogged_from_id: 999

      result = analysisService.isOriginalPost rebloggedPost
      expect(result).toBeFalsy()

    it 'detects reblogged post without reblogged from id', ->
      rebloggedPost =
        title: 'Yet another post'
        id: 12347
        trail: [
          content: '<p>via<a href="http://www.source.tumblr.com/">sourceblog</a>'
        ]

      result = analysisService.isOriginalPost rebloggedPost
      expect(result).toBeFalsy()

    it 'detects reblogged post with reblog tree', ->
      rebloggedPost =
        title: 'Again!'
        id: 12348
        trail: []
        reblog:
          tree_html: '<p><a href="http://otherblog.tumblr.com/other/post" target="_blank">other blog</a>'

      result = analysisService.isOriginalPost rebloggedPost
      expect(result).toBeFalsy()

  describe 'getting series data for posts over time', ->
    it 'counts notes over time (original only)', ->
      expected = angular.copy _notesOverTimeSeriesData
      actual = analysisService.getPostsOverTimeSeriesData _posts, 'notes', false
      expect(actual).toEqual(expected)

    it 'counts notes over time', ->
      expect(true).toBe(false)

  describe 'getting series data for posts by type', ->
    it 'counts notes by type (original only)', ->
      expect(true).toBe(false)

    it 'counts notes by type', ->
      expect(true).toBe(false)

    it 'counts posts by type (original only)', ->
      expect(true).toBe(false)

    it 'counts posts by type', ->
      expect(true).toBe(false)
