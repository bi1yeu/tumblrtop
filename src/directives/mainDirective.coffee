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

            view.analysisService = analysisService

            _init = ->
              view.posts = []
              view.paredPosts = []
              view.blog = {}
              view.showTopPosts = true
              view.debugStop = false
              view.displayPostLimit = 3

            view.countOriginalPosts = ->
              count = 0
              for post in view.posts when analysisService.isOriginalPost post
                count += 1
              return count

            view.startAnalysis = ->
              _init()
              tumblrService.getBlog(view.blogName)
              .then (blog) ->
                view.blog = blog

              _getPosts()

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
