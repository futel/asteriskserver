var irc = require('irc');
var util = require('util');

var defaultStatsDays = 60;

var sample = function(arr) { return arr[Math.floor(Math.random() * arr.length)]; }

var stringIn = function(str1, str2) {
    // return True if str1 is in str2
    return str2.indexOf(str1) > -1;
}

function Client(info, noisyChannels, botPassword) {
    this.info = info;
    this.noisyChannels = noisyChannels;
    this.botPassword = botPassword;
    this.says = new Map();
    this.resetThrottle();
}

util.inherits(Client, irc.Client);

Client.prototype.log = function() {
    var args = [new Date()].concat(Array.from(arguments));
    console.log(args);
};

Client.prototype.date = function() {
    return new Date();
};

Client.prototype.addSay = function(to, text) {
    if (this.says.get(to) === undefined) {
        this.says.set(to, [text]);
    } else {
        says = this.says.get(to);
        says.push(text);
        this.says.set(to, says);
    }
};

Client.prototype.doSays = function() {
    // doSay up to once for each key in says.
    var self = this;
    self.says.forEach(function(value, key) {
        if (value.length) {
            text = value.shift();
            self.says.set(key, value);
            self.doSay(key, text);
        }
    });
};

Client.prototype.doSay = function(to, text) {
    this.log('say', to, text);
    this.say(to, text);
};

Client.prototype.sayOrSay = function(from, to, text) {
    if (to === null) {
        // pm
        this.addSay(from, text);
    } else {
        // channel command
        this.addSay(to, text);
    }
};

Client.prototype.noisySay = function(text) {
    var self = this;
    try {
        this.noisyChannels.forEach(function(channel) {
            self.addSay(channel, text);
        });
    }
    catch (e) {
        // XXX this is just bad setup order? Replace with global catch to log and prevent death,
        //     or a real job scheduler
        console.log(e);
    }
};

Client.prototype.peerStatusAction = function(peer, status) {
    this.info.peerStatusAction(peer, status);
};

Client.prototype.peerStatus = function(self, from, to, text, message) {
    self.info.peerStatus().forEach(function(line) {self.sayOrSay(from, to, line);});
};

Client.prototype.peerStatusBad = function(self, from, to, text, message) {
    self.info.peerStatusBad().forEach(function(line) {self.sayOrSay(from, to, line);});    
};

Client.prototype.confbridgeJoinAction = function() {
    this.noisySay('Voice conference joined');
};

Client.prototype.confbridgeLeaveAction = function() {
    this.noisySay('Voice conference left');
};

Client.prototype.hi = function(self, from, to, text, message) {
    self.sayOrSay(from, to, 'Hi ' + from + '!');    
};

Client.prototype.help = function(self, from, to, text, message) {
    var help = ['available commands:',
                'hi say hello',
                'help get command help',
                'latest [days] [extension] get latest events',
                'stats [days] [extension] get event stats',
                'recentbad get recent events',
                'peerstatus get recent peer status',
                'peerstatusbad get recent bad peer status'
               ];
    // should probably only PM back
    for (var line in help) {
        self.sayOrSay(from, to, help[line]);
    }
};

Client.prototype.textToCommands = function(text) {
    return text.trim().split(/\s+/);
};

Client.prototype.textToArgs = function(self, text) {
    var args = self.textToCommands(text);
    var days = args[1];
    var extension = args[2];
    try {
        days = days.toString();
    } catch(e) {
        days = defaultStatsDays;
    }
    try {
        extension = extension.toString();
    } catch(e) {
        extension = null;
    }
    return [days, extension];
};

Client.prototype.passwordMatch = function(text) {
    var words = this.textToCommands(text);
    if (words[1] == this.botPassword) {
        return true;
    }
    this.log('passwordMatch failed');
    return false;
};

Client.prototype.die = function(self, from, to, text, message) {
    if (self.passwordMatch(text)) {
        self.log('dying');
        throw new Error('dying');
    }
};

Client.prototype.stats = function(self, from, to, text, message) {
    var args = self.textToArgs(self, text);
    var days = args[0];
    var extension = args[1];
    self.info.stats(
        days,
        extension,
        function(result) {
            result.map(function (line) { self.sayOrSay(from, to, line); });
        });
};
    
Client.prototype.latest = function(self, from, to, text, message) {
    var args = self.textToArgs(self, text);
    var days = args[0];         // XXX ignored
    var extension = args[1];
    self.info.latest(
        extension,
        function(result) {
            result.map(function (line) { self.sayOrSay(from, to, line); });
        });
};

