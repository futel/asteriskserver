var assert = require('assert');
var sinon = require('sinon');
var client_mod = require('../client');

var getClient = function() {
    var client = new client_mod.Client('server', 'nick', {}, ['noisyChannel'], 'dbFileName', 'password');
    // we don't mock the server, which supplies the nick
    client.nick = 'nick';
    // disable first throttle
    client.throttleDate = new Date() - 1000 * 60 * 10;
    // patch for testing
    client.say = sinon.spy();
    return client;
}

var testOneSay = function(client, to, message) {
    assert(client.say.calledOnce);
    assert.equal(client.say.args[0][0], to);
    var sayMessage = client.say.args[0][1];
    if (message instanceof RegExp) {
        assert(sayMessage.match(message));
    } else {
        assert.equal(sayMessage, message);
    }
}

var testSays = function(client, to, messages) {
    client.say.args.forEach(function(arg) {
        assert.equal(arg[0], to);
        assert.equal(arg[1], messages.shift());
    });
    assert.equal(0, messages.length);
}

describe('main', function() {
    var client = null;

    beforeEach(function() {
        this.clock = sinon.useFakeTimers();
        client = getClient();
    });
    afterEach(function() {
        this.clock.restore();
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
        describe('die', function() {
            it('should die with correct password', function() {
                assert.throws(
                    function() {
                        client.pm('from', 'die password', 'message'); },
                    Error);
            });
        });
        describe('die', function() {
            it('should not die with incorrect password', function() {
                client.pm('from', 'die xyzzy', 'message');
            });
        });
        describe('die', function() {
            it('should not die without password', function() {
                client.pm('from', 'die', 'message');
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
                    'recentbad get recent events',
                    'peerstatus get recent peer status',
                    'peerstatusbad get recent bad peer status'])
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
        describe('peerStatus', function() {
            describe('empty', function() {            
                it('should provide an empty peer status', function() {
                    client.channelMessage('from', 'to', '!peerstatus', 'message');
                    testSays(client, 'to', ['Peer statuses:']);
                });
            });
            describe('populated', function() {
                it('should provide a populated peer status', function() {
                    client.peerStatusAction('SIP/668', 'Registered');
                    client.peerStatusAction('SIP/703', 'Registered');
                    client.peerStatusAction('SIP/703', 'Unreachable');
                    client.channelMessage('from', 'to', '!peerstatus', 'message');
                testSays(client,
                         'to',
                         ['Peer statuses:',
                          'SIP/668 Registered December 31, 1969 4:00 PM',
                          'SIP/703 Unreachable December 31, 1969 4:00 PM']);
                });
            });
        });            
        describe('peerStatusBad', function() {
            describe('empty', function() {            
                it('should provide an empty peer status', function() {
                    client.channelMessage('from', 'to', '!peerstatusbad', 'message');
                    testSays(client, 'to', ['Peer statuses:']);
                });
            });
            describe('populated', function() {
                it('should provide a populated peer status', function() {
                    client.peerStatusAction('SIP/668', 'Unreachable');
                    client.peerStatusAction('SIP/668', 'Registered');
                    client.peerStatusAction('SIP/703', 'Registered');
                    client.peerStatusAction('SIP/703', 'Unreachable');
                    client.channelMessage('from', 'to', '!peerstatusbad', 'message');
                testSays(client,
                         'to',
                         ['Peer statuses:',
                          'SIP/703 Unreachable December 31, 1969 4:00 PM']);
                });
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

    describe('talk in channel', function() {
        describe('unknown', function() {
            it('should not respond in non-noisy channel', function() {
                client.channelMessage(
                    'from', 'to', 'nick is foo', {args: []});
                assert.equal(false, client.say.called);
            });
        });
        describe('unknown', function() {
            it('should not respond to unknown talk', function() {
                client.channelMessage(
                    'from', 'to', 'xyzzy', {args: ['noisyChannel']});
                assert.equal(false, client.say.called);
            });
        });
        describe('unknown', function() {
            it('should not respond to command without hail or bang',
               function() {
                   client.channelMessage(
                       'from', 'to', 'hi', {args: ['noisyChannel']});
                   assert.equal(false, client.say.called);
               });
        });
        describe('nick is', function() {
            it('should respond to nick is', function() {
                client.channelMessage(
                    'from', 'to', 'nick is foo', {args: ['noisyChannel']});
                testOneSay(client, 'to', "No, from, you're foo!");
            });
        });
        describe('nick is', function() {
            it('should respond to nick is with surrounding text', function() {
                client.channelMessage(
                    'from', 'to', 'foo nick is bar...', {args: ['noisyChannel']});
                testOneSay(client, 'to', "No, from, you're bar!");
            });
        });
        describe('nick is', function() {
            it('should respond to nick is with capitalization', function() {
                client.channelMessage(
                    'from', 'to', 'Nick is bar', {args: ['noisyChannel']});
                testOneSay(client, 'to', "No, from, you're bar!");
            });
        });
        describe('nick is', function() {
            it('should respond to nick is with capitalization', function() {
                client.channelMessage(
                    'from', 'to', 'NICK IS BAR', {args: ['noisyChannel']});
                testOneSay(client, 'to', "No, from, you're bar!");
            });
        });
        describe('plate', function() {
            it('should respond to plate', function() {
                client.channelMessage(
                    'from', 'to', 'foo plate bar', {args: ['noisyChannel']});
                testOneSay(client, 'to', "Suddenly someone'll say, like, plate, or shrimp, or plate o' shrimp out of the blue, no explanation.");
            });
        });
        describe('plate', function() {
            it('should respond to plate with capitalization', function() {
                client.channelMessage(
                    'from', 'to', 'Foo Plate Bar', {args: ['noisyChannel']});
                testOneSay(client, 'to', "Suddenly someone'll say, like, plate, or shrimp, or plate o' shrimp out of the blue, no explanation.");
            });
        });
        describe('plate', function() {
            it('should respond to plate with capitalization', function() {
                client.channelMessage(
                    'from', 'to', 'Foo PLATE Bar', {args: ['noisyChannel']});
                testOneSay(client, 'to', "Suddenly someone'll say, like, plate, or shrimp, or plate o' shrimp out of the blue, no explanation.");
            });
        });
        describe('yes', function() {
            it('should respond to yes', function() {
                client.channelMessage(
                    'from', 'to', 'yes', {args: ['noisyChannel']});
                testOneSay(client, 'to', "No.");
            });
        });
        describe('yes', function() {
            it('should respond to yes with punctuation', function() {
                client.channelMessage(
                    'from', 'to', ' yes??', {args: ['noisyChannel']});
                testOneSay(client, 'to', "No.");
            });
        });
        describe('yes', function() {
            it('should respond to yes with capitalization', function() {
                client.channelMessage(
                    'from', 'to', 'YES', {args: ['noisyChannel']});
                testOneSay(client, 'to', "No.");
            });
        });
        describe('morning', function() {
            it('should respond to a morning greeting if it is morning', function() {
                client.date = sinon.stub().returns(new Date(2016, 1, 1, 1));
                client.channelMessage(
                    'from', 'to', 'foo morning bar', {args: ['noisyChannel']});
                // just test that we get something
                testOneSay(client, 'to', /.*/);
            });
        });
        describe('morning', function() {
            it('should not respond to a morning greeting if it is not morning', function() {
                client.date = sinon.stub().returns(new Date(2016, 1, 1, 23));
                client.channelMessage(
                    'from', 'to', 'foo morning bar', {args: ['noisyChannel']});
                assert.equal(false, client.say.called);
            });
        });
        describe('timeout', function() {
            it('should not respond again before timeout', function() {
                // talk to channel
                client.channelMessage(
                    'from', 'to', 'nick is foo', {args: ['noisyChannel']});
                testOneSay(client, 'to', "No, from, you're foo!");

                // advance one second
                this.clock.tick(1000);
                // talk to channel                
                client.channelMessage(
                    'from', 'to', 'nick is bar', {args: ['noisyChannel']});
                // still only one say
                testOneSay(client, 'to', "No, from, you're foo!");

                // advance one second
                this.clock.tick(1000);
                // talk to channel                
                client.channelMessage(
                    'from', 'to', 'nick is baz', {args: ['noisyChannel']});
                // still only one say
                testOneSay(client, 'to', "No, from, you're foo!");

                // advance 6 minutes
                this.clock.tick(1000 * 60 * 6);
                // talk to channel
                client.channelMessage(
                    'from', 'to', 'nick is qux', {args: ['noisyChannel']});
                // two says                
                testSays(client, 'to', ["No, from, you're foo!", "No, from, you're qux!"]);

                // advance one second
                this.clock.tick(1000);
                // talk to channel
                client.channelMessage(
                    'from', 'to', 'nick is quux', {args: ['noisyChannel']});
                // still two says                
                testSays(client, 'to', ["No, from, you're foo!", "No, from, you're qux!"]);
                // talk to channel for other responses
                client.channelMessage(
                    'from', 'to', 'foo plate bar', {args: ['noisyChannel']});
                client.channelMessage(
                    'from', 'to', 'yes', {args: ['noisyChannel']});
                client.date = sinon.stub().returns(new Date(2016, 1, 1, 1));
                client.channelMessage(
                    'from', 'to', 'foo morning bar', {args: ['noisyChannel']});
                // still two says                
                testSays(client, 'to', ["No, from, you're foo!", "No, from, you're qux!"]);
                
                
            });
        });
    });
});

