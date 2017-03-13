var config = {
    channels: ["#cor", "#pdxbots", "#futel"],
    noisyChannels: ['#cor', '#pdxbots', "#futel"],
    server: "irc.freenode.net",
    botName: "mechaoperator",
    userName: "mechaoperator",
    realName: "Futel Mechanical Operator",
    dbFileName: '/opt/futel/stats/prod/metrics.db',
    eventHostname: 'futel-prod'
};

module.exports = { config: config };