Client.prototype.recentBad = function(self, from, to, text, message) {
    self.info.recentBad(
        function(result) {
            result.map(function (line) { self.sayOrSay(from, to, line); });
        });
};
   
Client.prototype.errorMessage = function(self, from, to, text, message) {
    self.sayOrSay(from, to, 'Use "help" for help.');
};

Client.prototype.simpleStrings = function(from, to, text, message) {
    // simple string to string response
    var self = this;
    var responses = {
        'yes': "No.",
        'no': "Yes.",
        'maybe': "MAYBE?",
        'false': "True.",
        'true': "False.",
        'hi': "Hi!",
        'hello': "Hi!",        
    }
    text = text.toLowerCase();
    text = text.replace(/[^\w]/g,'');
    for (var key in responses) {
        if (key == text) {
            self.sayOrSay(from, to, responses[key]);
            return true;
        }
    }
    return null;
};

Client.prototype.simpleSubstrings = function(from, to, text, message) {
    // simple substring to string response
    var self = this;
    var responses = {
        'plate': "Suddenly someone'll say, like, plate, or shrimp, or plate o' shrimp out of the blue, no explanation.",
        'shrimp': "Suddenly someone'll say, like, plate, or shrimp, or plate o' shrimp out of the blue, no explanation.",
        'society': "Society made me what I am.",
        'intense': "The life of a repo man is always intense.",
        'tense': "A repo man spends his life getting into tense situations.",
        'relationship': "What about our relationship?",
        'radiation': "You hear the most outrageous lies about it.",
        'code': "Not many people got a code to live by anymore.",
        'innocence': "No one is innocent.",
        'innocent': "No one is innocent."
    }
    for (var key in responses) {
        if (stringIn(key, text)) {
            self.sayOrSay(from, to, responses[key]);
            return true;
        }
    }
    return null;
};

Client.prototype.substrings = function(from, to, text, message) {
    // substring to response
    var self = this;
    var responses = {};
    // is message greeting the morning?
    responses['morning'] = function(text) {
        if (self.date().getHours() < 12) {
            var sayings = [
                'MORNING', 'MORNING', 'MORNING', 'MORNING', 'MORNING',
                'Morning.', 'Morning!',
                'Good morning.', 'Good morning!', 'GOOD MORNING',
                'Guten morgen.', 'GUTEN MORGEN',
                'QAPLA'];
            self.sayOrSay(from, to, sample(sayings));
        }
    };
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
        var sayings = [
            'Yo.', 'Hi.', 'Hello.', 'Hej.', 'Qapla!',
            '?', '!', 'Yes.', 'No.', ''];
        self.sayOrSay(from, to, sample(sayings));
    };
    for (var key in responses) {
        if (stringIn(key, text)) {
            responses[key](text);
            return true;
        }
    }
    return null;
};

Client.prototype.sinceThrottle = function() {
    var twoMinutes = 1000 * 60 * 2;
    if ((new Date() - this.throttleDate) < twoMinutes) {
        return false;
    }
    this.resetThrottle();
    return true;
};
Client.prototype.resetThrottle = function() {
    this.throttleDate = new Date();
};

Client.prototype.noYoureTalk = function(from, to, text, message) {
    // respond to channel talking
    if (!this.sinceThrottle()) {
        this.log('throttling');        
        return;
    }
    text = text.toLowerCase();
    if (this.simpleSubstrings(from, to, text, message) === true) {
        return;
    } else if (this.substrings(from, to, text, message) === true) {
        return;
    } else if (this.simpleStrings(from, to, text, message) === true) {
        return;
    }
};

Client.prototype.wordToCommand = function(word) {
    var commands = {
        'hi': this.hi,
        'stats': this.stats,
        'latest': this.latest,
        'recentbad': this.recentBad,
        'peerstatus': this.peerStatus,
        'peerstatusbad': this.peerStatusBad        
    };
    if (word in commands) {
        return commands[word];
    }
    return null;
};

Client.prototype.wordToCommandPm = function(word) {
    var command = this.wordToCommand(word);
    if (command === null) {
        // add additional commands only available in pm
        var commands = {
            'die': this.die,
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
    } else if (text.indexOf(this.nick + ':') == 0) {
        // respond to commands in channel starting with channel hails
        text = text.replace(this.nick + ':', '');
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

Client.prototype.start = function(server, nick, opt) {
    var fifthSecond = 200;
    
    var self = this;    
    irc.Client.call(this, server, nick, opt);        
    // respond to commands in pm
    this.addListener("pm", this.pm);
    // respond to talking in channels
    this.addListener("message#", this.channelMessage);

    setInterval(function() {
        self.doSays();
    }, fifthSecond);
};

module.exports = {
    Client: Client
};
