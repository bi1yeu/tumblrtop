(->
  analysis = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.analysis.html')
          controllerAs: 'view'
          scope:
            paredPosts: '='
          controller: ($scope) ->
            view = @
            view.paredPosts = $scope.paredPosts

            _init = ->
              view.originalPostCount = 0
              view.rebloggedPostCount = 0

            _updateOrigToReblogRatio = ->
              ratio = _.countBy view.paredPosts, (post) ->
                if post.original then 'original' else 'reblogged'
              view.originalPostCount = ratio.original
              view.rebloggedPostCount = ratio.reblogged
              view.percentOriginal = (view.originalPostCount / view.paredPosts.length) * 100

            view.updateModels = ->
              _updateOrigToReblogRatio()

            _init()

            return view
          link: (scope, element, attrs, view)->
            scope.$watch 'view.paredPosts', ->
              view.updateModels()
            , true

      return directive

  angular
      .module('tumblrTopApp')
      .directive('analysis', analysis)
)()
