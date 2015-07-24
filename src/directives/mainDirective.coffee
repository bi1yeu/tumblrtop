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
            _stop = false

            view.analysisService = analysisService

            _init = ->
              view.posts = []
              view.paredPosts = []
              view.blog = {}
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
              if view.blogName.indexOf('.') is -1
                view.blogName = view.blogName + '.tumblr.com'
              tumblrService.getBlog(view.blogName)
              .then (blog) ->
                view.blog = blog

              _getPosts()

            view.stopAnalysis = ->
              _stop = true
              view.loadingPosts = false

            view.countType = (type, originalOnly = false) ->
              analysisService.countPostsOfType view.paredPosts, type, originalOnly

            view.countNoteType = (type) ->
              analysisService.countNotesOfType view.paredPosts, type

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

            _processPosts = (posts) ->
              for post in posts
                post.body = $sce.trustAsHtml post.body
                post.caption = $sce.trustAsHtml post.caption
                post.photos?.caption = $sce.trustAsHtml post.photos.caption
                # For video posts, the embed_code property is HTML for an iframe with fixed
                # sizes. This is janky, but it looks better than the canned width.
                if post.player instanceof Array
                  post.player[1].embed_code = $sce.trustAsHtml post.player[1].embed_code.replace(/width="\d+"/, "width=\"100%\"")
                else if post.player?
                  post.player = $sce.trustAsHtml post.player.replace(/width="\d+"/, "width=\"100%\"").replace(/height="\d+"/, "height=\"30%\"")
                post.answer = $sce.trustAsHtml post.answer
                post.source = $sce.trustAsHtml post.source
                post.note_count ?= 0

                view.posts.push post
                original = analysisService.isOriginalPost post
                if original
                  [ reblogCount, likeCount ] = _processNotes post.notes

                paredPost =
                  id: post.id
                  date: post.date
                  original: original
                  type: post.type
                  tags: post.tags

                if paredPost.original
                    paredPost.noteCount = post.note_count
                    paredPost.reblogCount = reblogCount
                    paredPost.likeCount = likeCount

                view.paredPosts.push paredPost

            _getPosts = (batchNum = 0) ->
              tumblrService.getPosts(view.blogName, batchNum)
              .then (posts) ->
                if not posts?
                  view.loadingPosts = false
                  $mdToast.show(
                    $mdToast.simple()
                      .content("Couldn't find that blog, sorry!")
                      .position("top right")
                      .hideDelay(3000)
                  );

                  return
                console.log "got #{posts.length} posts"
                if posts.length > 0 and not _stop
                  _processPosts posts
                  _getPosts batchNum += 1
                else
                  view.loadingPosts = false

            _init()
            return view
          link: (scope, element, attrs)->
            console.log 'hey'

      return directive

  angular
      .module('tumblrTopApp')
      .directive('mainDirective', mainDirective)
)()
