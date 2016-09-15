var client_mod = require('../client');

// function Server() {};
// Server.prototype.connect = function() { console.log("connect"); }
// var server = Server();

var client = new client_mod.Client('server', 'nick', {}, ['noisyChannel'], 'dbFileName');
// XXX we don't mock the server, which supplies the nick
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

client.pm('from', 'hi', 'message');
client.channel_message('from', 'to', '!hi', 'message');
client.channel_message('from', 'to', 'nick is foo', {args: ['noisyChannel']});
client.channel_message('from', 'to', 'nick foo', {args: ['noisyChannel']});
