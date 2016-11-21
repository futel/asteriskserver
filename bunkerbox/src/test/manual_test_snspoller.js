var snspoller = require('../snspoller');
var secrets = require('../secrets');
var config = require('../config');

function Client() {}
Client.prototype.noisySay = function(body) { console.log(body); };
Client.prototype.peerStatusAction = function(peer, status) { console.log(peer); console.log(status); };
var client = new Client();

var poller = snspoller.Poller(
    secrets.config.sqsUrl,
    secrets.config.awsAkey,
    secrets.config.awsSecret,
    config.config.eventHostname,
    client);
