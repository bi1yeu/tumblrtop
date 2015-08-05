(->
  analysis = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.analysis.html')
          controllerAs: 'view'
          scope:
            paredPosts: '='
          controller: ($scope, analysisService) ->
            view = @
            view.paredPosts = $scope.paredPosts

            _seriesColors = ['#3F51B5']

            _init = ->
              view.originalPostCount = 0
              view.rebloggedPostCount = 0

            _updateOrigToReblogRatio = ->
              ratio = _.countBy view.paredPosts, (post) ->
                if post.original then 'original' else 'reblogged'
              view.originalPostCount = ratio.original
              view.rebloggedPostCount = ratio.reblogged
              view.percentOriginal = (view.originalPostCount / view.paredPosts.length) * 100

            _updateNotesOverTimeChart = ->
              view.chartConfig =
                options:
                  chart:
                    zoomType: 'x'
                  tooltip:
                    style:
                      padding: 10
                      fontWeight: 'bold'
                series: [
                  data: analysisService.getNotesOverTimeSeriesData view.paredPosts
                  color: _seriesColors[0]
                ]
                legend: false
                title:
                  text: 'Original Post Notes Over Time'
                xAxis:
                  type: 'datetime'
                yAxis:
                  title:
                    text: 'Notes'

            view.updateModels = ->
              _updateOrigToReblogRatio()
              _updateNotesOverTimeChart()

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
