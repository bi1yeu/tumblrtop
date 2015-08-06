(->
  analysis = ($templateCache)->

      directive =
          restrict: 'E'
          replace: true
          template: $templateCache.get('directive.analysis.html')
          controllerAs: 'view'
          scope:
            paredPosts: '='
          controller: ($window, $scope, analysisService) ->
            view = @
            view.paredPosts = $scope.paredPosts

            _seriesColors = ['#3F51B5']

            _init = ->
              view.originalPostCount = 0
              view.rebloggedPostCount = 0
              view.chartControls =
                postCountsByTypeInclReblogs: false
                notesOverTimeInclReblogs: false

            _updateOrigToReblogRatio = (posts) ->
              ratio = _.countBy posts, (post) ->
                if post.original then 'original' else 'reblogged'
              view.originalPostCount = ratio.original
              view.rebloggedPostCount = ratio.reblogged
              view.percentOriginal = (view.originalPostCount / posts.length) * 100

            _updateNotesOverTimeChart = (posts) ->
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
                    style:
                      padding: 10
                    formatter: ->
                      formattedDate = moment.unix(+@.x/1000).format('YYYY-MM-DD')
                      formattedType = @.point.type[0].toUpperCase() + @.point.type.slice(1)
                      "<b>Date</b>: #{formattedDate}<br />
                      <b>Notes</b>: #{@.y}<br />
                      <b>Type</b>: #{formattedType}"
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
                  data: analysisService.getNotesOverTimeSeriesData posts, not view.chartControls.notesOverTimeInclReblogs
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
                  data: analysisService.getPostTypeSeriesData posts, not view.chartControls.postCountsByTypeInclReblogs
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

            view.updateModels = ->
              posts = _.sortBy view.paredPosts, (post) ->
                post.timestamp
              _updateOrigToReblogRatio(posts)
              _updateNotesOverTimeChart(posts)
              _updatePostCountsByTypeChart(posts)

            _init()

            return view
          link: (scope, element, attrs, view)->
            scope.$watch 'view.paredPosts', ->
              view.updateModels()
            , true

            scope.$watch 'view.chartControls', ->
              view.updateModels()
            , true

      return directive

  angular
      .module('tumblrTopApp')
      .directive('analysis', analysis)
)()
