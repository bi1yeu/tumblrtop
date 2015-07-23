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
            view.post.prettyDate = moment(new Date(view.post.date)).format('MMMM Do, YYYY')
            view.iconClasses =
              text: 'fa-file-text'
              photo: 'fa-camera-retro'
              quote: 'fa-quote-left'
              link: 'fa-link'
              chat: 'fa-weixin'
              audio: 'fa-music'
              video: 'fa-film'
              answer: 'fa-question'


            return view
          link: (scope, element, attrs, view)->
            console.log 'hi'

      return directive

  angular
      .module('tumblrTopApp')
      .directive('post', post)
)()
