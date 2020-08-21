import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gztyre/api/HttpRequest.dart';
import 'package:gztyre/api/model/Order.dart';
import 'package:gztyre/api/model/UserInfo.dart';
import 'package:gztyre/commen/Global.dart';
import 'package:gztyre/components/OrderCardWidget.dart';
import 'package:gztyre/components/ProgressDialog.dart';
import 'package:gztyre/components/UserInfoWidget.dart';
import 'package:gztyre/pages/repairOrder/RepairOrderPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RepairOrderHomePage extends StatefulWidget {
  RepairOrderHomePage({Key key, @required this.rootContext})
      : assert(rootContext != null),
        super(key: key);

  final BuildContext rootContext;

  @override
  State createState() {
    return new _RepairOrderHomePageState();
  }
}

class _RepairOrderHomePageState extends State<RepairOrderHomePage> {
  var _listRepairOrderFuture;

  bool _loading = false;
  UserInfo _userInfo;
  List<Order> _list;
  Map<String, String> _levelMap = {
    "A": "1",
    "B": "2",
    "C": "3",
    "D": "4"
  };

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _listRepairOrder() async {
    this._loading = true;
    this._list = [];
    return await HttpRequest.listOrder(this._userInfo.PERNR, null, null, null,  _userInfo.WCTYPE == "是" ? "X" : "", null,
        _userInfo.WCTYPE == "是" ? Global.maintenanceGroup : new List(),
        (List<Order> list) {
      list.forEach((item) {
        if (item.PERNR == this._userInfo.PERNR) {
          this._list.add(item);
        }
      });
      _list = sortList(_list);
      setState(() {
        this._loading = false;
      });
      return true;
    }, (err) {
      print(err);
      setState(() {
        this._loading = false;
      });
      return false;
    });
  }

  List<Order> sortList(List<Order> list) {
    List<Order> completeList = list.where((element) => element.ASTTX == "已完工").toList();
    List<Order> repairingList = list.where((element) => element.ASTTX == "维修中").toList();
    List<Order> waitingList = list.where((element) => element.ASTTX == "等待中").toList();
    List<Order> newList = list.where((element) => element.ASTTX == "新建" || element.ASTTX == "新工单").toList();
    list.removeWhere((element) => element.ASTTX == "已完工" || element.ASTTX == "维修中" || element.ASTTX == "等待中" || element.ASTTX == "新建" || element.ASTTX == "新工单");
    completeList.sort((Order o1, Order o2) {
      return int.parse(o1.ILART.substring(1)) - int.parse(o2.ILART.substring(1));
    });
    repairingList.sort((Order o1, Order o2) {
      return int.parse(o1.ILART.substring(1)) - int.parse(o2.ILART.substring(1));
    });
    waitingList.sort((Order o1, Order o2) {
      return int.parse(o1.ILART.substring(1)) - int.parse(o2.ILART.substring(1));
    });
    newList.sort((Order o1, Order o2) {
      return int.parse(o1.ILART.substring(1)) - int.parse(o2.ILART.substring(1));
    });
    completeList.addAll(repairingList);
    completeList.addAll(waitingList);
    completeList.addAll(newList);
    completeList.addAll(list);
    return completeList;
  }

  Future<Null> onHeaderRefresh() {
//    HttpRequestRest.listPosition(_userInfo.PERNR, (success){}, (err){});
    this._list = [];
    return new Future(() async {
      return await HttpRequest.listOrder(this._userInfo.PERNR, null, null, null, _userInfo.WCTYPE == "是" ? "X" : "", null,
          _userInfo.WCTYPE == "是" ? Global.maintenanceGroup : new List(),
          (List list) {
        list.forEach((item) {
          if (item.PERNR == this._userInfo.PERNR) {
            this._list.add(item);
          }
        });
        _list = sortList(_list);
        this._refreshController.refreshCompleted();
        print(DateTime.now());
        setState(() {
          this._loading = false;
        });
      }, (err) {
        print(err);
        this._refreshController.refreshFailed();
        setState(() {
          this._loading = false;
        });
      });
    });
  }



  @override
  void initState() {
    this._userInfo = Global.userInfo;
    this._listRepairOrderFuture = this._listRepairOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._listRepairOrderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ProgressDialog(
          loading: this._loading,
          child: CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: UserInfoWidget(
                      userInfo: this._userInfo,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Color.fromRGBO(231, 233, 234, 1),
                      child: CupertinoScrollbar(
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: true,
                          header: WaterDropHeader(complete: Text("刷新成功"), failed: Text("刷新失败"),),
                          onRefresh: onHeaderRefresh,
                          child: ListView.custom(
                            childrenDelegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return new OrderCardWidget(
                                  title: this._list[index].QMTXT ?? '',
                                  level: (this._list[index].COLORS == null || this._list[index].COLORS == "") ? "" :"${this._levelMap[this._list[index].COLORS]}级",
                                  status: this._list[index].ASTTX ?? '',
                                  description: this._list[index].QMTXT ?? '',
                                  position: this._list[index].PLTXT ?? '',
                                  device: this._list[index].EQKTX ?? '',
                                  color: this._list[index].COLORS,
                                  isStop: this._list[index].isStop,
                                  order: this._list[index],
                                  onTap: () {
                                    Navigator.of(widget.rootContext).push(
                                        CupertinoPageRoute(builder: (context) {
                                      return RepairOrderPage(
                                        order: this._list[index],
                                      );
                                    })).then((val) {
//                                      this._refreshController.requestRefresh();
//                                      this._listRepairOrder();
                                    });
                                  },
                                );
                              },
                              childCount: this._list?.length ?? 0 + 1,
                            ),
                            shrinkWrap: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
