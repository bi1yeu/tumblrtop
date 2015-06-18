var gulp = require('gulp');
var clean = require('gulp-clean');
var exec = require('child_process').exec;

var PORT_NUM = 3000;

var bowerDir = './bower_components/';
var publicDir = './dist/';
var jsDir = publicDir + 'js/';

gulp.task('clean', function() {
  gulp.src(jsDir + '*', {read: false})
    .pipe(clean());
});

gulp.task('build', function() {
  gulp.src(bowerDir + '**/*.js')
    .pipe(gulp.dest(jsDir));
});

gulp.task('serve', function() {
  exec('node server.js ' + PORT_NUM, function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
  })
});

gulp.task('default', ['clean', 'build', 'serve'], function() {
});
