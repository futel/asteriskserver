var info_mod = require('./info');
var info = new info_mod.Info();

var config = require('./config-test');

info.recentBad(
    config.config.dbFileName,
    function(result) {
        result.map(function (line) { console.log(line); });
    });

info.latest(
    config.config.dbFileName,
    null,
    function(result) {
        result.map(function (line) { console.log(line); });
    });
