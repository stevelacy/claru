var path = require('path');
var gith = require('gith');
var exec = require('child_process').exec;


var options = {
  port:  6001,
  user:  'stevelacy',   // github username
  repo:  'claru',       // github reponame
  cwd:   path.resolve(__dirname, '..'),
  start: 'pm2 restart 1',   // or node server.js, etc
  install: 'npm install'
};


// TODO: Add logger

var log = console.log;

var startServer = function(cmd, cb) {
  exec(cmd, function(err, stdout, stderr) {
    log(err, stdout);
    return cb(err, stdout);
  });
};

var npmInstall = function(cmd, cb) {
  exec(cmd, {cwd: options.cwd}, function(err, stdout, stderr) {
    log(err, stdout);
    return cb(err, stdout);
  });
};

log(" Starting git-hook ");
log(" CWD = " + options.cwd);

gith = gith.create(options.port);
gith({
  repo: options.user + '/' + options.repo
}).on('all', function(payload) {

    log('push received - cwd: ' + options.cwd);
    exec('git pull origin ' + payload.branch, {cwd: options.cwd} ,function(err, stdout, stderr) {
      if (err) log(err);
      log(stdout);
      log(stderr);
      log('git deployed to branch ' + payload.branch);

      npmInstall(options.install, function(err, stdout){
        if (err) log(err);
        log("Installing");
        log(stdout);

        startServer(options.start, function(err, stdout) {
          if (err) log(err);
          log("server started");
          log(stdout);
          log(stderr);
        });
      });
    });
});