var gulp = require('gulp');
var exec = require('child_process').exec;

gulp.task('serve', function() {
  exec('node server.js', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
  })
});

gulp.task('default', ['serve'], function() {
});
