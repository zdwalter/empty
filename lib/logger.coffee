winston = require 'winston'
config = require './config'
logLevel =
    levels:
        debug:0
        info:1
        warn:2
        error:3
    colors:
        data:'white'
        info:'blue'
        warn:'yellow'
        error:'red'

winston.addColors logLevel.colors
logger = new (winston.Logger)(
        transports: [
            new (winston.transports.Console)({
                colorize:'true'
                level:config.log.level
            })
        ]
        levels:logLevel.levels
)


module.exports = logger
