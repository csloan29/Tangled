
var uuidv4 = require('uuid/v4');

// singleton for tool creation
module.exports = new createTools();

function createTools() {

  this.objHasAllProperties = function (obj, list) {
    for (let i in list) {
      if (!list[i] in obj) {
        return false;
      }
    }
    return true;
  }

  this.addLoginTokenToUser = function(user) {
    let accessToken = uuidv4();
    user['token'] = [accessToken];
    return accessToken;
  }
}