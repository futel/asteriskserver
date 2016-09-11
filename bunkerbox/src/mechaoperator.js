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

var client = new irc.Client(config.config.server, config.config.botName, {
    channels: config.config.channels,
    userName: config.config.userName,
    realName: config.config.realName
});

client.sayOrSay = function(from, to, text) {
    console.log(text);
    if (to === null) {
        // pm
        client.say(from, text);
    } else {
        // channel command
        client.say(to, text);
    }
}

client.noisySay = function(text) {
    console.log(text);    
    try {
        config.config.noisyChannels.forEach(function(channel) {
            client.say(channel, text);
        });
    }
    catch (e) {
        // XXX not connected yet? Need a connected callback or something.
    }
}

client.hi = function(from, to, text, message) {
    console.log('hi');
    console.log(from);
    console.log(to);
    client.sayOrSay(from, to, 'Hi ' + from + '!');    
};

client.help = function(from, to, text, message) {
    // should probably only PM back
    for (var line in help) {
        client.sayOrSay(from, to, help[line]);
    }
};

client.stats = function(from, to, text, message) {
    var words = client.textToCommands(text);
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
            result.map(function (line) { client.sayOrSay(from, to, line); });
        });
};

client.latest = function(from, to, text, message) {
    var words = client.textToCommands(text);
    var extensions = words.slice(1);
    if (!extensions.length) {
        extensions = null;
    }
    info.latest(
        config.config.dbFileName,
        extensions,
        function(result) {
            result.map(function (line) { client.sayOrSay(from, to, line); });
        });
};

client.recentBad = function(from, to, text, message) {
    info.recentBad(
        config.config.dbFileName,
        function(result) {
            result.map(function (line) { client.sayOrSay(from, to, line); });
        });
};

client.errorMessage = function(from, to, text, message) {
    client.sayOrSay(from, to, 'Use "help" for help.');
};

client.commands = {
    'hi': client.hi,
    'help': client.help,
    'stats': client.stats,
    'latest': client.latest,
    'recentbad': client.recentBad}    

client.textToCommands = function(text) {
    return text.trim().split(/\s+/);
}

client.noYoureTalk = function(from, to, text, message) {
    // does message call me anything?
    var findString = client.nick + " is ";
    var startString = text.indexOf(findString);
    if (startString > -1) {
        text = text.trim();                           // strip whitespace
        text = text.replace(RegExp('[\.\!\?]+$'), '') // strip punct
        var outString = text.replace(RegExp('.*' + findString), '');
        outString = "No, " + from + ", you're " + outString + '!';
        client.sayOrSay(from, to, outString);
    } else {
        // does message mention me?
        var startString = text.indexOf(client.nick);
        if (startString > -1) {
            client.sayOrSay(from, to, "yo");
        }
    }
}

client.pm = function(nick, text, message) {
    var words = this.textToCommands(text);
    if (words && (words[0] in this.commands)) {    
        var command = this.commands[words[0]];
    } else {
        var command = this.errorMessage;
    }
    command(nick, null, text, message);
};

client.channel_message = function(from, to, text, message) {
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
client.addListener("pm", client.pm);

// respond to talking in channels
client.addListener("message#", client.channel_message);

client.defaultEventAction = function(body) {
};
client.confbridgeJoinAction = function(body) {
    client.noisySay('Voice conference joined');
};
client.confbridgeLeaveAction = function(body) {
    client.noisySay('Voice conference left');
};

var pollerEventMap = {
    'ConfbridgeJoin': client.confbridgeJoinAction,
    'ConfbridgeLeave': client.confbridgeLeaveAction,
    'defaultEventAction': client.defaultEventAction,
};

snspoller.poll(
    secrets.config.sqsUrl,
    secrets.config.awsAkey,
    secrets.config.awsSecret,
    config.config.eventHostname,
    pollerEventMap);
