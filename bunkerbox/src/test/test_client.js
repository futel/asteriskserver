var assert = require('assert');
var sinon = require('sinon');
var client_mod = require('../client');

var getClient = function() {
    var client = new client_mod.Client('server', 'nick', {}, ['noisyChannel'], 'dbFileName');
    // we don't mock the server, which supplies the nick
    client.nick = 'nick';
    // disable first throttle
    client.throttleDate = new Date() - 10 * 1000;
    // patch for testing
    sinon.spy(client, "say");
    return client;
}

var testOneSay = function(client, to, message) {
    assert(client.say.calledOnce);
    assert.equal(client.say.args[0][0], to);
    assert.equal(client.say.args[0][1], message);
}

var testSays = function(client, to, messages) {
    assert.equal(client.say.args.length, messages.length);
    client.say.args.forEach(function(arg) {
        assert.equal(arg[0], to);
        assert.equal(arg[1], messages.shift());
    });
}

describe('main', function() {
    var client = null;

    beforeEach(function() {
        client = getClient();
    });

    describe('pm', function() {
        describe('unknown', function() {
            it('should pm help summary from unknown input', function() {
                client.pm('from', 'xyzzy', 'message');
                testOneSay(client, 'from', 'Use "help" for help.');
            });
        });
        describe('hi', function() {
            it('should pm hi response', function() {
                client.pm('from', 'hi', 'message');
                testOneSay(client, 'from', 'Hi from!');
            });
        });
        describe('help', function() {
            it('should pm help response', function() {
                client.pm('from', 'help', 'message');
                testSays(client, 'from', [
                    'available commands:',
                    'hi say hello',
                    'help get command help',
                    'latest [extension [extension...]] get latest events',
                    'stats [days [extension]] get event stats',
                    'recentbad get recent events'])
            });
        });
    });

    describe('bang commands in channel', function() {
        describe('unknown', function() {
            it('should not respond to unknown command', function() {
                client.channelMessage('from', 'to', '!xyzzy', 'message');
                assert.equal(false, client.say.called);
            });
        });
        describe('hi', function() {
            it('should say hi response', function() {
                client.channelMessage('from', 'to', '!hi', 'message');
                testOneSay(client, 'to', 'Hi from!');                
            });
        });
        describe('help', function() {
            it('should not respond to help command', function() {
                client.channelMessage('from', 'to', '!help', 'message');
                assert.equal(false, client.say.called);
            });
        });
    });

    describe('nick hails in channel', function() {
        describe('unknown', function() {
            it('should not respond to unknown hail', function() {
                client.channelMessage('from', 'to', 'nick: xyzzy', 'message');
                assert.equal(false, client.say.called);
            });
        });
        describe('hi', function() {
            it('should say hi response', function() {
                client.channelMessage('from', 'to', 'nick: hi', 'message');
                testOneSay(client, 'to', 'Hi from!');                
            });
        });
        describe('help', function() {
            it('should not respond to help command', function() {
                client.channelMessage('from', 'to', 'nick: help', 'message');
                assert.equal(false, client.say.called);
            });
        });
    });
   
    
});

// // test channel talk responses
// //
// getClient().channelMessage('from', 'to', 'nick is foo', {args: []});
// //
// getClient().channelMessage('from', 'to', 'xyzzy', {args: ['noisyChannel']});
// //
// getClient().channelMessage('from', 'to', 'hi', {args: ['noisyChannel']});
// //
// getClient().channelMessage('from', 'to', 'help', {args: ['noisyChannel']});
// // to No, from, you're foo!
// getClient().channelMessage('from', 'to', 'nick is foo', {args: ['noisyChannel']});
// // to No, from, you're bar!
// getClient().channelMessage('from', 'to', 'foo nick is bar', {args: ['noisyChannel']});
// // to Suddenly someone'll say, like, plate, or shrimp, or plate o' shrimp out of the blue, no explanation.
// getClient().channelMessage('from', 'to', 'foo plate bar', {args: ['noisyChannel']});
// // to Yes.
// getClient().channelMessage('from', 'to', 'no', {args: ['noisyChannel']});
// // three says of greeting sayings
// getClient().channelMessage('from', 'to', 'foo nick bar', {args: ['noisyChannel']});
// getClient().channelMessage('from', 'to', 'foo nick bar', {args: ['noisyChannel']});
// getClient().channelMessage('from', 'to', 'foo nick bar', {args: ['noisyChannel']});
// var client = getClient();
// // to No, from, you're bar!
// client.channelMessage('from', 'to', 'foo nick is bar', {args: ['noisyChannel']});
// //
// client.channelMessage('from', 'to', 'foo nick is bar', {args: ['noisyChannel']});
