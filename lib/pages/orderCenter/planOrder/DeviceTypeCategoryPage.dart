import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gztyre/api/HttpRequest.dart';
import 'package:gztyre/api/model/DeviceTypeDetail.dart';
import 'package:gztyre/api/model/UserInfo.dart';
import 'package:gztyre/commen/Global.dart';
import 'package:gztyre/components/Badge.dart';
import 'package:gztyre/components/ListItemWidget.dart';
import 'package:gztyre/components/ProgressDialog.dart';
import 'package:gztyre/pages/orderCenter/planOrder/OrderListPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DeviceTypeCategoryPage extends StatefulWidget {
  DeviceTypeCategoryPage({Key key, @required this.title, @required this.ilart})
      : assert(title != null), assert(ilart != null),
        super(key: key);

  final String title;
  final String ilart;

  @override
  State createState() => _DeviceTypeCategoryPageState();
}

class _DeviceTypeCategoryPageState extends State<DeviceTypeCategoryPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  var _listOrderFuture;

  bool _loading = false;
  UserInfo _userInfo;
  List<DeviceTypeDetail> _list;

  Map<String, String> statusMap = {"新工单": "新建", "转卡单": "转卡单", "维修中": "维修中", "等待中": "等待中", "协助单": "呼叫协助", "历史单": "历史单"};
  String _ASTTX = "";
  String _ILART = "";

  _listOrder(String ASTTX, String AUART, String ILART) async {
    if (this.mounted) {
      setState(() {
        this._loading = true;
      });
    }
    this._list = [];
    return await HttpRequest.listPlanOrderDeviceType(Global.userInfo.PERNR, _userInfo.WCTYPE == "是" ? "X" : "", ASTTX, AUART, ILART, Global.maintenanceGroup, (t) {
      this._refreshController.refreshCompleted();
      if (this.mounted) {
        setState(() {
          _list = t;
          this._loading = false;
        });
      }
    }, (err) {
      this._refreshController.refreshFailed();
      if (this.mounted) {
        setState(() {
          this._loading = false;
        });
      }
    });
  }

  Future<Null> onHeaderRefresh() async {
    this._list = [];
    return await _listOrder(_ASTTX, "ZPM2", _ILART);
  }

  @override
  void initState() {
    _ASTTX = statusMap[widget.title];
    _ILART = widget.ilart;
    this._userInfo = Global.userInfo;
    this._listOrderFuture = this._listOrder(_ASTTX, "ZPM2", _ILART);
    setState(() {});
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
              middle:
              Text("订单中心", style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Color.fromRGBO(231, 233, 234, 1),
                      child: CupertinoScrollbar(
                        child: SmartRefresher(
                          controller: _refreshController,
                          header:  WaterDropHeader(complete: Text("刷新成功"), failed: Text("刷新失败"),),
                          enablePullDown: true,
                          onRefresh: onHeaderRefresh,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _list == null ? 0 : _list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListItemWidget(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.lens, color: Colors.black,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          _list[index].EQKTX,
                                          style: TextStyle(fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new CupertinoPageRoute(
//                                            settings:
//                                            RouteSettings(name: "repairList"),
                                            builder: (BuildContext context) {
                                              return OrderListPage(
                                                title: widget.title,
                                                ilart: widget.ilart,
                                                equnr: _list[index].EQUNR,
                                              );
                                            })).then((val) {
                                      this._listOrder(_ASTTX, "ZPM2", _ILART);
                                    });
                                  },
                                  actionArea: Row(
                                    children: <Widget>[
                                      this._list[index].QUANTITY != null && this._list[index].QUANTITY != "0"
                                          ? Badge(
                                        child: Text(
                                          this
                                              ._list[index].QUANTITY,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        color: Colors.red,
                                      )
                                          : Container(),
                                      Icon(
                                        CupertinoIcons.right_chevron,
                                        color: Color.fromRGBO(94, 102, 111, 1),
                                      )
                                    ],
                                  ),
                                );
                              }
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
