import 'package:ferry_app/app/data/entity/sys_user.dart';
import 'package:ferry_app/common/theme.dart';
import 'package:flutter/material.dart';

class ConsoleDrawer extends StatelessWidget {
  final SysUser sysUser;
  ConsoleDrawer(this.sysUser);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:
                Text(sysUser.nickname, style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(sysUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(sysUser.headPortraitUrl),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(
                    'https://img3.doubanio.com/view/note/large/public/p225659467-1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    AppTheme.primaryColor.withOpacity(0.3), BlendMode.hardLight),
              ),
            ),
          ),
          ListTile(
            title: Text(
              '消息',
              textAlign: TextAlign.right,
            ),
            trailing: Icon(Icons.message, color: Colors.black12, size: 22.0),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text(
              '最爱',
              textAlign: TextAlign.right,
            ),
            trailing: Icon(Icons.favorite, color: Colors.black12, size: 22.0),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text(
              '设置',
              textAlign: TextAlign.right,
            ),
            trailing: Icon(Icons.settings, color: Colors.black12, size: 22.0),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
