import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gztyre/api/model/Order.dart';
import 'package:gztyre/api/model/RepairOrder.dart';
import 'package:gztyre/api/model/ReportOrder.dart';

class OrderInfoWidget extends StatelessWidget {
  OrderInfoWidget({Key key, this.order, this.reportOrder, this.repairOrder}): super(key: key);

  final ReportOrder reportOrder;
  final RepairOrder repairOrder;
  final Order order;


  String _getTime(String date, String time) {
    return "${date.substring(2, 10)} ${time.substring(0, 5)}";
  }

  @override
  Widget build(BuildContext context) {
    String _accept = '无';
    String _complete = '无';

    if (order.ERDAT2 == "0000-00-00") {
      _accept = "无";
    } else {
      _accept =
          this._getTime(order.ERDAT2, order.ERTIM2);
    }
    if (order.ERDAT3 == "0000-00-00" ||
        order.ERDAT3 + order.ERTIM3 ==
            order.ERDAT2 + order.ERTIM2) {
      _complete = "无";
    } else {
      _complete =
          this._getTime(order.ERDAT3, order.ERTIM3);
    }


    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, top: 6, bottom: 6, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: order.QMNUM != "" && order.QMNUM != null ? Text("报修单号：${order.QMNUM}", style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.45),
                    fontSize: 12,),) : Container(),
                ),
                Expanded(
                  child: order.AUFNR != "" && order.AUFNR != null ? Text("维修单号：${order.AUFNR}", style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.45),
                    fontSize: 12,),) : Container(),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Text('接   单   人：${order.PERNR1 == '' || order.PERNR1 == null ? '无' : order.PERNR1}', style: TextStyle(fontSize: 14),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Text('接单时间：$_accept', style: TextStyle(fontSize: 14),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Text('功能位置：${order.PLTXT ?? '无'}', style: TextStyle(fontSize: 14),),
                      ),
                    ],
                  ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only( right: 10, top: 10),
                      child: Text('工单进度：${order.ASTTX ?? '无'}', style: TextStyle(fontSize: 14),),
                    ),
                    Padding(
                      padding: EdgeInsets.only( right: 10, top: 10),
                      child: Text('完工时间：$_complete', style: TextStyle(fontSize: 14),),
                    ),
                    Padding(
                      padding: EdgeInsets.only( right: 10, top: 10),
                      child: Text('是否停机：${reportOrder.MSAUS == true ? '是' : "否"}', style: TextStyle(fontSize: 14),),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            child: Text('故障设备：${order.EQKTX ?? '无'}', style: TextStyle(fontSize: 14),),
          )
        ],
      ),
    );
  }
}
