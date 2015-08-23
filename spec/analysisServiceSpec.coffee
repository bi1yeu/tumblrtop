describe 'Analysis Service', ->
  analysisService = null

  _posts = [
    note_count: 3086
    original: false
    tags: [
      'tag a'
      'tag b'
      'tag c'
      'tag d'
    ]
    timestamp: 1438956026
    type: 'photo'
    post_url: 'http://testblog.tumblr.com/post/126094961620/post-0'
  ,
    note_count: 474
    original: true
    tags: [
      'tag a'
      'Tag B'
      'tag e'
    ]
    timestamp: 1438963222
    type: 'photo'
    post_url: 'http://testblog.tumblr.com/post/126094961621/post-1'
  ,
    note_count: 164
    original: true
    tags: [
      'tag e'
      'tag f'
    ]
    timestamp: 1438970418
    type: 'link'
    post_url: 'http://testblog.tumblr.com/post/126094961622/post-2'
  ,
    note_count: 175
    original: false
    tags: []
    timestamp: 1438977626
    type: 'text'
    post_url: 'http://testblog.tumblr.com/post/126094961623/post-3'
  ,
    note_count: 992
    original: false
    tags: [
      'tag a'
      'tag b'
      'TAG C'
      'tag f'
    ]
    timestamp: 1438988432
    type: 'photo'
    post_url: 'http://testblog.tumblr.com/post/126094961624/post-4'
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

  _postsByTypeSeriesData =
    notes:
      both: [
        name: 'Link'
        y: 164
      ,
        name: 'Photo'
        y: 4552
      ,
        name: 'Text'
        y: 175
      ]
      originalOnly: [
        name: 'Link'
        y: 164
      ,
        name: 'Photo'
        y: 474
      ]
    posts:
      both: [
        name: 'Link'
        y: 1
      ,
        name: 'Photo'
        y: 3
      ,
        name: 'Text'
        y: 1
      ]
      originalOnly: [
        name: 'Link'
        y: 1
      ,
        name: 'Photo'
        y: 1
      ]

  _postsByTagSeriesData =
    notes:
      both: [
        name: 'tag b'
        y: 4552
      ,
        name: 'tag a'
        y: 4552
      ,
        name: 'tag c'
        y: 4078
      ,
        name: 'tag d'
        y: 3086
      ,
        name: 'tag f'
        y: 1156
      ,
        name: 'tag e'
        y: 638
      ]
      originalOnly: [
        name: 'tag e'
        y: 638
      ,
        name: 'tag b'
        y: 474
      ,
        name: 'tag a'
        y: 474
      ,
        name: 'tag f'
        y: 164
      ]
    posts:
      both: [
        name: 'tag b'
        y: 3
      ,
        name: 'tag a'
        y: 3
      ,
        name: 'tag f'
        y: 2
      ,
        name: 'tag e'
        y: 2
      ,
        name: 'tag c'
        y: 2
      ,
        name: 'tag d'
        y: 1
      ]
      originalOnly: [
        name: 'tag e'
        y: 2
      ,
        name: 'tag f'
        y: 1
      ,
        name: 'tag b'
        y: 1
      ,
        name: 'tag a'
        y: 1
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
      expected = _notesOverTimeSeriesData[1..2]
      actual = analysisService.getPostsOverTimeSeriesData _posts, 'notes', true
      expect(actual).toEqual(expected)

    it 'counts notes over time', ->
      expected = angular.copy _notesOverTimeSeriesData
      actual = analysisService.getPostsOverTimeSeriesData _posts, 'notes', false
      expect(actual).toEqual(expected)

  describe 'getting series data for posts by type', ->
    it 'counts notes by type (original only)', ->
      expected = angular.copy _postsByTypeSeriesData.notes.originalOnly
      actual = analysisService.getPostsByTypeSeriesData _posts, 'notes', true
      expect(actual).toEqual(expected)

    it 'counts notes by type', ->
      expected = angular.copy _postsByTypeSeriesData.notes.both
      actual = analysisService.getPostsByTypeSeriesData _posts, 'notes', false
      expect(actual).toEqual(expected)

    it 'counts posts by type (original only)', ->
      expected = angular.copy _postsByTypeSeriesData.posts.originalOnly
      actual = analysisService.getPostsByTypeSeriesData _posts, 'posts', true
      expect(actual).toEqual(expected)

    it 'counts posts by type', ->
      expected = angular.copy _postsByTypeSeriesData.posts.both
      actual = analysisService.getPostsByTypeSeriesData _posts, 'posts', false
      expect(actual).toEqual(expected)

  describe 'getting series data for posts by tag', ->
    it 'counts notes by tag (origial only)', ->
      expected = angular.copy _postsByTagSeriesData.notes.originalOnly
      actual = analysisService.getPostsByTagSeriesData _posts, 'notes', true
      expect(actual).toEqual(expected)

    it 'counts notes by tag', ->
      expected = angular.copy _postsByTagSeriesData.notes.both
      actual = analysisService.getPostsByTagSeriesData _posts, 'notes', false
      expect(actual).toEqual(expected)

    it 'counts posts by tag (original only)', ->
      expected = angular.copy _postsByTagSeriesData.posts.originalOnly
      actual = analysisService.getPostsByTagSeriesData _posts, 'posts', true
      expect(actual).toEqual(expected)

    it 'counts posts by tag', ->
      expected = angular.copy _postsByTagSeriesData.posts.both
      actual = analysisService.getPostsByTagSeriesData _posts, 'posts', false
      expect(actual).toEqual(expected)
