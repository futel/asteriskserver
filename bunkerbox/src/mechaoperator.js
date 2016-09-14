var client_mod = require('./client');
var snspoller = require('./snspoller');

var config = require('./config');
var secrets = require('./secrets');

var client = new client_mod.Client(
    config.config.server,
    config.config.botName,
    {channels: config.config.channels,
     userName: config.config.userName,
     realName: config.config.realName
    },
    config.config.noisyChannels,
    config.config.dbFileName);

// tack sns polling onto client

client.defaultEventAction = function(body) {
};
client.confbridgeJoinAction = function(body) {
    client.noisySay('Voice conference joined');
};
client.confbridgeLeaveAction = function(body) {
    client.noisySay('Voice conference left');
};

var pollerEventMap = {
    'ConfbridgeJoin': client.confbridgeJoinAction,
    'ConfbridgeLeave': client.confbridgeLeaveAction,
    'defaultEventAction': client.defaultEventAction,
};

snspoller.poll(
    secrets.config.sqsUrl,
    secrets.config.awsAkey,
    secrets.config.awsSecret,
    config.config.eventHostname,
    pollerEventMap);
