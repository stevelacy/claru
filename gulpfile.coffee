{spawn} = require 'child_process'

gulp = require 'gulp'

source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
coffeeify = require 'coffeeify'
browserify = require 'browserify'
watchify = require 'watchify'

jade = require 'gulp-jade'
csso = require 'gulp-csso'
cache = require 'gulp-cached'
stylus = require 'gulp-stylus'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
plumber = require 'gulp-plumber'
reload = require 'gulp-livereload'
htmlmin = require 'gulp-minify-html'
replace = require 'gulp-replace'

gutil = require 'gulp-util'
gif = require 'gulp-if'
sourcemaps = require 'gulp-sourcemaps'


nodemon = require 'gulp-nodemon'
nib = require 'nib'
autoprefixer = require 'autoprefixer-stylus'
autowatch = require 'gulp-autowatch'
config = require './server/config'

# paths
paths =
  vendor: './client/vendor/**/*'
  img: './client/img/**/*'
  fonts: './client/fonts/**/*'
  coffee: './client/**/*.coffee'
  bundle: './client/index.coffee'
  stylus: './client/**/*.styl'
  jade: './client/**/*.jade'
  config: './client/config.js'
  public: './public'

gulp.task 'server', (cb) ->
  # total hack to make nodemon + livereload
  # work sanely
  idxPath = './public/index.html'
  reloader = reload()
  nodemon
    script: './server/index.coffee'
    watch: ['./server']
    ext: 'js json coffee'
    ignore: './server/test'
  .once 'start', cb
  .on 'start', ->
    console.log 'Server has started'
    setTimeout ->
      #reloader.write path: idxPath
      console.log ''
    , 1000
  .on 'quit', ->
    console.log 'Server has quit'
  .on 'restart', (files) ->
    console.log 'Server restarted due to:', files

  #return

# javascript
args =
  debug: true
  fullPaths: true
  cache: {}
  packageCache: {}
  extensions: ['.coffee']

bundler = watchify browserify paths.bundle, args
bundler.transform coffeeify

gulp.task 'coffee', ->
  bundler.bundle()
    .once 'error', (err) ->
      console.error err.message
    .pipe source 'index.js'
    .pipe buffer()
    .pipe cache 'js'
    .pipe sourcemaps.init
      loadMaps: true
    .pipe sourcemaps.write '.'
    .pipe gulp.dest './public'
    .pipe gif '*.js', reload()

# styles
gulp.task 'stylus', ->
  gulp.src paths.stylus
    .pipe sourcemaps.init()
    .pipe stylus
      use:[
        nib()
        autoprefixer cascade: true
      ]
      sourcemap:
        inline: true
    .pipe concat 'app.css'
    .pipe sourcemaps.write()
    .pipe gif gutil.env.production, csso()
    .pipe gulp.dest paths.public
    .pipe reload()

gulp.task 'jade', ->
  gulp.src paths.jade
    .pipe jade()
    .pipe cache 'html'
    .pipe gif gutil.env.production, htmlmin()
    .pipe gulp.dest paths.public
    .pipe reload()

gulp.task 'vendor', ->
  gulp.src paths.vendor
    .pipe cache 'vendor'
    .pipe gulp.dest './public/vendor'
    .pipe reload()

gulp.task 'img', ->
  gulp.src paths.img
    .pipe cache 'img'
    .pipe gulp.dest './public/img'
    .pipe reload()

gulp.task 'fonts', ->
  gulp.src paths.fonts
    .pipe cache 'fonts'
    .pipe gulp.dest './public/fonts'
    .pipe reload()

gulp.task 'config', ->
  gulp.src paths.config
    .pipe gif gutil.env.production, (replace /SERVER/g, config.url), replace /SERVER/g, config.url
    .pipe replace /TITLE/g, config.title
    .pipe replace /NAME/g, config.name
    .pipe gulp.dest paths.public

gulp.task 'watch', ->
  autowatch gulp, paths


gulp.task 'phonegap', ->
  gulp.src './public/**/*'
  .pipe gulp.dest './phonegap/www'
  .on 'end', ->
    cmd = spawn 'phonegap', ['run', 'android'], cwd: "#{__dirname}/phonegap/"
    cmd.stdout.on 'data', (data) ->
      console.log String data
    cmd.stderr.on 'data', (data) ->
      console.log String data
      process.exit 1

gulp.task 'css', ['stylus']
gulp.task 'js', ['coffee']
gulp.task 'static', ['jade', 'vendor', 'img', 'fonts']
gulp.task 'default', ['js', 'css', 'static', 'server', 'config', 'watch']
