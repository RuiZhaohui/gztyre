import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gztyre/commen/Global.dart';
import 'package:gztyre/components/TabBarIcon.dart';
import 'package:gztyre/pages/login/LoginPage.dart';
import 'package:gztyre/pages/orderCenter/OrderCategory.dart';
import 'package:gztyre/pages/problemReport/ProblemReportHomePage.dart';
import 'package:gztyre/pages/repairOrder/RepairOrderHomePage.dart';
import 'package:gztyre/pages/userCenter/UserCenterPage.dart';

class ContainerPage extends StatefulWidget {
  ContainerPage({Key key, @required this.rootContext, this.selectIndex = 0}) : super(key: key);

  final BuildContext rootContext;
  final int selectIndex;

  @override
  State createState() {
    return new _ContainerPageState();
  }
}

class _ContainerPageState extends State<ContainerPage> {
  var pages;

  @override
  void initState() {
    super.initState();
    pages = _buildPages();
    setState(() {

    });
  }

  List<Widget> _buildPages() {
      return [
        new RepairOrderHomePage(rootContext: widget.rootContext),
        new ProblemReportHomePage(rootContext: widget.rootContext),
        new OrderCategory(rootContext: widget.rootContext,),
        new UserCenterPage(rootContext: widget.rootContext),
      ];
  }

  Widget _buildTabBar() {

  print(Global.userInfo.toString());
//    if (isWorker) {
      return CupertinoTabBar(
          items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: TabBarIcon(
              image: AssetImage("assets/images/icon/icon_repair.png"),
              title: "我的报修单",
            ),
            activeIcon: TabBarIcon(
              image: AssetImage("assets/images/icon/icon_repair.png"),
              title: "我的报修单",
              isActive: true,
            )),
        BottomNavigationBarItem(
          icon: TabBarIcon(
            image: AssetImage("assets/images/icon/icon_report.png"),
            title: "故障上报",
          ),
          activeIcon: TabBarIcon(
            image: AssetImage("assets/images/icon/icon_report.png"),
            title: "故障上报",
            isActive: true,
          ),
        ),
        BottomNavigationBarItem(
          icon: TabBarIcon(
            image: AssetImage("assets/images/icon/icon_order.png"),
            title: "订单中心",
          ),
          activeIcon: TabBarIcon(
            image: AssetImage("assets/images/icon/icon_order.png"),
            title: "订单中心",
            isActive: true,
          ),
        ),
        BottomNavigationBarItem(
          icon: TabBarIcon(
            image: AssetImage("assets/images/icon/icon_user.png"),
            title: "个人中心",
          ),
          activeIcon: TabBarIcon(
            image: AssetImage("assets/images/icon/icon_user.png"),
            title: "个人中心",
            isActive: true,
          ),
        ),
      ]);
  }

  Widget _buildPage(int i) {
    return Center(
      child: pages[i],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!['A1', 'A2'].contains(Global.userInfo.MATYP)) {
      Global.logout();
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
              builder: (BuildContext context) {
                return LoginPage();
              }), (route) {
        return true;
      });
    }
    return CupertinoTabScaffold(
        tabBar: _buildTabBar(),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return _buildPage(index);
            },
          );
        });
  }
}
