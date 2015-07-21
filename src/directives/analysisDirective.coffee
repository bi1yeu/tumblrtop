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
            return view
          link: (scope, element, attrs)->
            console.log 'hey analysis'

      return directive

  angular
      .module('tumblrTopApp')
      .directive('analysis', analysis)
)()
