var irc = require('irc');
var util = require('util');

var info_mod = require('./info');

var info = new info_mod.Info();

var defaultStatsDays = 60;

var sample = function(arr) { return arr[Math.floor(Math.random() * arr.length)]; }

var stringIn = function(str1, str2) { return str2.indexOf(str1) > -1; }

function Client(server, nick, opt, noisyChannels, dbFileName) {
    irc.Client.call(this, server, nick, opt);    
    this.noisyChannels = noisyChannels;
    this.dbFileName = dbFileName;
    // respond to commands in pm
    this.addListener("pm", this.pm);
    // respond to talking in channels
    this.addListener("message#", this.channelMessage);
}

util.inherits(Client, irc.Client);

Client.prototype.sayOrSay = function(from, to, text) {
    if (to === null) {
        // pm
        this.say(from, text);
    } else {
        // channel command
        this.say(to, text);
    }
};

Client.prototype.noisySay = function(text) {
    try {
        this.noisyChannels.forEach(function(channel) {
            this.say(channel, text);
        });
    }
    catch (e) {
        // XXX not connected yet? Need a connected callback or something.
    }
};

Client.prototype.hi = function(self, from, to, text, message) {
    self.sayOrSay(from, to, 'Hi ' + from + '!');    
};

Client.prototype.help = function(self, from, to, text, message) {
    var help = ['available commands:',
                'hi say hello',
                'help get command help',
                'latest [extension [extension...]] get latest events',
                'stats [days [extension]] get event stats',
                'recentbad get recent events'
               ];
    // should probably only PM back
    for (var line in help) {
        self.sayOrSay(from, to, help[line]);
    }
};

Client.prototype.textToCommands = function(text) {
    return text.trim().split(/\s+/);
};

Client.prototype.stats = function(self, from, to, text, message) {
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
        self.dbFileName,
        days,
        extension,
        function(result) {
            result.map(function (line) { self.sayOrSay(from, to, line); });
        });
};
    
Client.prototype.latest = function(self, from, to, text, message) {
    var words = self.textToCommands(text);
    var extensions = words.slice(1);
    if (!extensions.length) {
        extensions = null;
    }
    info.latest(
        self.dbFileName,
        extensions,
        function(result) {
            result.map(function (line) { self.sayOrSay(from, to, line); });
        });
};

Client.prototype.recentBad = function(self, from, to, text, message) {
    info.recentBad(
        self.dbFileName,
        function(result) {
            result.map(function (line) { self.sayOrSay(from, to, line); });
        });
};
   
Client.prototype.errorMessage = function(self, from, to, text, message) {
    self.sayOrSay(from, to, 'Use "help" for help.');
};

Client.prototype.noYoureTalk = function(from, to, text, message) {
    var self = this;
    var responses = {};
    // does message call me anything?    
    responses[self.nick + ' is'] = function(text) {
        text = text.trim();                           // strip whitespace
        text = text.replace(RegExp('[\.\!\?]+$'), '') // strip punct
        var outString = text.replace(RegExp('.*' + self.nick + ' is '), '');
        outString = "No, " + from + ", you're " + outString + '!';
        self.sayOrSay(from, to, outString);
    };
    // does message mention me?
    responses[self.nick] = function(text) {    
        var sayings = ['yo', 'hi', 'hello'];
        self.sayOrSay(from, to, sample(sayings));
    };
    for (var key in responses) {
        if (stringIn(key, text)) {
            responses[key](text);
            return;
        }
    }
};

Client.prototype.wordToCommand = function(word) {
    var commands = {
        'hi': this.hi,
        'stats': this.stats,
        'latest': this.latest,
        'recentbad': this.recentBad
    };
    if (word in commands) {
        return commands[word];
    }
    return null;
};

Client.prototype.wordToCommandPm = function(word) {
    var command = this.wordToCommand(word);
    if (command === null) {
        var commands = {    
            'help': this.help,
        };
        if (word in commands) {
            return commands[word];
        }
        return this.errorMessage;        
    }
    return command;
};

Client.prototype.pm = function(nick, text, message) {
    var words = this.textToCommands(text);
    if (words) {
        var command = this.wordToCommandPm(words[0]);
            if (command !== null) {
                command(this, nick, null, text, message);
            };
    }
};

Client.prototype.channelMessage = function(from, to, text, message) {
    if (text.indexOf('!') == 0) {
        // respond to commands in channel starting with !        
        text = text.replace('!', '');
        var words = this.textToCommands(text);
        if (words) {
            var command = this.wordToCommand(words[0]);
            if (command !== null) {
                command(this, from, to, text, message);
            };
        }
    } else if (this.noisyChannels.indexOf(message.args[0]) > -1) {
        // respond to talking in noisychannels
        this.noYoureTalk(from, to, text, message);        
    }
};

module.exports = {
    Client: Client
};
