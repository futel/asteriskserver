var client_mod = require('../client');

// function Server() {};
// Server.prototype.connect = function() { console.log("connect"); }
// var server = Server();

var client = new client_mod.Client('server', 'nick', {}, ['noisyChannel'], 'dbFileName');
// we don't mock the server, which supplies the nick
client.nick = 'nick';

// // add event listeners for testing
// ['abort', 'action', 'connect', 'error', 'join', 'kill', 'message#', 'message', 'motd', 'names', 'names', 'nick', 'notice', 'opered', 'part', 'ping', 'pm', 'pong', 'quit', 'raw', 'registered', 'selfMessage'].forEach(
//     function(element) {
//         client.on(element, arguments => {
//             console.log(element, arguments);
//         });
//     }
// );

// patch for testing
client.say = function(channel, text) {console.log(channel, text)};


// test pm commands
// from Use "help" for help.
client.pm('from', 'xyzzy', 'message');
// from Hi from!
client.pm('from', 'hi', 'message');
// from available commands:
// from hi say hello
// from help get command help
// from latest [extension [extension...]] get latest events
// from stats [days [extension]] get event stats
// from recentbad get recent events
client.pm('from', 'help', 'message');

// test channel commands
// to Hi from!
client.channelMessage('from', 'to', '!hi', 'message');
// 
client.channelMessage('from', 'to', '!help', 'message');

// test channel talk responses
//
client.channelMessage('from', 'to', 'nick is foo', {args: []});
//
client.channelMessage('from', 'to', 'xyzzy', {args: ['noisyChannel']});
// to No, from, you're foo!
client.channelMessage('from', 'to', 'nick is foo', {args: ['noisyChannel']});
// to No, from, you're bar!
client.channelMessage('from', 'to', 'foo nick is bar', {args: ['noisyChannel']});
// three says of hello, yo, hi
client.channelMessage('from', 'to', 'nick foo', {args: ['noisyChannel']});
client.channelMessage('from', 'to', 'nick foo', {args: ['noisyChannel']});
client.channelMessage('from', 'to', 'nick foo', {args: ['noisyChannel']});
