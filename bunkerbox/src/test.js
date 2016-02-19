// npm install node-sqlite3 sqlite3
var sqlite3 = require('sqlite3'); //.verbose();
var metrics_util = require('./metrics_util');

var db = new sqlite3.Database('/tmp/metrics.db');

metrics_util.frequent_events(db, null, null, null, '668', function(result) { console.log(result); });

metrics_util.latest_events(db, null, function(rows) { console.log(rows); });
