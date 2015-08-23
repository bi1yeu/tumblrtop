describe 'Tumblr Service', ->
  $httpBackend = null
  tumblrService = null

  beforeEach ->
    module 'tumblrTopApp'

  beforeEach inject (_$httpBackend_, _tumblrService_) ->
    $httpBackend = _$httpBackend_
    tumblrService = _tumblrService_

  _blogResponse =
    response:
      blog:
        title: 'Test Blog'
        posts: 123
        name: 'testblog'

  _avatarResponse =
    response:
      avatar_url: 'https://33.media.tumblr.com/avatar_abc123_64.png'

  _postsResponse =
    response:
      posts: [
        blog_name: 'myblog'
        id: 123456789098
        post_url: 'http://myblog.tumblr.com/post/123456789098/test-post'
        slug: 'test-post'
        type: 'text'
        date: '2015-07-02 00:00:00 GMT'
        note_count: 123
        title: 'Test Post 1'
        reblogged_from_id: '120314354399'
      ,
        blog_name: 'myblog'
        id: 123456789099
        post_url: 'http://myblog.tumblr.com/post/123456789099/test-post2'
        slug: 'test-post'
        type: 'text'
        date: '2015-07-03 00:00:00 GMT'
        title: 'Test Post 2'
        note_count: 234
      ]

  describe 'getting Tumblr models', ->
    it 'gets blog info', ->
      tumblrService.getBlog('testblog.tumblr.com')
      $httpBackend.expectJSONP(/http:\/\/api.tumblr.com\/v2\/blog\/testblog.tumblr.com\/info\/.*/)
        .respond(200, _blogResponse)
      $httpBackend.flush()

    it 'gets avatar url', ->
      tumblrService.getAvatarUrl('testblog.tumblr.com')
      $httpBackend.expectJSONP(/http:\/\/api.tumblr.com\/v2\/blog\/testblog.tumblr.com\/avatar\/64.*/)
        .respond(200, _avatarResponse)
      $httpBackend.flush()

    it 'gets posts', ->
      tumblrService.getPosts('testblog.tumblr.com', 5)
      # assuming batch size is 20 posts
      $httpBackend.expectJSONP(/http:\/\/api.tumblr.com\/v2\/blog\/testblog.tumblr.com\/posts\/.*limit=20&offset=100&reblog_info=true/)
        .respond(200, _postsResponse)
      $httpBackend.flush()
