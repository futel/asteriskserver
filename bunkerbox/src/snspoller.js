var AsyncPolling = require('async-polling');
var AWS = require('aws-sdk');

var pollMilliSeconds = 10000;

var removeFromQueue = function(sqs, sqsUrl, message) {
    sqs.deleteMessage({
        QueueUrl: sqsUrl,
        ReceiptHandle: message.ReceiptHandle
    }, function(err, data) {
        if (err !== null) {
            console.log(err);
        }
    });
};

var receiveMessage = function(sqs, sqsUrl, hostname, eventMap) {
    sqs.receiveMessage({
        QueueUrl: sqsUrl,
        MaxNumberOfMessages: 10,
        VisibilityTimeout: 60 // seconds, how long to lock messages
    }, function(err, data) {
        if (err !== null) {
            console.log(err);
        } else {
            if (data.Messages !== undefined) {
                data.Messages.forEach(function(message) {
                    var body = JSON.parse(message.Body);
                    var body = JSON.parse(body.Message);
                    if (body.hostname == hostname) {
                        console.log(body.event);                        
                        var fn = eventMap[body.event.Event];
                        if (fn) {
                            fn(body);
                        } else {
                            var fn = eventMap['defaultEventAction'];
                            if (fn) {
                                fn(body);
                            }
                        }
                    };
                    removeFromQueue(sqs, sqsUrl, message);
                });
            }
        }
    });
};

var poll = function(sqsUrl, akey, secret, hostname, eventMap) {
    AWS.config.update({accessKeyId: akey, secretAccessKey: secret});
    AWS.config.update({region: 'us-west-2'})
    var sqs = new AWS.SQS();
    AsyncPolling(function (end) {
        var message = receiveMessage(sqs, sqsUrl, hostname, eventMap);
        end();
    }, pollMilliSeconds).run();
};

function Poller(sqsUrl, awsAkey, awsSecret, eventHostname, client) {
    var defaultEventAction = function(body) {
    };
    var confbridgeJoinAction = function(body) {
        client.confbridgeJoinAction();
    };
    var confbridgeLeaveAction = function(body) {
        client.confbridgeLeaveAction();
    };
    var peerStatusAction = function(body) {
        client.peerStatusAction(body.event.Peer, body.event.PeerStatus);
    };
    
    var pollerEventMap = {
        'ConfbridgeJoin': confbridgeJoinAction,
        'ConfbridgeLeave': confbridgeLeaveAction,
        'PeerStatus': peerStatusAction,
        'defaultEventAction': defaultEventAction,
    };
    poll(
        sqsUrl,
        awsAkey,
        awsSecret,
        eventHostname,
        pollerEventMap);
}

module.exports = { Poller: Poller };
