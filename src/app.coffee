angular.module 'tumblrTopApp', ['templates', 'ngMaterial', 'highcharts-ng']
.config ($mdThemingProvider) ->
  $mdThemingProvider.theme 'default'
    .primaryPalette 'teal'
