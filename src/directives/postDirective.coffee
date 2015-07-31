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

            view.iconClasses =
              text: 'fa-file-text'
              photo: 'fa-camera-retro'
              quote: 'fa-quote-left'
              link: 'fa-link'
              chat: 'fa-weixin'
              audio: 'fa-music'
              video: 'fa-film'
              answer: 'fa-question'

            view.formatDate = (date) ->
              # FF requires this replace
              date = date.replace(/-/g,'/')
              moment(new Date(date)).format('MMMM Do, YYYY')

            return view

      return directive

  angular
      .module('tumblrTopApp')
      .directive('post', post)
)()
