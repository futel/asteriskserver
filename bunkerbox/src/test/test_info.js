var assert = require('assert');
//var sinon = require('sinon');
var info_mod = require('../info');

var getInfo = function() {
    var info = new info_mod.Info();    
    return info;
}

var arrayCmp = function(left, right) {
    return left.length == right.length && left.every(function(v, i) { return v === right[i] });
}


describe('main', function() {
    var info = null;

    beforeEach(function() {
        info = getInfo();
    });

    describe('peerStatus', function() {
        describe('empty', function() {            
            it('should provide an empty peer status', function() {
                assert.ok(arrayCmp(info.peerStatus(), ['Peer statuses:']));
            });
        });
    });            

});

