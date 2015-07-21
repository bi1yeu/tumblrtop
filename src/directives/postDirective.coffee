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
            view.post.prettyDate = moment(view.post.date, 'ISO').format('MMMM Do YYYY, h:mm:ss a')
            return view
          link: (scope, element, attrs, view)->
            view.openPostOnBlog = ->
              console.log view.post
              window.open(view.post.post_url, '_blank')

      return directive

  angular
      .module('tumblrTopApp')
      .directive('post', post)
)()
