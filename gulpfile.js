var gulp = require('gulp'),
    del = require('del'),
    exec = require('child_process').exec,
    gutil = require('gulp-util'),
    coffee = require('gulp-coffee'),
    concat = require('gulp-concat'),
    ngAnnotate = require('gulp-ng-annotate'),
    templateCache = require('gulp-angular-templatecache');

var PORT_NUM = 3000;

var bowerDir = './bower_components/',
    srcDir = './src/',
    distDir = './dist/',
    coffeeFiles = srcDir + '**/*.coffee',
    htmlFiles = srcDir + 'views/**/*.html',
    jsDir = distDir + 'js/';

gulp.task('clean', function(cb) {
  del(jsDir + '*', cb);
});

gulp.task('html', function () {
    gulp.src(htmlFiles)
        .pipe(templateCache('templates.js',
          {
            module:'templates',
            standalone:true
          }))
        .pipe(gulp.dest(jsDir));
});

gulp.task('build', ['clean', 'html'], function() {
  gulp.src(bowerDir + '**/*.min.js')
    .pipe(gulp.dest(jsDir));
  gulp.src(coffeeFiles)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(ngAnnotate())
    .pipe(concat('app.js'))
    .pipe(gulp.dest(jsDir));
});

gulp.task('serve', function() {
  exec('node server.js ' + PORT_NUM, function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
  })
});

gulp.task('default', ['build', 'serve'], function() {
});
