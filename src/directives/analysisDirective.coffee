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

            _seriesColors = ['#3F51B5']

            _init = ->
              view.originalPostCount = 0
              view.rebloggedPostCount = 0
              view.chartControls =
                postCountsByTypeInclReblogs: false
                postNotesByTypeInclReblogs: false
                notesOverTimeInclReblogs: false

            _updateOrigToReblogRatio = (posts) ->
              ratio = _(posts).countBy (post) ->
                if post.original then 'original' else 'reblogged'
              view.originalPostCount = ratio.original
              view.rebloggedPostCount = ratio.reblogged
              view.percentOriginal = (view.originalPostCount / posts.length) * 100

            _updateNotesOverTimeChart = (posts) ->
              seriesData = analysisService.getPostsOverTimeSeriesData posts,
                'notes',
                false
              view.notesOverTime =
                options:
                  chart:
                    zoomType: 'x'
                    type: 'line'
                  credits:
                    enabled: false
                  legend:
                    enabled: false
                  tooltip:
                    crosshairs: true
                  plotOptions:
                    series:
                      turboThreshold: 100000
                      cursor: 'pointer'
                      allowPointSelect: true
                      point:
                        events:
                          select: ->
                            $window.open(@.url)
                series: [
                  data: analysisService.getPostsOverTimeSeriesData posts,
                    'notes',
                    not view.chartControls.notesOverTimeInclReblogs
                  color: _seriesColors[0]
                  name: 'Notes'
                  marker:
                    symbol: 'circle'
                ]
                legend: false
                title:
                  text: if view.chartControls.notesOverTimeInclReblogs\
                    then 'Post Notes Over Time'\
                    else 'Original Post Notes Over Time'
                xAxis:
                  type: 'datetime'
                yAxis:
                  title:
                    text: 'Notes'

            _updatePostCountsByTypeChart = (posts) ->
              view.postCountsByType =
                options:
                  chart:
                    type: 'column'
                  credits:
                    enabled: false
                  legend:
                    enabled: false
                series: [
                  data: analysisService.getPostsByTypeSeriesData posts,
                    'posts',
                    not view.chartControls.postCountsByTypeInclReblogs
                  name: 'Count'
                  color: _seriesColors[0]
                ]
                title:
                  text: if view.chartControls.postCountsByTypeInclReblogs\
                    then 'Post Count by Type'\
                    else 'Original Post Count by Type'
                xAxis:
                  type: 'category'
                yAxis:
                  title:
                    text: 'Post Count'

            _updatePostNotesByTypeChart = (posts) ->
              view.postNotesByType =
                options:
                  chart:
                    type: 'column'
                  credits:
                    enabled: false
                  legend:
                    enabled: false
                series: [
                  data: analysisService.getPostsByTypeSeriesData posts,
                    'notes',
                    not view.chartControls.postNotesByTypeInclReblogs
                  name: 'Notes'
                  color: _seriesColors[0]
                ]
                title:
                  text: if view.chartControls.postNotesByTypeInclReblogs\
                    then 'Post Notes by Type'\
                    else 'Original Post Notes by Type'
                xAxis:
                  type: 'category'
                yAxis:
                  title:
                    text: 'Post Notes'

            view.updateModels = ->
              posts = _($scope.posts).sortBy 'timestamp'
              _updateOrigToReblogRatio posts
              _updateNotesOverTimeChart posts
              _updatePostCountsByTypeChart posts
              _updatePostNotesByTypeChart posts

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
