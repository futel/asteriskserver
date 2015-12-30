/* ctrlH chatbot
 *  type a message and send a voicemail
 *  for ctrl H hackerspace!
 */

var irc = require('irc');
var exec = require('child_process').exec;
var help = ['**futelbot help**', 'available commands:',
            '!hi    say hello to your robot overlord',
            '!help  command help',
            '!vm    followed by <message>: send a voicemail to ctrlh'];

var config = {
  channels: [], // channels here
  server: "weber.freenode.net",
  botName: "futelbot",
  userName: "futelbot",
  realName: "FUTEL INC",
}

// create bot
var futelBot = new irc.Client(config.server, config.botName, {
  channels: config.channels,
  userName: config.userName,
  realName: config.realName
});

futelBot.addListener("message", function(from, to, text, message) {
  var re = /\!vm\ /;

  if (text === '!hi') {
    futelBot.say(message.args[0], "Hi " + from + "!");
  }
  if (text === '!help') {
    for (var i = 0; i < help.length; i++) {
      futelBot.say(from, help[i]);
    }
  }
  if (re.test(text)) {
    makeVM(message.args[0], text.slice(4), from);
  }
});

var makeVM = function(room, vm, user) {
  // use festival to "record" voicemail
  // TODO move the recorded message to vm folder
  var caller = user + ' sez';
  var cmd = 'echo '+caller+vm+'|'+'/usr/bin/text2wave -o ';
  var path = './vms/';
  exec(cmd + path + user + '.wav', function(error, stdout, stderr) {
    if (error !== null) {
      // Error should stop bot
      process.exit(error.code);
    } else {
      futelBot.say(room, 'Thanks for the message ' + user);
    }
  });
}
