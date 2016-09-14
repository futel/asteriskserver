var irc = require('irc');
var info_mod = require('./info');
var snspoller = require('./snspoller');
var util = require('util');

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

function Bot(server, nick, opt) {
    irc.Client.call(this, server, nick, opt);
    // respond to commands in pm
    this.addListener("pm", this.pm);
    // respond to talking in channels
    this.addListener("message#", this.channel_message);
}

util.inherits(Bot, irc.Client);

Bot.prototype.sayOrSay = function(from, to, text) {
    console.log(text);
    if (to === null) {
        // pm
        this.say(from, text);
    } else {
        // channel command
        this.say(to, text);
    }
};

Bot.prototype.noisySay = function(text) {
    console.log(text);    
    try {
        config.config.noisyChannels.forEach(function(channel) {
            this.say(channel, text);
        });
    }
    catch (e) {
        // XXX not connected yet? Need a connected callback or something.
    }
};

Bot.prototype.hi = function(self, from, to, text, message) {
    self.sayOrSay(from, to, 'Hi ' + from + '!');    
};

Bot.prototype.help = function(self, from, to, text, message) {
    // should probably only PM back
    for (var line in help) {
        self.sayOrSay(from, to, help[line]);
    }
};

Bot.prototype.textToCommands = function(text) {
    return text.trim().split(/\s+/);
};

Bot.prototype.stats = function(self, from, to, text, message) {
    var words = self.textToCommands(text);
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
            result.map(function (line) { self.sayOrSay(from, to, line); });
        });
};
    
Bot.prototype.latest = function(self, from, to, text, message) {
    var words = self.textToCommands(text);
    var extensions = words.slice(1);
    if (!extensions.length) {
        extensions = null;
    }
    info.latest(
        config.config.dbFileName,
        extensions,
        function(result) {
            result.map(function (line) { self.sayOrSay(from, to, line); });
        });
};

Bot.prototype.recentBad = function(self, from, to, text, message) {
    info.recentBad(
        config.config.dbFileName,
        function(result) {
            result.map(function (line) { self.sayOrSay(from, to, line); });
        });
};
   
Bot.prototype.errorMessage = function(self, from, to, text, message) {
    self.sayOrSay(from, to, 'Use "help" for help.');
};

Bot.prototype.noYoureTalk = function(from, to, text, message) {
    // does message call me anything?
    var findString = this.nick + " is ";
    var startString = text.indexOf(findString);
    if (startString > -1) {
        text = text.trim();                           // strip whitespace
        text = text.replace(RegExp('[\.\!\?]+$'), '') // strip punct
        var outString = text.replace(RegExp('.*' + findString), '');
        outString = "No, " + from + ", you're " + outString + '!';
        this.sayOrSay(from, to, outString);
    } else {
        // does message mention me?
        var startString = text.indexOf(this.nick);
        if (startString > -1) {
            this.sayOrSay(from, to, "yo");
        }
    }
};

Bot.prototype.wordToCommand = function(word) {
    var commands = {
        'hi': this.hi,
        'help': this.help,
        'stats': this.stats,
        'latest': this.latest,
        'recentbad': this.recentBad
    };
    if (word in commands) {
        return commands[word];
    }
    return this.errorMessage;
};

Bot.prototype.pm = function(nick, text, message) {
    var words = this.textToCommands(text);
    if (words) {
        var command = this.wordToCommand(words[0]);
        command(this, nick, null, text, message);
    }
};

Bot.prototype.channel_message = function(from, to, text, message) {
    if (text.indexOf('!') == 0) {
        // respond to commands in channel starting with !        
        text = text.replace('!', '');
        var words = this.textToCommands(text);
        if (words) {
            var command = this.wordToCommand(words[0]);
            command(this, from, to, text, message);
        }
    } else if (config.config.noisyChannels.indexOf(message.args[0]) > -1) {
        // respond to talking in noisychannels
        this.noYoureTalk(from, to, text, message);        
    }
};

var client = new Bot(config.config.server, config.config.botName, {
    channels: config.config.channels,
    userName: config.config.userName,
    realName: config.config.realName
});

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
