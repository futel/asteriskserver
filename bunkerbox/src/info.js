/* object to emit useful lines of text */

var metrics_util = require('./metrics_util');

function Info() {
    var self = this;
}

Info.prototype.reportStats = function(days, rows) {
    rows = rows.map(function (row) { return row.name + ":" + row.count; });
    out = [];
    out.push('most frequent events last ' + days + ' days');
    out.push(rows.join(' '));
    return out;
}

Info.prototype.stats = function(dbFileName, days, extension, callback) {
    var self = this;
    metrics_util.frequent_events(
        dbFileName,
        null,
        null,
        days,
        extension,
        function(result) {
            callback(self.reportStats(days, result));
        });
}

Info.prototype.metricToString = function(metric) {
    formatTimestamp = function(dateString) {
        d = new Date(dateString);
        return d.toLocaleString().slice(4,10) + " " + d.toLocaleString().slice(16,24);
    }
    return metric.channel_extension + " " + formatTimestamp(metric.timestamp) + " " + metric.name;
}

Info.prototype.reportLatest = function(results) {
    var self = this;    
    results = results.map(function (result) {
        return self.metricToString(result);
    });
    out = [];
    out.push("latest channel events");
    out.push(results.join('\n'));
    return out;
};

Info.prototype.latest = function(dbFileName, extensions, callback) {
    var self = this;
    metrics_util.latest_events(
        dbFileName,
        extensions,
        function(results) {
            callback(self.reportLatest(results));
        });
};

Info.prototype.reportRecentBad = function(results) {
    var self = this;    
    results = results.map(function (result) {
        return self.metricToString(result);
    });
    out = [];
    out.push("recent bad events");
    out.push(results.join('\n'));
    return out;
};

Info.prototype.recentBad = function(dbFileName, callback) {
    var self = this;
    metrics_util.recentEvents(
        dbFileName,
        null,
        null,
        null,
        function(results) {
            callback(self.reportRecentBad(results));
        });
};

module.exports = {
    Info: Info
};
