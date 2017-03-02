var Q = require('q');
var sqlite3 = require('sqlite3'); //.verbose();

var nbind = function(obj, method) { return Q.nbind(method, obj) };
var db_all = function(dbconn) { return nbind(dbconn, dbconn.all); };
var get_promise = function(value) {
    return Q.fcall(function() { return value; }) };

var default_events_ignore = [
    'outgoing-by-extension',
    'default-incoming',
    'outgoing-dialstatus-ANSWER',
    'outgoing-dialstatus-BUSY'];
var default_max_events = 50;
var defaultFrequentDays = 30;
var defaultRecentDays = 7;

var badEvents = [
    "incoming-dialstatus-CHANUNAVAIL",
    "outgoing-dialstatus-CONGESTION"]

var frequent_events = function(
    dbFileName, events_ignore, max_events, days, extension, callback) {
    if (events_ignore === null) {
        events_ignore = default_events_ignore;
    }
    if (max_events === null) {
        max_events = default_max_events;
    }
    if (days === null) {
        days = defaultFrequentDays;
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

    var db = new sqlite3.Database(dbFileName);
    Q.fcall(db_all(db), statement, params)
        .then(function(rows) {
            db.close();            
            return rows;
        }).then(function(rows) {
            callback(rows);
        })
        .fail(function(err) { console.log(err) })
}

var all_extensions = function(dbconn) {
    return Q.fcall(
        db_all(dbconn),
        "SELECT DISTINCT(channel_extension) FROM metrics",
        [])
        .then(function(rows) {
            return rows.map(function(row) { return row.channel_extension; })});
}

var get_latest_events = function(dbconn, extension, events, limit) {
    query = "SELECT channel_extension, name, timestamp FROM metrics";
    params = [];
    if (extension !== null) {
        query = query + " WHERE channel_extension=?";
        params.push(extension);
    }
    if (events !== null) {
        var eventsSub = events.map(function (x) {return "?"});
        eventsSub = eventsSub.join();
        eventsSub = '(' + eventsSub + ')';
        // XXX assums no extension clause, get a smarter join
        query = query + " WHERE name IN " + eventsSub;
        params.push.apply(params, events);        
    }
    
    query = query + " ORDER BY timestamp DESC LIMIT ?";
    params.push(limit);
    return Q.fcall(db_all(dbconn), query, params)
};

var latest_events = function(dbFileName, extension, callback) {
    var db = new sqlite3.Database(dbFileName);
    if (extension !== null) {
        var get_extensions = get_promise([extension]);
    } else {
        var get_extensions = all_extensions(db);
    }

    get_extensions
    .then(function(extensions) {
        return Q.all(
            extensions.map(
                function(extension) {
                    return get_latest_events(db, extension, null, 1); }));
    }).then(function(rows) {
        db.close();
        return rows;
    }).then(function(rows) {
        rows = rows.map(function(r) { return r.pop(); });
        var compare = function(a, b) {
            if (a.timestamp < b.timestamp) {
                return -1;
            } else if (a.timestamp > b.timestamp) {
                return 1;
            } else {
                return 0;
            }
        };
        rows.sort(compare);
        rows.reverse();
        callback(rows);
    })
    .fail(function(err) {
        console.log(err);
    })
}

var recentEvents = function(
        dbFileName, maxEvents, maxDays, events, callback) {
    var db = new sqlite3.Database(dbFileName);
    if (maxEvents === null) {
        maxEvents = default_max_events;
    }
    if (maxDays === null) {
        maxDays = defaultRecentDays;
    }
    if (events === null) {
        events = badEvents;
    }

    get_latest_events(db, null, events, maxEvents)
    .then(function(rows) {
        db.close();
        return rows;
    }).then(function(rows) {
        callback(rows);
    })
    .fail(function(err) {
        console.log(err);
    })
}

module.exports = {
    frequent_events: frequent_events,
    latest_events: latest_events,
    recentEvents: recentEvents
};
