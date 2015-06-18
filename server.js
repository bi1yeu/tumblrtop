var connect = require('connect');
var serveStatic = require('serve-static');

var PORT_NUM = process.argv[2];

if (PORT_NUM) {
  connect().use(serveStatic(__dirname + '/dist/')).listen(PORT_NUM);
} else {
  console.log('No port specified; exiting');
  process.exit(1);
}