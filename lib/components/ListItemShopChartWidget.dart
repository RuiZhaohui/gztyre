import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnChangeCallBack(int val);
typedef OnDeleteCallBack();

class ListItemShopChartWidget extends StatefulWidget {
  ListItemShopChartWidget(
      {Key key, @required this.onDelete, @required this.onChange, @required this.title, this.height, this.number})
      : super(key: key);

  final OnChangeCallBack onChange;
  final OnDeleteCallBack onDelete;
  final Widget title;
  final double height;
  final int number;

  @override
  State createState() {
    return _ListItemShopChartWidgetState();
  }
}

class _ListItemShopChartWidgetState extends State<ListItemShopChartWidget> {
  TextEditingController _controller = new TextEditingController();

  Color _color = Color.fromRGBO(255, 255, 255, 0);

  @override
  void initState() {
    widget.number == null ? this._controller.text = "0" : this._controller.text = widget.number.toString();
    this._controller.addListener(() {
        try {
          widget.onChange(int.parse(this._controller.text));
        } catch (e) {
          this._controller.text = '0';
        }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _color),
      height: widget.height ?? 50.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: widget.title,
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                  onTap: () {
                    if (int.parse(this._controller.text) > 0) {
                      this._controller.text =
                          (int.parse(this._controller.text) - 1).toString();
                      setState(() {});
                    }
                  },
                ),
                Container(
                  child: CupertinoTextField(
                    controller: this._controller,
                    textAlign: TextAlign.center,
                  ),
                  width: 60,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onTap: () {
                    this._controller.text =
                        (int.parse(this._controller.text) + 1).toString();
                    setState(() {});
                  },
                ),
                GestureDetector(
                  child: Padding(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.only(left: 20),
                  ),
                  onTap: () {
                    widget.onDelete();
                  },
                )
              ],
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
