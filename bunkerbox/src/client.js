var irc = require('irc');
var util = require('util');

var info_mod = require('./info');

var info = new info_mod.Info();

var defaultStatsDays = 60;

function Client(server, nick, opt, noisyChannels, dbFileName) {
    irc.Client.call(this, server, nick, opt);    
    this.noisyChannels = noisyChannels;
    this.dbFileName = dbFileName;
    // respond to commands in pm
    this.addListener("pm", this.pm);
    // respond to talking in channels
    this.addListener("message#", this.channel_message);
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

Client.prototype.wordToCommand = function(word) {
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

Client.prototype.pm = function(nick, text, message) {
    var words = this.textToCommands(text);
    if (words) {
        var command = this.wordToCommand(words[0]);
        command(this, nick, null, text, message);
    }
};

Client.prototype.channel_message = function(from, to, text, message) {
    if (text.indexOf('!') == 0) {
        // respond to commands in channel starting with !        
        text = text.replace('!', '');
        var words = this.textToCommands(text);
        if (words) {
            var command = this.wordToCommand(words[0]);
            command(this, from, to, text, message);
        }
    } else if (this.noisyChannels.indexOf(message.args[0]) > -1) {
        // respond to talking in noisychannels
        this.noYoureTalk(from, to, text, message);        
    }
};

module.exports = {
    Client: Client
};
