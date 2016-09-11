var irc = require('irc');
var info_mod = require('./info');
var snspoller = require('./snspoller');

var config = require('./config');
var secrets = require('./secrets');

var defaultStatsDays = 60;

var help = ['available commands:',
            'hi say hello',
            'help get command help',
            'latest [extension [extension...]] get latest events',
            'stats [days [extension]] get event stats',
            'recentbad get recent events'
           ];

var info = new info_mod.Info();

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

bot.noisySay = function(text) {
    console.log(text);    
    try {
        config.config.noisyChannels.forEach(function(channel) {
            bot.say(channel, text);
        });
    }
    catch (e) {
        // XXX not connected yet? Need a connected callback or something.
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

bot.stats = function(from, to, text, message) {
    var words = bot.textToCommands(text);
    var days = words[1];
    try {
        days = days.toString();
    } catch(e) {
        days = defaultStatsDays;
    }
    var extension = words[2];
    try {
        extension = extension.toString();
    } catch(e) {
        extension = null;
    }

    info.stats(
        config.config.dbFileName,
        days,
        extension,
        function(result) {
            result.map(function (line) { bot.sayOrSay(from, to, line); });
        });
};

bot.latest = function(from, to, text, message) {
    var words = bot.textToCommands(text);
    var extensions = words.slice(1);
    if (!extensions.length) {
        extensions = null;
    }
    info.latest(
        config.config.dbFileName,
        extensions,
        function(result) {
            result.map(function (line) { bot.sayOrSay(from, to, line); });
        });
};

bot.recentBad = function(from, to, text, message) {
    info.recentBad(
        config.config.dbFileName,
        function(result) {
            result.map(function (line) { bot.sayOrSay(from, to, line); });
        });
};

bot.errorMessage = function(from, to, text, message) {
    bot.sayOrSay(from, to, 'Use "help" for help.');
};

bot.commands = {
    'hi': bot.hi,
    'help': bot.help,
    'stats': bot.stats,
    'latest': bot.latest,
    'recentbad': bot.recentBad}    

bot.textToCommands = function(text) {
    return text.trim().split(/\s+/);
}

bot.noYoureTalk = function(from, to, text, message) {
    // does message call me anything?
    var findString = bot.nick + " is ";
    var startString = text.indexOf(findString);
    if (startString > -1) {
        text = text.trim();                           // strip whitespace
        text = text.replace(RegExp('[\.\!\?]+$'), '') // strip punct
        var outString = text.replace(RegExp('.*' + findString), '');
        outString = "No, " + from + ", you're " + outString + '!';
        bot.sayOrSay(from, to, outString);
    } else {
        // does message mention me?
        var startString = text.indexOf(bot.nick);
        if (startString > -1) {
            bot.sayOrSay(from, to, "yo");
        }
    }
}

bot.pm = function(nick, text, message) {
    var words = this.textToCommands(text);
    if (words && (words[0] in this.commands)) {    
        var command = this.commands[words[0]];
    } else {
        var command = this.errorMessage;
    }
    command(nick, null, text, message);
};

bot.channel_message = function(from, to, text, message) {
    if (text.indexOf('!') == 0) {
        // respond to commands in channel starting with !        
        text = text.replace('!', '');
        words = this.textToCommands(text);
        if (words && (words[0] in this.commands)) {
            var command = this.commands[words[0]];
            command(from, to, text, message);
        }
    } else if (config.config.noisyChannels.indexOf(message.args[0]) > -1) {
        // respond to talking in noisychannels
        this.noYoureTalk(from, to, text, message);        
    }
};

// respond to commands in pm, or error message
bot.addListener("pm", bot.pm);

// respond to talking in channels
bot.addListener("message#", bot.channel_message);

bot.defaultEventAction = function(body) {
};
bot.confbridgeJoinAction = function(body) {
    bot.noisySay('Voice conference joined');
};
bot.confbridgeLeaveAction = function(body) {
    bot.noisySay('Voice conference left');
};

var pollerEventMap = {
    'ConfbridgeJoin': bot.confbridgeJoinAction,
    'ConfbridgeLeave': bot.confbridgeLeaveAction,
    'defaultEventAction': bot.defaultEventAction,
};

snspoller.poll(
    secrets.config.sqsUrl,
    secrets.config.awsAkey,
    secrets.config.awsSecret,
    config.config.eventHostname,
    pollerEventMap);
