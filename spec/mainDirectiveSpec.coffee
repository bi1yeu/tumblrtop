describe 'Main Directive', () ->
  $scope = null

  _posts = [
    blog_name: 'myblog'
    id: 123456789098
    post_url: 'http://myblog.tumblr.com/post/123456789098/test-post'
    slug: 'test-post'
    type: 'text'
    date: '2015-07-02 00:00:00 GMT'
    note_count: 123
    reblogged_from_id: '120314354399'
  ,
    blog_name: 'myblog'
    id: 123456789099
    post_url: 'http://myblog.tumblr.com/post/123456789099/test-post'
    slug: 'test-post'
    type: 'text'
    date: '2015-07-03 00:00:00 GMT'
    note_count: 234
  ,
    blog_name: 'myblog'
    id: 123456789100
    post_url: 'http://myblog.tumblr.com/post/123456789100/test-post'
    slug: 'test-post'
    type: 'text'
    date: '2015-07-04 00:00:00 GMT'
    note_count: 345
  ]

  beforeEach ->
    module 'tumblrTopApp', 'templates'

  beforeEach inject (_$rootScope_, _$compile_, _$templateCache_,
    _tumblrService_) ->

    $rootScope = _$rootScope_
    $compile = _$compile_
    $templateCache = _$templateCache_
    tumblrService = _tumblrService_

    directiveTemplate = $templateCache.get 'directive.main.html'
    templateUrl = 'directive.main.html'
    $templateCache.put templateUrl, directiveTemplate

    element = angular.element('<main-directive></main-directive>')

    $scope = $rootScope.$new()
    $compile(element)($scope)
    $scope.$digest()
    expect(element.html()).toContain '<h1>Tumblr Top</h1>'

  afterEach ->
    $scope.$destroy()

  describe 'post analysis', ->
    it 'checks whether a post is original', ->
      rebloggedPost = _posts[0]
      originalPost = _posts[1]

      isOriginal = $scope.view.isOriginalPost rebloggedPost
      expect(isOriginal).toBeFalsy()

      isOriginal = $scope.view.isOriginalPost originalPost
      expect(isOriginal).toBeTruthy()

    it 'counts the number of original posts', ->
      $scope.view.posts = _posts
      expected = 2
      actual = $scope.view.countOriginalPosts()
      expect(actual).toBe expected
