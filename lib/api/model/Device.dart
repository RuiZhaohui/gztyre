class Device {
//  String EQUNR;
//  String EQKTX;
  int id;
  String parentCode;
  String positionCode;
  String deviceCode;
  String deviceName;
//  List<Device> childrenDevice;
  List<Device> children;

  Device();

  Device.formJson(Map<String, dynamic> json)
      : id = json['id'],
        parentCode = json['parentCode'],
        positionCode = json['positionCode'],
        deviceCode = json['deviceCode'],
        deviceName = json['deviceName'],
        children = json['children'].length == 0 ? [] : List<Device>.from(json['children'].map((item) {
          return Device.formJson(item);
        }).toList());
}