var irc = require('irc');
var fs = require('fs');
var config = require('./config');

var statsDirName = '/opt/futel/stats/prod';

var help = ['available commands:',
            'hi say hello',
            'help command help',
            'stats call stats'];

// create bot
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
    // XXX only PM
    for (var line in help) {
        bot.sayOrSay(from, to, help[line]);
    }
};

bot.stats = function(from, to, text, message) {
    words = bot.textToCommands(text);
    var days = words[1];
    var statsFileName = statsDirName + '/' + days;
    try { 
        var stats = JSON.parse(fs.readFileSync(statsFileName, 'utf8'));
    }
    catch (e) {
        bot.sayOrSay(from, to, 'No stats for ' + days);
        return;
    }
    bot.sayOrSay(from, to, 'events last ' + stats['delta'] + ' from ' + stats['timestamp']);
    bot.sayOrSay(from, to, 'latest event ' + stats['latest_timestamp'] + ' ' + stats['latest_name']);
    bot.sayOrSay(from, to, 'most frequent events:');
    var histStrings = [];
    for (i in stats['histogram']) {
        var event = stats['histogram'][i][0];
        var freq = stats['histogram'][i][1];
        histStrings.push(event + ' (' + freq + ')');
    }
    bot.sayOrSay(from, to, histStrings.join(' '));
};

bot.errorMessage = function(from, to, text, message) {
    bot.sayOrSay(from, to, 'Use "help" for help.');
};

bot.commands = {
    'hi': bot.hi,
    'help': bot.help,
    'stats': bot.stats}

bot.textToCommands = function(text) {
    return text.trim().split(/\s+/);
}

// respond to commands in pm, or error message
bot.addListener("pm", function(nick, text, message) {
    words = bot.textToCommands(text);
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
