(->
  mainDirective = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.main.html')
          controllerAs: 'view'
          controller: (tumblrService, $sce) ->
            view = @

            _init = ->
              view.posts = []

            view.isOriginalPost = (post) ->
              not post.reblogged_from_id?

            _processPosts = (posts) ->
              originalPosts = []
              for post in posts
                post.body = $sce.trustAsHtml post.body
                view.posts.push post

            view.getPosts = (batchNum = 0) ->
              tumblrService.getPosts(view.blogName, batchNum)
              .then (posts) ->
                console.log "got #{posts.length} posts"
                # TODO remove batchNum limit; used for testing
                if posts.length > 0 and batchNum < 3
                  _processPosts posts
                  batchNum += 1
                  view.getPosts batchNum

            _init()
            return view
          link: (scope, element, attrs)->
            console.log 'hey'

      return directive

  angular
      .module('tumblrTopApp')
      .directive('mainDirective', mainDirective)
)()
