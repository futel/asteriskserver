var info_mod = require('../info');
var dbFileName = 'test/metrics.db'

var info = new info_mod.Info();

info.recentBad(
    dbFileName,
    function(result) {
        result.map(function (line) { console.log(line); });
    });

info.latest(
    dbFileName,
    null,
    function(result) {
        result.map(function (line) { console.log(line); });
    });

info.stats(
    dbFileName,
    null,
    null,
    function(result) {
        result.map(function (line) { console.log(line); });
    });
