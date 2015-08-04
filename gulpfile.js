var gulp = require('gulp'),
    del = require('del'),
    exec = require('child_process').exec,
    plumber = require('gulp-plumber'),
    coffee = require('gulp-coffee'),
    concat = require('gulp-concat'),
    ngAnnotate = require('gulp-ng-annotate'),
    templateCache = require('gulp-angular-templatecache'),
    shell = require('gulp-shell'),
    karma = require('karma').server;

var PORT_NUM = 3000;

var bowerDir = './bower_components/',
    srcDir = './src/',
    distDir = './dist/',
    coffeeFiles = [srcDir + '**/*.coffee', srcDir + '*.coffee'],
    testFiles = ['spec/*.coffee'],
    htmlFiles = srcDir + 'views/**/*.html',
    jsDir = distDir + 'js/',
    stylesDir = distDir + 'styles/';

gulp.task('unset-key', shell.task([
  "sed -i '' \"s/API_KEY = '.*'/API_KEY = '<consumer-key>'/g\" */**/tumblrService.coffee"
]));

gulp.task('clean', ['unset-key'], function(cb) {
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

// This gets the consumer key env var and just writes it to the source
// A corresponding pre-commit hook should remove it
gulp.task('set-key', shell.task([
  "sed -i '' \"s/API_KEY = '<consumer-key>'/API_KEY = '$TUMBLR_CONSUMER_KEY'/g\" */**/tumblrService.coffee"
]));

gulp.task('coffee', function() {
  gulp.src(coffeeFiles)
      .pipe(plumber())
      .pipe(coffee({bare: true}))
      .pipe(concat('app.js'))
      .pipe(ngAnnotate())
      .pipe(gulp.dest(jsDir));
})

gulp.task('build', ['clean', 'set-key', 'coffee', 'html'], function() {
  gulp.src([bowerDir + '**/*.min.js', bowerDir + '**/*-min.js'])
    .pipe(gulp.dest(jsDir));

  gulp.src(bowerDir + '**/*.min.css')
    .pipe(gulp.dest(stylesDir));
});

gulp.task('watch', function () {
  watcher = gulp.watch([coffeeFiles, htmlFiles], ['coffee', 'html']);
});

gulp.task('test', function (done) {
  karma.start({
    configFile: __dirname + '/karma.conf.js',
  }, function() {
    done();
  });
});

gulp.task('serve', function() {
  exec('node server.js ' + PORT_NUM, function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
  })
});

gulp.task('default', ['build', 'serve'], function() {
});
