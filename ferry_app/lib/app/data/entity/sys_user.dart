class SysUser {
  int id;
  String username;
  String email;
  String headPortraitUrl;
  String nickname;

  SysUser(this.username, this.nickname, this.email, this.headPortraitUrl);

  SysUser.fromJson(Map json)
      : this.id = json['id'],
        this.username = json['username'],
        this.email = json['email'],
        this.headPortraitUrl = json['headimg'],
        this.nickname = json['name'];
}
