var default_events_ignore = [
    'outgoing-by-extension',
    'default-incoming'];
var default_max_events = 15;
var default_days = 30;

var frequent_events = function(
    db, events_ignore, max_events, days, extension, callback) {
    if (events_ignore === null) {
        events_ignore = default_events_ignore;
    }
    if (max_events === null) {
        max_events = default_max_events;
    }
    if (days === null) {
        days = default_days;
    }
    if (extension !== null) {
        channel_clause = " AND channel_extension = ?";
    } else {
        channel_clause = null;
    }

    // format arguments
    days = '-' + days.toString() + ' day';

    // construct appropriate length param sequence literal
    var events_ignore_sub = events_ignore.map(function (x) {return "?"});
    events_ignore_sub = events_ignore_sub.join();
    events_ignore_sub = '(' + events_ignore_sub + ')';
    // construct parameterized statement
    var statement = "SELECT name, COUNT(name) AS count FROM metrics WHERE timestamp > date('now', ?) AND name NOT IN " + events_ignore_sub;
    if (extension !== null) {
        statement = statement + channel_clause;
    }
    statement = statement + " GROUP BY name ORDER BY COUNT(name) DESC LIMIT ?";

    var params = [];
    params.push(days);
    params.push.apply(params, events_ignore);
    if (extension !== null) {
        params.push(extension);
    }
    params.push(max_events);

    db.all(statement, params, function(err, rows) {
        callback(rows);
    });
};

Q = require('q');

var nbind = function(obj, method) { return Q.nbind(method, obj) };
var db_all = function(dbconn) { return nbind(dbconn, dbconn.all); };
var get_promise = function(value) {
    return Q.fcall(function() { return value; }) };

var all_extensions = function(dbconn) {
    return Q.fcall(
        db_all(dbconn),
        "SELECT DISTINCT(channel_extension) FROM metrics",
        [])
        .then(function(rows) {
            return rows.map(function(row) { return row.channel_extension; })});
}

var latest_extension_event = function(dbconn, extension) {
    return Q.fcall(
        db_all(dbconn),
        "SELECT channel_extension, name, timestamp FROM metrics WHERE channel_extension=? ORDER BY timestamp DESC LIMIT 1",
        [extension])
};

var latest_events = function(db, extensions, callback) {
    if (extensions !== null) {
        var get_extensions = get_promise(extensions);
    } else {
        var get_extensions = all_extensions(db);
    }

    get_extensions
    .then(function(extensions) {
        return Q.all(
            extensions.map(
                function(extension) {
                    return latest_extension_event(db, extension); }));
    }).then(function(rows) {
        callback(rows);
    })
    .fail(function(err) {
        console.log('fail');
        console.log(err);
    })
}

module.exports = {
    frequent_events: frequent_events,
    latest_events: latest_events
};
