(->
  post = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.post.html')
          controllerAs: 'view'
          scope:
            post: '='
          controller: ($scope) ->
            view = @
            view.post = $scope.post
            view.post.prettyDate = moment(view.post.date, 'ISO').format('MMMM Do YYYY')
            return view
          link: (scope, element, attrs, view)->
            console.log 'hi'

      return directive

  angular
      .module('tumblrTopApp')
      .directive('post', post)
)()
