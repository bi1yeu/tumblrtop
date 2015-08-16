describe 'Main Directive', ->
  $scope = null
  $q = null
  $mdToast = null
  tumblrService = null
  element = null

  _blog =
    title: 'Blog title'
    name: 'testblog'
    posts: 123
    url: 'http://testblog.tumblr.com'
    updated: '1437703556'
    description: 'A good blog'
    is_nsfw: false
    ask: true
    ask_page_title: 'Ask me anything'
    ask_anon: true
    submission_page_title: 'Submit'
    share_likes: false

  _posts = [
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
  ,
    blog_name: 'myblog'
    id: 123456789100
    post_url: 'http://myblog.tumblr.com/post/123456789100/test-post3'
    slug: 'test-post'
    type: 'text'
    date: '2015-07-04 00:00:00 GMT'
    title: 'Test Post 3'
    note_count: 345
  ,
    blog_name: 'myblog'
    id: 123456789100
    post_url: 'http://myblog.tumblr.com/post/123456789100/test-post4'
    slug: 'test-post'
    type: 'text'
    date: '2015-07-04 00:00:00 GMT'
    title: 'Test Post 4'
    note_count: 345
    trail: [
      content: '<p>via <a href="http://someblog.tumblr.com/">Some Blog</a></p>'
    ]
  ]

  beforeEach ->
    module 'tumblrTopApp', 'templates'

  beforeEach inject (_$rootScope_, _$compile_, _$templateCache_,
    _$q_, _$mdToast_, _analysisService_, _tumblrService_) ->

    $rootScope = _$rootScope_
    $compile = _$compile_
    $templateCache = _$templateCache_
    $q = _$q_
    $mdToast = _$mdToast_

    tumblrService = _tumblrService_
    analysisService = _analysisService_

    directiveTemplate = $templateCache.get 'directive.main.html'
    templateUrl = 'directive.main.html'
    $templateCache.put templateUrl, directiveTemplate

    element = angular.element('<main-directive></main-directive>')

    $scope = $rootScope.$new()
    $compile(element)($scope)
    $scope.$digest()
    expect(element.html()).toContain 'Tumblr Top'

  afterEach ->
    $scope.$destroy()

  _set =
    mdToast:
      show: ->
        spyOn($mdToast, 'show').and.callThrough()
    service:
      getBlog: (success) ->
        spyOn(tumblrService, 'getBlog').and.callFake ->
          deferred = $q.defer()
          if success
            deferred.resolve _blog
          else
            # The service returns undefined blog instead of rejecting promise
            deferred.resolve undefined
          deferred.promise
      getPosts: (success) ->
        spyOn(tumblrService, 'getPosts').and.callFake (blogName, batchNum) ->
          deferred = $q.defer()
          if success
            posts = if batchNum > 0 then [] else _posts
            deferred.resolve posts
          else
            # The service returns undefined posts object instead of rejecting
            # promise
            deferred.resolve undefined
          deferred.promise
      getAvatarUrl: (success) ->
        spyOn(tumblrService, 'getAvatarUrl').and.callFake (blogName) ->
          deferred = $q.defer()
          if success
            deferred.resolve 'https://33.media.tumblr.com/avatar_abc123_64.png'
          else
            deferred.resolve undefined
          deferred.promise

  describe 'getting blog posts', ->
    beforeEach ->
      _set.service.getBlog true
      _set.service.getPosts true
      _set.service.getAvatarUrl true

    it 'adds tumblr domain to handles', ->
      $scope.view.blogName = 'testblog'
      $scope.view.startAnalysis()
      $scope.$apply()
      expect($scope.view.blogName).toBe('testblog.tumblr.com')

    it 'does not add tumblr domain to full urls', ->
      $scope.view.blogName = 'www.testblog.com'
      $scope.view.startAnalysis()
      $scope.$apply()
      expect($scope.view.blogName).toBe('www.testblog.com')

    it 'sanitizes the input blog name', ->
      $scope.view.blogName = 'http://testblog.tumblr.com/'
      $scope.view.startAnalysis()
      $scope.$apply()
      expect($scope.view.blogName).toBe('testblog.tumblr.com')

    it 'creates the correct post DOM elements', ->
      $scope.view.blogName = 'testblog'
      $scope.view.startAnalysis()
      $scope.$apply()
      expect(element.html()).toMatch(/Test Post 2/)
      expect(element.html()).toMatch(/Test Post 3/)
      expect(element.html()).not.toMatch(/Test Post 1/)
      expect(element.html()).not.toMatch(/Test Post 4/)

  describe 'handling errors', ->
    it 'shows error when blog DNE', ->
      _set.service.getBlog false
      spy = _set.mdToast.show()
      $scope.view.blogName = 'nonexistentblog.jpg'
      $scope.view.startAnalysis()
      $scope.$apply()
      expect(spy).toHaveBeenCalled()
      expect($scope.view.loadingPosts).toBeFalsy()

    it 'shows error when posts cannot be retrieved', ->
      _set.service.getAvatarUrl true
      _set.service.getBlog true
      _set.service.getPosts false
      spy = _set.mdToast.show()
      $scope.view.blogName = 'testblog'
      $scope.view.startAnalysis()
      $scope.$apply()
      expect(spy).toHaveBeenCalled()
      expect($scope.view.loadingPosts).toBeFalsy()
