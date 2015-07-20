(->
  mainDirective = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.main.html')
          controllerAs: 'view'
          controller: ($sce, analysisService, tumblrService) ->
            view = @
            view.POST_LIMIT_INCR = 3
            _stop = false

            view.analysisService = analysisService


            _init = ->
              view.posts = []
              view.paredPosts = []
              view.blog = {}
              view.showTopPosts = true
              _stop = false
              view.displayPostLimit = 3
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
