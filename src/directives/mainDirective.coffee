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
              .success (data) ->
                view.posts = data.response.posts
                console.log view.posts
              .error (data) ->
                console.log JSON.stringify(data, null, 2)
            return view
          link: (scope, element, attrs)->
            console.log 'hey'

      return directive

  angular
      .module('tumblrTopApp')
      .directive('mainDirective', mainDirective)
)()