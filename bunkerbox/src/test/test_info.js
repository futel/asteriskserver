var info_mod = require('../info');
var config = require('./config-test');

var info = new info_mod.Info();

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

info.stats(
    config.config.dbFileName,
    null,
    null,
    function(result) {
        result.map(function (line) { console.log(line); });
    });
