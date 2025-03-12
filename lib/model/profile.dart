

class Profile {
  var userId;
  var userLevelId;
  var displayName;
  var avatarUrl;
  var mobile;
  var email;

  var lineId;
  var expiredDate;
  var lastChangePassword;
  var defaultLanguageId;
  var language;
  var redisKey;


  Profile.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userLevelId = json['userLevelId'];
    displayName = json['displayName'];
    avatarUrl = json['avatarUrl'];
    mobile = json['mobile'];
    email = json['email'];
    lineId = json['lineId'];
    expiredDate = json['expiredDate'];
    lastChangePassword = json['lastChangePassword'];
    defaultLanguageId = json['defaultLanguageId'];
    language = json['language'];
    redisKey = json['redisKey'];
  }

}

