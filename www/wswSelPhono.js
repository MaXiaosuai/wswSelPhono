var exec = require('cordova/exec');

module.exports = {
    selPhoto:function (arg0, success, error) {
        exec(success, error, 'wswSelPhono', 'selPhoto', [arg0]);
    },
    selCamera:function (success, error) {
        exec(success, error, 'wswSelPhono', 'selCamera', []);
    }
}
