var metrics_util = require('./metrics_util');

var dbFileName = '/tmp/metrics.db';
metrics_util.frequent_events(dbFileName, null, null, null, '668', function(result) { console.log(result); });


metrics_util.latest_events(dbFileName, null, function(rows) { console.log(rows); });
