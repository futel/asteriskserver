var assert = require('assert');
var sinon = require('sinon');
var info_mod = require('../info');

var getInfo = function() {
    var info = new info_mod.Info('dbFileName');    
    return info;
}

var arrayCmp = function(left, right) {
    return left.length == right.length && left.every(function(v, i) { return v === right[i] });
}


describe('main', function() {
    var info = null;

    beforeEach(function() {
        this.clock = sinon.useFakeTimers();        
        info = getInfo();
    });
    afterEach(function() {
        this.clock.restore();
    });

    describe('peerStatus', function() {
        describe('empty', function() {            
            it('should provide an empty peer status', function() {
                assert.ok(arrayCmp(info.peerStatus(), ['Peer statuses:']));
            });
        });
    });
    describe('populated', function() {
        it('should provide a populated peer status', function() {
            info.peerStatusAction('SIP/668', 'Registered');
            this.clock.tick(1000 * 60 * 2);                    
            info.peerStatusAction('SIP/703', 'Registered');
            this.clock.tick(1000 * 60 * 2);                    
            info.peerStatusAction('SIP/703', 'Unreachable');
            this.clock.tick(1000 * 60 * 2);                    
            info.peerStatusAction('SIP/704', 'Registered');
            assert.ok(arrayCmp(
                info.peerStatus(),
                ['Peer statuses:',
                 'SIP/704 Registered December 31, 1969 4:06 PM',                        
                 'SIP/703 Unreachable December 31, 1969 4:04 PM',
                 'SIP/668 Registered December 31, 1969 4:00 PM'
                ]));
        });
    });
});
