var irc = require('irc');
var metrics_util = require('./metrics_util');

var config = require('./config');

var dbFileName = '/opt/futel/stats/prod/metrics.db';

var help = ['available commands:',
            'hi say hello',
            'help get command help',
            'stats [days [extension]] get call stats',
            'latest [extension [extension...]] get latest events'
           ];

var bot = new irc.Client(config.config.server, config.config.botName, {
    channels: config.config.channels,
    userName: config.config.userName,
    realName: config.config.realName
});

bot.sayOrSay = function(from, to, text) {
    console.log(text);
    if (to === null) {
        // pm
        bot.say(from, text);
    } else {
        // channel command
        bot.say(to, text);
    }
}

bot.hi = function(from, to, text, message) {
    console.log('hi');
    console.log(from);
    console.log(to);
    bot.sayOrSay(from, to, 'Hi ' + from + '!');    
};

bot.help = function(from, to, text, message) {
    // should probably only PM back
    for (var line in help) {
        bot.sayOrSay(from, to, help[line]);
    }
};

bot.reportStats = function(from, to, days, rows) {
    rows = rows.map(function (row) { return row.name + ":" + row.count; });
    bot.sayOrSay(from, to, 'most frequent events last ' + days + ' days');
    bot.sayOrSay(from, to, rows.join(' '));    
};

bot.stats = function(from, to, text, message) {
    var words = bot.textToCommands(text);
    var days = words[1];
    try {
        days = days.toString();
    } catch(e) {
        days = null;
    }
    var extension = words[2];
    try {
        extension = extension.toString();
    } catch(e) {
        extension = null;
    }

    metrics_util.frequent_events(dbFileName, null, null, days, extension, function(result) { bot.reportStats(from, to, days, result); });
};

bot.reportLatest = function(from, to, results) {
    results = results.map(function (result) {
        return result.channel_extension + ":" + result.timestamp + " " + result.name; });
    bot.sayOrSay(from, to, "latest channel events");
    bot.sayOrSay(from, to, results.join('\n'));    
};

bot.latest = function(from, to, text, message) {
    var words = bot.textToCommands(text);
    var extensions = words.slice(1);
    if (!extensions.length) {
        extensions = null;
    }
    metrics_util.latest_events(
        dbFileName,
        extensions,
        function(result) { bot.reportLatest(from, to, result); });
};

bot.errorMessage = function(from, to, text, message) {
    bot.sayOrSay(from, to, 'Use "help" for help.');
};

bot.commands = {
    'hi': bot.hi,
    'help': bot.help,
    'stats': bot.stats,
    'latest': bot.latest}

bot.textToCommands = function(text) {
    return text.trim().split(/\s+/);
}

// respond to commands in pm, or error message
bot.addListener("pm", function(nick, text, message) {
    var words = bot.textToCommands(text);
    if (words && (words[0] in bot.commands)) {    
        var command = bot.commands[words[0]];
    } else {
        var command = bot.errorMessage;
    }
    command(nick, null, text, message);
});

// respond to commands in channel starting with !, or ignore
bot.addListener("message#", function(from, to, text, message) {
    if (text.indexOf('!') == 0) {
        text = text.replace('!', '');
        words = bot.textToCommands(text);
        if (words && (words[0] in bot.commands)) {
            var command = bot.commands[words[0]];
            command(from, to, text, message);
        }
    }
});
