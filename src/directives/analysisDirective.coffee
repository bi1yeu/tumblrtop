(->
  analysis = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.analysis.html')
          controllerAs: 'view'
          scope:
            posts: '='
          controller: ($window, $scope, analysisService) ->
            view = @

            Highcharts.setOptions lang: thousandsSep: ','

            _seriesColors = ['#4DB6AC']

            _boilerplateChart =
              options:
                chart:
                  type: 'column'
                credits:
                  enabled: false
                legend:
                  enabled: false
              series: [
                color: _seriesColors[0]
              ]
              title:
                text: 'Chart'
              yAxis:
                title:
                  text: 'Count'

            _init = ->
              view.originalPostCount = 0
              view.rebloggedPostCount = 0
              view.chartControls =
                notesOverTimeInclReblogs: false
                postNotesByTypeInclReblogs: false
                postCountsByTypeInclReblogs: false
                postNotesByTagInclReblogs: false
                postNotesByTagInclReblogs: false

            _updateOrigToReblogRatio = (posts) ->
              ratio = _(posts).countBy (post) ->
                if post.original then 'original' else 'reblogged'
              view.originalPostCount = ratio.original
              view.rebloggedPostCount = ratio.reblogged
              view.percentOriginal =
                (view.originalPostCount / posts.length) * 100

            _updateNotesOverTimeChart = (posts) ->
              chart = angular.copy _boilerplateChart
              chart.options.chart = 'line'
              chart.options.chart = zoomType: 'x'
              chart.options.tooltip = crosshairs: true
              chart.options.plotOptions =
                line:
                  lineWidth: 1
                series:
                  turboThreshold: 30000
                  states:
                    hover:
                      enabled: true
                      lineWidth: 2
                  cursor: 'pointer'
                  allowPointSelect: true
                  point:
                    events:
                      select: ->
                        $window.open(@.url)
              chart.series[0].data =
                analysisService.getPostsOverTimeSeriesData posts,
                  'notes',
                  not view.chartControls.notesOverTimeInclReblogs
              chart.series[0].name = 'Notes'
              chart.series[0].marker = symbol: 'circle'
              chart.legend = false
              chart.title.text = if view.chartControls.notesOverTimeInclReblogs\
                then 'Post Notes Over Time'\
                else 'Original Post Notes Over Time'
              chart.xAxis = type: 'datetime'
              chart.yAxis.title.text = 'Notes'
              view.notesOverTime = chart

            _updatePostCountsByTypeChart = (posts) ->
              chart = angular.copy _boilerplateChart
              chart.series[0].data =
                analysisService.getPostsByTypeSeriesData posts,
                  'posts',
                  not view.chartControls.postCountsByTypeInclReblogs
              chart.series[0].name = 'Count'
              chart.title.text =
                if view.chartControls.postCountsByTypeInclReblogs
                  'Post Count by Type'
                else
                 'Original Post Count by Type'
              chart.xAxis = type: 'category'
              chart.yAxis.title.text = 'Post Count'
              view.postCountsByType = chart

            _updatePostNotesByTypeChart = (posts) ->
              chart = angular.copy _boilerplateChart
              chart.series[0].data =
                analysisService.getPostsByTypeSeriesData posts,
                  'notes',
                  not view.chartControls.postNotesByTypeInclReblogs
              chart.series[0].name = 'Notes'
              chart.title.text =
                if view.chartControls.postNotesByTypeInclReblogs
                  'Post Notes by Type'
                else
                  'Original Post Notes by Type'
              chart.xAxis = type: 'category'
              chart.yAxis.title.text = 'Post Notes'
              view.postNotesByType = chart

            _updatePostCountsByTagChart = (posts) ->
              chart = angular.copy _boilerplateChart
              chart.series[0].data =
                analysisService.getPostsByTagSeriesData posts,
                  'posts',
                  not view.chartControls.postCountsByTagInclReblogs
              chart.series[0].name = 'Notes'
              chart.title.text =
                if view.chartControls.postCountsByTypeInclReblogs
                  'Post Count by Tag'
                else
                  'Original Post Count by Tag'
              chart.xAxis = type: 'category'
              chart.yAxis.title.text = 'Post Count'
              view.postCountsByTag = chart

            _updatePostNotesByTagChart = (posts) ->
              chart = angular.copy _boilerplateChart
              chart.series[0].data =
                analysisService.getPostsByTagSeriesData posts,
                  'notes',
                  not view.chartControls.postNotesByTagInclReblogs
              chart.series[0].name = 'Notes'
              chart.title.text =
                if view.chartControls.postNotesByTypeInclReblogs
                  'Post Notes by Tag'
                else
                  'Original Post Notes by Tag'
              chart.xAxis = type: 'category'
              chart.yAxis.title.text = 'Post Notes'
              view.postNotesByTag = chart

            view.updateModels = ->
              posts = _($scope.posts).sortBy 'timestamp'
              _updateOrigToReblogRatio posts
              _updateNotesOverTimeChart posts
              _updatePostCountsByTypeChart posts
              _updatePostNotesByTypeChart posts
              _updatePostCountsByTagChart posts
              _updatePostNotesByTagChart posts

            _init()

            return view
          link: (scope, element, attrs, view)->
            scope.$watchCollection 'posts', ->
              view.updateModels()

            scope.$watch 'view.chartControls', ->
              view.updateModels()
            , true

      return directive

  angular
      .module('tumblrTopApp')
      .directive('analysis', analysis)
)()
