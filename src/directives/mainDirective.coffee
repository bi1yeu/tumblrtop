angular.module('tumblrTopApp').directive 'mainDirective',
  ($templateCache) ->
    restrict: 'E'
    replace: true
    template: $templateCache.get('directive.main.html')
    controllerAs: 'view'
    controller: () ->
      view = @
      view.model = 'hi'
      console.log view.model
    link: () ->
      console.log 'hey!'