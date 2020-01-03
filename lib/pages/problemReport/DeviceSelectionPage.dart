import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gztyre/api/HttpRequest.dart';
import 'package:gztyre/api/HttpRequestRest.dart';
import 'package:gztyre/api/model/Device.dart';
import 'package:gztyre/api/model/FunctionPosition.dart';
import 'package:gztyre/commen/Global.dart';
import 'package:gztyre/components/ListItemSelectWidget.dart';
import 'package:gztyre/components/ListItemWidget.dart';
import 'package:gztyre/components/ListTitleWidget.dart';
import 'package:gztyre/components/ProgressDialog.dart';
import 'package:gztyre/components/SearchBar.dart';
import 'package:gztyre/components/TextButtonWidget.dart';
import 'package:gztyre/pages/orderCenter/planOrder/MaterielPage.dart';
import 'package:gztyre/pages/problemReport/ChildrenDeviceSelectionPage.dart';
import 'package:gztyre/pages/problemReport/ChildrenPositonSelectionPage.dart';

class DeviceSelectionPage extends StatefulWidget {
  DeviceSelectionPage(
      {Key key,
      @required this.selectItem,
      this.isAddMaterial = false,
      this.AUFNR})
      : super(key: key);

  final Device selectItem;
  final bool isAddMaterial;
  final String AUFNR;

  @override
  State createState() => _DeviceSelectionPageState();
}

class _DeviceSelectionPageState extends State<DeviceSelectionPage> {
  Device _selectItem;

//  FunctionPosition _selectPosition;

  bool _loading = false;

  List<FunctionPosition> _position = [];
  List<FunctionPosition> _tempPosition = [];

  var _listPositionAndDeviceFuture;

  TextEditingController _shiftController = new TextEditingController();

  _listPositionAndDevice() async {
    this._loading = true;
    HttpRequestRest.listPosition(Global.userInfo.PERNR,
        (List<FunctionPosition> list) {
      print(list);
      this._position = list;
      this._tempPosition.addAll(list);
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

//  List<Widget> createDeviceWidgetList(List<Device> list) {
//    List<Widget> deviceList = [];
//    list.forEach((item) {
//      if (item.children.length > 0) {
//        deviceList.add(ExpansionTile(
//          leading: Checkbox(value: this._selectItem == item, onChanged: (bool val)
//            {
//              if (val) {
//                this._selectItem = item;
//                setState(() {
//                });
//              } else {
//                this._selectItem = null;
//                setState(() {
//                });
//              }
//            }
//          ),
//          title: Text(item.deviceName),
//          children: <Widget>[
//            ...createDeviceWidgetList(item.children)
//          ],
//        ));
//      } else {
//        deviceList.add(GestureDetector(
//          child: ListTile(
////            actionArea: Container(),
//              title: Row(
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.only(left: 10),
//                    child: Checkbox(value: this._selectItem == item, onChanged: (bool val) {
//                      if (val) {
//                        this._selectItem = item;
//                        setState(() {
//
//                        });
//                      } else {
//                        this._selectItem = null;
//                        setState(() {
//
//                        });
//                      }
//                    },),
//                  ),
//                  Expanded(
//                    child: Text(
//                      item.deviceName,
//                    ),
//                  )
//                ],
//              )),
//          onTap: () {
//            if (this._selectItem == item) {
//              this._selectItem = null;
//            } else
//              this._selectItem = item;
//            setState(() {});
//          },
//        ));
//      }
//    });
//    return deviceList;
//  }
//
//  List<Widget> createWidgetList(List<FunctionPosition> list) {
//    List<Widget> deviceList = [];
//    list.forEach((item) {
//      if (item.children.length > 0) {
//        deviceList.add(
//            Material(
//              child: ExpansionTile(
//                title: Text(item.positionName),
//                children: <Widget>[
//                  ...createWidgetList(item.children)
//                ],
//              ),
//            )
//        );
//      } else {
//        deviceList.add(Material(
//          child: ExpansionTile(
//            title: Text(item.positionName),
//            children: <Widget>[
//              ...createDeviceWidgetList(item.deviceChildren)
//            ],
//          ),
//        ));
//      }
//    });
//    return deviceList;
//  }

  List<Widget> createWidgetList(List<FunctionPosition> list) {
    List<Widget> deviceList = [];
    list.forEach((item) {
//      if (item.children.length > 0) {
        deviceList.add(ListItemWidget(
            title: Text(item.positionName),
          onTap: () {
              if (item.children.length > 0) {
                Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) {
                  return ChildrenPositionSelectionPage(position: item.children, selectItem: widget.selectItem, isAddMaterial: widget.isAddMaterial, AUFNR: widget.AUFNR,);
                })).then((val) {
                  if (val["isOk"]) {
                    this._selectItem = val["item"];
                    Navigator.of(context).pop(val);
                  }
                });
              } else if (item.deviceChildren.length > 0) {

                Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) {
                  return ChildrenDeviceSelectionPage(device: item.deviceChildren, selectItem: widget.selectItem, isAddMaterial: widget.isAddMaterial, AUFNR: widget.AUFNR,);
                })).then((val) {
                  if (val["isOk"]) {
                    this._selectItem = val["item"];
                    Navigator.of(context).pop(val);
                  }
                });
              }
          },
          ),
        );
//      } else {
//        deviceList.add(Material(
//          child: ExpansionTile(
//            title: Text(item.positionName),
//            children: <Widget>[...createDeviceWidgetList(item.deviceChildren)],
//          ),
//        ));
//      }
    });
    return deviceList;
  }

  @override
  void initState() {
    this._selectItem = widget.selectItem;
    _listPositionAndDeviceFuture = this._listPositionAndDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: FutureBuilder(
            future: _listPositionAndDeviceFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ProgressDialog(
                  loading: this._loading,
                  child: CupertinoPageScaffold(
                    navigationBar: new CupertinoNavigationBar(
                      leading: CupertinoNavigationBarBackButton(
                        onPressed: () {
                          Navigator.of(context).pop({"item": widget.selectItem, "isOk": false});
                        },
                        color: Color.fromRGBO(94, 102, 111, 1),
                      ),
                      middle: Text(
                        "选择设备",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
//                      trailing: TextButtonWidget(
//                        onTap: () {
//                          if (widget.isAddMaterial) {
//                            Navigator.of(context).push(CupertinoPageRoute(
//                                builder: (BuildContext context) {
//                              return MaterielPage(
//                                list: null,
//                                AUFNR: widget.AUFNR,
//                                device: this._selectItem,
//                              );
//                            })).then((val) {
//                              Navigator.of(context).pop();
//                            });
//                          }
//                        },
//                        text: "确定",
//                      ),
                    ),
                    child: SafeArea(
                        child: CupertinoScrollbar(
                            child: ListView(
                      children: <Widget>[
//                                SearchBar(controller: this._shiftController),
                        ...createWidgetList(this._position),
                      ],
                    ))),
                  ));
            }),
        onWillPop: () async {
          Navigator.of(context).pop(this._selectItem);
          return false;
        });
  }
}
