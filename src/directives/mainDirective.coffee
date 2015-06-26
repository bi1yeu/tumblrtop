(->
  mainDirective = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.main.html')
          controllerAs: 'view'
          controller: (tumblrService) ->
            view = @
            view.posts = []
            view.getPosts = () ->
              tumblrService.getPosts(view.blogName)
              .then (posts) ->
                view.posts = posts
                console.log view.posts

            return view
          link: (scope, element, attrs)->
            console.log 'hey'

      return directive

  angular
      .module('tumblrTopApp')
      .directive('mainDirective', mainDirective)
)()