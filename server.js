var connect = require('connect');
var serveStatic = require('serve-static');
connect().use(serveStatic(__dirname + '/dist/public/')).listen(3000);
