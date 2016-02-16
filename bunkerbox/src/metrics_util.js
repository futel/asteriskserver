var default_events_ignore = [
    'outgoing-by-extension',
    'default-incoming'];
var default_max_events = 15;
var default_days = 30;

// for testing
//var done = function(result) { console.log(result); };

var frequent_events = function(db, events_ignore, max_events, days, extension, callback) {
    if (events_ignore === null) {
        events_ignore = default_events_ignore;
    }
    if (max_events === null) {
        max_events = default_max_events;
    }
    if (days === null) {
        days = default_days;
    }
    if (extension === null) {
        extension = "%%%%";         // magic, this ends up matching everything
    }
    var extension_like = "%%SIP/" + extension + "-%%";

    // format arguments
    days = '-' + days.toString() + ' day';

    // construct appropriate length param sequence literal
    var events_ignore_sub = events_ignore.map(function (x) {return "?"});
    events_ignore_sub = events_ignore_sub.join();
    events_ignore_sub = '(' + events_ignore_sub + ')';
    // construct parameterized statement
    var statement = "SELECT name, COUNT(name) AS count FROM metrics WHERE timestamp > date('now', ?) AND name NOT IN " + events_ignore_sub + " AND channel LIKE ? GROUP BY name ORDER BY COUNT(name) DESC LIMIT ?";

    var params = [];
    params.push(days);
    params.push.apply(params, events_ignore);
    params.push(extension_like);    
    params.push(max_events);

    db.all(statement, params, function(err, rows) {
        callback(rows);
    });
};

module.exports = {
    frequent_events: frequent_events
};
