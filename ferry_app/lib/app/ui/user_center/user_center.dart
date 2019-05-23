import 'package:ferry_app/app/data/entity/sys_user.dart';
import 'package:ferry_app/app/widget/usercenter/contact_item.dart';
import 'package:ferry_app/app/widget/usercenter/menu_item.dart';
import 'package:flutter/material.dart';

class UserCenter extends StatefulWidget {
  final SysUser sysUser;
  UserCenter(this.sysUser);
  @override
  _UserCenterState createState() => _UserCenterState(sysUser);
}

class _UserCenterState extends State<UserCenter>
    with AutomaticKeepAliveClientMixin<UserCenter> {
  final SysUser sysUser;
  _UserCenterState(this.sysUser);
  final double _appBarHeight = 180.0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: new Color.fromARGB(255, 242, 242, 245),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            expandedHeight: _appBarHeight,
            flexibleSpace: new FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  const DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: const LinearGradient(
                        begin: const Alignment(0.0, -1.0),
                        end: const Alignment(0.0, -0.4),
                        colors: const <Color>[
                          const Color.fromARGB(155, 0, 150, 163),
                          const Color.fromARGB(155, 0, 150, 163)
                        ],
                      ),
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Expanded(
                        flex: 3,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                                left: 30.0,
                                bottom: 15.0,
                              ),
                              child: new Text(
                                sysUser.nickname,
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35.0),
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                              ),
                              child: new Text(
                                sysUser.email,
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(
                          top: 35.0,
                          right: 40.0,
                        ),
                        child: new CircleAvatar(
                          radius: 35.0,
                          backgroundImage:
                              new NetworkImage(sysUser.headPortraitUrl),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          new SliverList(
            delegate: new SliverChildListDelegate(
              <Widget>[
                new Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: <Widget>[
                      new MenuItem(
                        icon: Icons.face,
                        title: '我的信息',
                      ),
                      new MenuItem(
                        icon: Icons.home,
                        title: '个人偏好设置',
                      ),
                      new MenuItem(
                        icon: Icons.chat,
                        title: '在线咨询',
                      ),
                      new MenuItem(
                        icon: Icons.security,
                        title: '隐私设置',
                      ),
                      new MenuItem(
                        icon: Icons.assessment,
                        title: '关于软件',
                      ),
                      new MenuItem(
                        icon: Icons.archive,
                        title: '体验新版本',
                      ),
                      new MenuItem(
                        icon: Icons.settings,
                        title: '设置',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
