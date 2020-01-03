import 'package:flutter/cupertino.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:gztyre/api/HttpRequest.dart';
import 'package:gztyre/api/model/Order.dart';
import 'package:gztyre/api/model/UserInfo.dart';
import 'package:gztyre/commen/Global.dart';
import 'package:gztyre/components/OrderCardLiteWidget.dart';
import 'package:gztyre/components/ProgressDialog.dart';
import 'package:gztyre/pages/orderCenter/planOrder/OrderDetailPage.dart';

class OrderListPage extends StatefulWidget {
  OrderListPage({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  State createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  var _listOrderFuture;

  bool _loading = false;
  UserInfo _userInfo;
  List<Order> _list;
  List<String> _managerList = [
    "A04", "A05", "A06", "A07", "A08"
  ];
  bool _isManager = false;
  Map<String, String> _levelMap = {
    "A": "1",
    "B": "2",
    "C": "3",
    "D": "4"
  };


  bool _isRepairing = false;

  _listHistoryOrder() async {
    this._loading = true;
    this._list = [];
    return await HttpRequest.historyOrder(this._userInfo.PERNR, this._userInfo.WCTYPE == "是" ? "X" : "", (List<Order> list) {
      this._list = list;
      setState(() {
        this._loading = false;
      });
    }, (err) {
      print(err);
      setState(() {
        this._loading = false;
      });
    });
  }

  _listOrder(bool isManager) async {
    this._loading = true;
    this._list = [];
    return await HttpRequest.listPlanOrder(
        this._userInfo.PERNR, this._userInfo.CPLGR, this._userInfo.MATYP, this._userInfo.SORTB, "X", null, "ZPM1", Global.maintenanceGroup, (List<Order> list) {
      this._isRepairing = false;
      list.forEach((item) {
        if (item.QMNUM != null &&
            item.QMNUM != '' &&
            (item.PERNR1 == _userInfo.PERNR ) &&
            (item.APPSTATUS == "接单" || item.APPSTATUS == "转单" || (item.APPSTATUS == "呼叫协助") || (item.APPSTATUS == "加入"))) {
          this._isRepairing = true;
        }
      });

      if (widget.title == "新工单") {
        list.forEach((item) {
          if (item.QMNUM != null &&
              item.QMNUM != '' &&
              (item.APPSTATUS == "" || item.ASTTX == "新建" || item.ASTTX == "新工单")) {
            this._list.add(item);
          }
        });
      } else if (widget.title == "转卡单") {
        list.forEach((item) {
          if (item.QMNUM != null &&
              item.QMNUM != '' &&
              item.APPSTATUS == "转卡") {
            this._list.add(item);
          }
        });
      } else if (widget.title == "维修中") {
      list.forEach((item) {
        if (item.QMNUM != null &&
            item.QMNUM != '' &&
            (isManager ? true : item.PERNR1 == _userInfo.PERNR ) && item.ASTTX == "维修中" &&
            (item.APPSTATUS == "接单" || item.APPSTATUS == "转单" || item.APPSTATUS == "呼叫协助" || item.APPSTATUS == "加入")) {
          this._list.add(item);
        }
      });
      } else if (widget.title == "等待中") {
        list.forEach((item) {
          if (item.QMNUM != null &&
              item.QMNUM != '' &&
              (item.APPSTATUS == "等待" &&  (isManager ? true : item.PERNR1 == _userInfo.PERNR )  || item.APPSTATUS == "再维修" || item.APPSTATUS == "派单")) {
            this._list.add(item);
          }
        });
      } else if (widget.title == "协助单") {
        list.forEach((item) {
          if (item.QMNUM != null &&
              item.QMNUM != '' &&
              (item.APPSTATUS == "呼叫协助" || item.APPSTATUS == "加入") &&
              item.PERNR1 != _userInfo.PERNR) {
            this._list.add(item);
          }
        });
      }
//      else if (widget.title == "历史单") {
//        list.forEach((item) {
//          if (item.QMNUM != null &&
//              item.QMNUM != '' &&
//              (item.APPSTATUS == "完工" || item.APPSTATUS == "确认")
//          && (isManager ? true : item.PERNR1 == _userInfo.PERNR )) {
//            this._list.add(item);
//          }
//        });
//      }
      setState(() {
        this._loading = false;
      });
    }, (err) {
      print(err);
      setState(() {
        this._loading = false;
      });
    });
  }

  Future<Null> onHeaderRefresh() async {
//    this._list = [];

    return this._listOrderFuture = widget.title == "历史单" ? await this._listHistoryOrder() : await this._listOrder(this._isManager);
  }

  @override
  void initState() {
    this._userInfo = Global.userInfo;
    this._isManager = this._managerList.any((item) => item == this._userInfo.SORTB);
    this._listOrderFuture = widget.title == "历史单" ? this._listHistoryOrder() : this._listOrder(this._isManager);
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._listOrderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ProgressDialog(
          loading: this._loading,
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.pop(context),
                color: Color.fromRGBO(94, 102, 111, 1),
              ),
              middle: Text(widget.title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,),
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Color.fromRGBO(231, 233, 234, 1),
                      child: CupertinoScrollbar(
                        child: Refresh(
                          onFooterRefresh: null,
                          onHeaderRefresh: onHeaderRefresh,
                          child: ListView.custom(
                            childrenDelegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return new OrderCardLiteWidget(
                                  color: this._list[index].COLORS,
                                  title: this._list[index].QMTXT ?? '',
                                  level: (this._list[index].COLORS == null || this._list[index].COLORS == "") ? "" :"${this._levelMap[this._list[index].COLORS]}级",
                                  status: this._list[index].ASTTX ?? '',
                                  position: this._list[index].PLTXT ?? '',
                                  device: this._list[index].EQKTX ?? '',
                                  isStop: true,
                                  order: this._list[index],
                                  onTap: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          settings: RouteSettings(name: "orderDetailPage"),
                                            builder: (BuildContext context) {
                                      return OrderDetailPage(
                                          order: this._list[index], itemStatus: widget.title, isRepairing: this._isRepairing,);
                                    })).then((val) {
                                      setState(() {
                                        widget.title == "历史单" ? this._listHistoryOrder() : this._listOrder(this._isManager);
                                      });
                                    });
                                  },
                                );
                              },
                              childCount: this._list.length,
                            ),
                            shrinkWrap: true,
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