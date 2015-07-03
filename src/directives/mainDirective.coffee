(->
  mainDirective = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.main.html')
          controllerAs: 'view'
          controller: (tumblrService, $sce) ->
            view = @
            view.POST_LIMIT_INCR = 3

            _init = ->
              view.posts = []
              view.blog = {}
              view.debugStop = false
              view.displayPostLimit = 3

            view.isOriginalPost = (post) ->
              not post.reblogged_from_id?

            view.countOriginalPosts = ->
              count = 0
              for post in view.posts when view.isOriginalPost post
                count += 1
              return count

            view.startAnalysis = ->
              _init()
              tumblrService.getBlog(view.blogName)
              .then (blog) ->
                view.blog = blog

              _getPosts()

            _processPosts = (posts) ->
              for post in posts
                post.body = $sce.trustAsHtml post.body
                view.posts.push post

            _getPosts = (batchNum = 0) ->
              tumblrService.getPosts(view.blogName, batchNum)
              .then (posts) ->
                console.log "got #{posts.length} posts"
                # TODO remove batchNum limit; used for testing
                if posts.length > 0 and not view.debugStop
                  _processPosts posts
                  _getPosts batchNum += 1

            _init()
            return view
          link: (scope, element, attrs)->
            console.log 'hey'

      return directive

  angular
      .module('tumblrTopApp')
      .directive('mainDirective', mainDirective)
)()
