class SysUser {
  int id;
  String username;
  String password;
  String email;
  String headPortraitUrl;

  SysUser.fromJson(Map json)
      : this.id = json['id'],
        this.username = json['username'],
        this.email = json['email'],
        this.headPortraitUrl = json['headPortraitUrl'];
}
