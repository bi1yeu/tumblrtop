var gulp = require('gulp');
var exec = require('child_process').exec;
var bowerDir = './bower_components/';
var publicDir = './dist/public/';
var jsDir = 'js/';

gulp.task('build', function() {
   gulp.src(bowerDir + '**/*.js')
   .pipe(gulp.dest(publicDir + jsDir));
});

gulp.task('serve', function() {
  exec('node server.js', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
  })
});

gulp.task('default', ['build', 'serve'], function() {
});
