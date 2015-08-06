(->
  mainDirective = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.main.html')
          controllerAs: 'view'
          controller: ($sce, $mdToast, analysisService, tumblrService) ->
            view = @
            view.POST_LIMIT_INCR = 18
            _POST_LIMIT_INIT = 18
            _BLOG_NOT_FOUND_MSG = "Couldn't find that blog, sorry!"
            _POST_RETRIEVAL_ERR_MSG = "Couldn't get posts :("
            _stop = false

            view.analysisService = analysisService

            _init = ->
              view.posts = []
              view.paredPosts = []
              view.blog = {}
              delete view.avatarUrl
              view.showTopPosts = true
              _stop = false
              view.displayPostLimit = _POST_LIMIT_INIT
              view.loadingPosts = false

            view.countOriginalPosts = ->
              count = 0
              for post in view.posts when analysisService.isOriginalPost post
                count += 1
              return count

            view.analyzeOnEnter = (event) ->
              if event.keyCode is 13
                view.startAnalysis()

            view.startAnalysis = ->
              _init()
              view.loadingPosts = true
              view.blogName = _cleanBlogName view.blogName
              tumblrService.getBlog(view.blogName)
              .then (blog) ->
                unless blog?
                  _showErrorMessage _BLOG_NOT_FOUND_MSG
                  view.loadingPosts = false
                  return
                view.blog = blog
                _getAvatar()
                _getPosts()
              , ->
                _showErrorMessage _BLOG_NOT_FOUND_MSG

            view.stopAnalysis = ->
              _stop = true
              view.loadingPosts = false

            _cleanBlogName = (blogName) ->
              if blogName.indexOf('.') is -1
                blogName = blogName + '.tumblr.com'
              blogName.replace(/\//g, '').replace(/^http[s]?/g, '').replace(/:/g, '')

            _processNotes = (notes) ->
              unless notes?
                return [ 0, 0 ]
              reblogCount = 0
              likeCount = 0
              for note in notes
                if note.type is 'reblog'
                  reblogCount += 1
                else if note.type is 'like'
                  likeCount += 1
              return [ reblogCount, likeCount ]

            _trustPostHtmlProperties = (post) ->
                post.body = $sce.trustAsHtml post.body
                post.caption = $sce.trustAsHtml post.caption
                post.photos?.caption = $sce.trustAsHtml post.photos.caption
                # For audio/video posts, the player/player.embed_code property is HTML
                # for an iframe with fixed sizes. This is janky, but it looks better
                # than the canned width.
                if post.player instanceof Array and
                  (typeof post.player[1].embed_code is 'string' or
                    post.player[1].embed_code instanceof String)
                  post.player[1].embed_code = $sce.trustAsHtml post.player[1].embed_code.replace(/width="\d+"/, "width=\"100%\"")
                else if post.player? and
                  (typeof post.player is 'string' or
                    post.player instanceof String)
                  post.player = $sce.trustAsHtml post.player.replace(/width="\d+"/, "width=\"100%\"").replace(/height="\d+"/, "height=\"30%\"")
                post.answer = $sce.trustAsHtml post.answer
                post.source = $sce.trustAsHtml post.source

            _processPosts = (posts) ->
              for post in posts
                _trustPostHtmlProperties post
                post.note_count ?= 0

                view.posts.push post
                original = analysisService.isOriginalPost post
                if original
                  [ reblogCount, likeCount ] = _processNotes post.notes

                paredPost =
                  id: post.id
                  date: post.date
                  timestamp: post.timestamp
                  original: original
                  url: post.post_url
                  type: post.type
                  tags: post.tags
                  noteCount: post.note_count

                if paredPost.original
                  paredPost.reblogCount = reblogCount
                  paredPost.likeCount = likeCount

                view.paredPosts.push paredPost

            _getPosts = (batchNum = 0) ->
              tumblrService.getPosts(view.blogName, batchNum)
              .then (posts) ->
                errorMessage = if batchNum is 0\
                  then _BLOG_NOT_FOUND_MSG\
                  else _POST_RETRIEVAL_ERR_MSG
                if not posts?
                  view.loadingPosts = false
                  _showErrorMessage errorMessage

                  return
                if posts.length > 0 and not _stop
                  _processPosts posts
                  _getPosts batchNum += 1
                else
                  view.loadingPosts = false
              , ->
                _showErrorMessage _POST_RETRIEVAL_ERR_MSG

            _getAvatar = ->
              tumblrService.getAvatarUrl(view.blogName)
              .then (url) ->
                view.avatarUrl = url

            _showErrorMessage = (message) ->
              $mdToast.show(
                $mdToast.simple()
                  .content(message)
                  .position('top right')
                  .hideDelay(3000)
              )

            _init()
            return view

      return directive

  angular
      .module('tumblrTopApp')
      .directive('mainDirective', mainDirective)
)()
