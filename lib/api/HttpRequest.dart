import 'package:dio/dio.dart';
import 'package:gztyre/api/model/Device.dart';
import 'package:gztyre/api/model/DeviceTypeDetail.dart';
import 'package:gztyre/api/model/Materiel.dart';
import 'package:gztyre/api/model/Order.dart';
import 'package:gztyre/api/model/ProblemDescription.dart';
import 'package:gztyre/api/model/RepairHistory.dart';
import 'package:gztyre/api/model/RepairOrder.dart' as prefix0;
import 'package:gztyre/api/model/RepairType.dart';
import 'package:gztyre/api/model/RepairTypeDetail.dart';
import 'package:gztyre/api/model/ReportOrder.dart';
import 'package:gztyre/api/model/SubmitMateriel.dart';
import 'package:gztyre/api/model/UserInfo.dart';
import 'package:gztyre/api/model/WorkShift.dart';
import 'package:gztyre/api/model/Worker.dart';
import 'package:gztyre/commen/Global.dart';
import 'package:gztyre/utils/XmlUtils.dart';

class HttpRequest {

  static Dio getHttp() {
    Dio http = new Dio(BaseOptions(
      headers: Global.secret,
      baseUrl: Global.sapUrl,
      connectTimeout: 60 * 1000,));
    http.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print('请求地址为：' + options.path);
      print('请求参数为：' + options.data.toString());
      print('开始时间为：' + DateTime.now().toString());
      // Do something before request is sent
      return options; //continue
    }, onResponse: (Response response) {
      print('结束时间为：' + DateTime.now().toString());
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) {
      // Do something with response error
      return e; //continue
    }));
    return http;
  }

  /// 查询用户信息
  static searchUserInfo(String userId, Function(UserInfo t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildUserInfoXml(userId);
    try {
      Response response = await getHttp().post(
          "/zpm_search_pernr/888/zpm_search_pernr/zpm_search_pernr",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readUserInfoXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出所有工作中心
  static listWorkShift(String PERNR, Function(List<WorkShift> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildWorkShiftXml(PERNR);
    try {
      Response response = await getHttp().post(
          "/zpm_search_ingrp/888/zpm_search_ingrp/zpm_search_ingrp",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readWorkShiftXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出所有工单
  static listOrder(
      String PERNR,
      String CPLGR,
      String MATYP,
      String SORTB,
      String WCTYPE,
      String ASTTX,
      List<String> ItWxfz,
      Function(List<Order> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildOrderXml(
        PERNR, CPLGR, MATYP, SORTB, WCTYPE, ASTTX, ItWxfz);
    try {
      print(DateTime.now());
      Response response = await getHttp().post(
          "/zpm_search_order/888/zpm_search_order/zpm_search_order",
          data: xml,
          options: Options(contentType: 'text/xml'));
      print(DateTime.now());
      return await onSuccess(XmlUtils.readOrderXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出所有非计划性维修工单
  static listNoPlanOrder(
      String PERNR,
      String CPLGR,
      String MATYP,
      String SORTB,
      String WCTYPE,
      String ASTTX,
      String AUART,
      List<String> ItWxfz,
      Function(List<Order> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildNoPlanOrderXml(
        PERNR, CPLGR, MATYP, SORTB, WCTYPE, ASTTX, AUART, ItWxfz);
    try {
      Response response = await getHttp().post(
          "/zpm_search_order_zpm1/888/zpm_search_order_zpm1/zpm_search_order_zpm1",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readNoPlanOrderXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出所有计划性维修工单
  static listPlanOrder(
      String PERNR,
      String CPLGR,
      String MATYP,
      String SORTB,
      String WCTYPE,
      String ASTTX,
      String AUART,
      List<String> ItWxfz,
      Function(List<Order> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildPlanOrderXml(
        PERNR, CPLGR, MATYP, SORTB, WCTYPE, ASTTX, AUART, ItWxfz);
    try {
      Response response = await getHttp().post(
          "/zpm_search_order_zpm2/888/zpm_search_order_zpm2/zpm_search_order_zpm2",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readPlanOrderXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出固定工单类型下计划性维修工单种类及数量
  static listPlanOrderType(
      String PERNR,
      String WCTYPE,
      String ASTTX,
      String AUART,
      List<String> ItWxfz,
      Function(List<RepairTypeDetail> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildPlanOrderTypeXml(PERNR, WCTYPE, ASTTX, AUART, ItWxfz);
    try {
      Response response = await getHttp().post(
          "/zpm_search_jh_order/888/zpm_search_jh_order/zpm_search_jh_order",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readPlanOrderTypeXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出固定工单类型下计划性维修设备种类及数量
  static listPlanOrderDeviceType(
      String PERNR,
      String WCTYPE,
      String ASTTX,
      String AUART,
      String ILART,
      List<String> ItWxfz,
      Function(List<DeviceTypeDetail> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildPlanOrderDeviceTypeXml(
        PERNR, WCTYPE, ASTTX, AUART, ILART, ItWxfz);
    try {
      Response response = await getHttp().post(
          "/zpm_search_jh_equ_order/888/zpm_search_jh_equ_order/zpm_search_jh_equ_order",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(
          XmlUtils.readPlanOrderDeviceTypeXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出固定工单类型、设备种类下计划性订单
  static listPlanOrderByDeviceTypeAndOrderType(
      String PERNR,
      String WCTYPE,
      String ASTTX,
      String AUART,
      String ILART,
      String EQUNR,
      List<String> ItWxfz,
      Function(List<Order> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildPlanOrderByDeviceTypeAndOrderTypeXml(
        PERNR, WCTYPE, ASTTX, AUART, ILART, EQUNR, ItWxfz);
    try {
      Response response = await getHttp().post(
          "/zpm_search_jhwx_order/888/zpm_search_jhwx_order/zpm_search_jhwx_order",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(
          XmlUtils.readPlanOrderByDeviceTypeAndOrderTypeXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出所有组织维修工单
  static listAssisantOrder(
      String PERNR,
      String CPLGR,
      String MATYP,
      String SORTB,
      String WCTYPE,
      String ASTTX,
      String AUART,
      List<String> ItWxfz,
      Function(List<Order> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildAssisantOrderXml(
        PERNR, CPLGR, MATYP, SORTB, WCTYPE, ASTTX, AUART, ItWxfz);
    try {
      Response response = await getHttp().post(
          "/zpm_search_order_zpm3/888/zpm_search_order_zpm3/zpm_search_order_zpm3",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readAssisantOrderXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出所有备件维修工单
  static listBlockOrder(
      String PERNR,
      String CPLGR,
      String MATYP,
      String SORTB,
      String WCTYPE,
      String ASTTX,
      String AUART,
      List<String> ItWxfz,
      Function(List<Order> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildBlockOrderXml(
        PERNR, CPLGR, MATYP, SORTB, WCTYPE, ASTTX, AUART, ItWxfz);
    try {
      Response response = await getHttp().post(
          "/zpm_search_order_zpm4/888/zpm_search_order_zpm4/zpm_search_order_zpm4",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readBlockOrderXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 报修单详情
  static reportOrderDetail(String QMNUM, Function(ReportOrder t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildReportOrderDetailXml(QMNUM);
    try {
      Response response = await getHttp().post(
          "/zpm_search_ordermess/888/zpm_search_ordermess/zpm_search_ordermess",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readReportOrderDetailXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 工单维修记录
  static repairOrderHistory(
      String AUFNR,
      Function(List<RepairHistory> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildRepairOrderHistoryXml(AUFNR);
    try {
      Response response = await getHttp().post(
          "/zpm_search_wxrec/888/zpm_search_wxrec/zpm_search_wxrec",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readRepairOrderHistoryXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 维修单详情
  static repairOrderDetail(
      String AUFNR,
      Function(prefix0.RepairOrder t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildRepairOrderDetailXml(AUFNR);
    try {
      Response response = await getHttp().post(
          "/zpm_search_info/888/zpm_search_info/zpm_search_info",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readRepairOrderDetailXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 维修单其他设备查询
  static otherDevice(String AUFNR, Function(List<Device> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildOtherDeviceXml(AUFNR);
    try {
      Response response = await getHttp().post(
          "/zpm_search_info/888/zpm_search_info/zpm_search_info",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readOtherDeviceXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出所有维修类型
  static listRepairType(Function(List<RepairType> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildRepairTypeXml();
    try {
      Response response = await getHttp().post(
          "/zpm_search_ilart/888/zpm_search_ilart/zpm_search_ilart",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readRepairTypeXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 列出所有问题描述
  static listProblemDescription(
      String type,
      Function(List<ProblemDescription> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildProblemDescriptionXml(type);
    try {
      Response response = await getHttp().post(
          "/zpm_search_katalogart/888/zpm_search_katalogart/zpm_search_katalogart",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readProblemDescriptionXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 创建通知单
  static createReportOrder(
      String PERNR,
      String INGRP,
      String ILART,
      String EQUNR,
      String TPLNR,
      String FEGRP,
      String FECOD,
      String FETXT,
      String CPLGR,
      String MATYP,
      String MSAUS,
      String APPTRADENO,
      Function(Map<String, String> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildReportOrderXml(PERNR, INGRP, ILART, EQUNR, TPLNR,
        FEGRP, FECOD, FETXT, CPLGR, MATYP, MSAUS, APPTRADENO);
    try {
      print(DateTime.now());
      Response response = await getHttp().post(
          "/zpm_create_iw21/888/zpm_create_iw21/zpm_create_iw21",
          data: xml,
          options: Options(contentType: 'text/xml'));
      print(DateTime.now());
      return await onSuccess(XmlUtils.readReportOrderXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 创建维修单
  static createRepairOrder(
      String PERNR,
      String INGRP,
      String ILART,
      String QUNUM,
      String EQUNR,
      String TPLNR,
      String FEGRP,
      String FECOD,
      String FETXT,
      String CPLGR,
      String MATYP,
      String MSAUS,
      String APPTRADENO,
      String BAUTL,
      int GAMNG,
      Function(String AUFNR) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildRepairOrderXml(
        PERNR,
        INGRP,
        ILART,
        QUNUM,
        EQUNR,
        TPLNR,
        FEGRP,
        FECOD,
        FETXT,
        CPLGR,
        MATYP,
        MSAUS,
        APPTRADENO,
        BAUTL,
        GAMNG);
    try {
      Response response = await getHttp().post(
          "/zpm_create_order/888/zpm_create_order/zpm_create_order",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readRepairOrderXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 更改工单状态
  /// APPSTATUS 为改变状态的动作
  /// todo 再维修有返回值
  static changeOrderStatus(
      String PERNR,
      String QMNUM,
      String AUFNR,
      String APPSTATUS,
      String APPTRADENO,
      String URGRP,
      String URCOD,
      String EQUNR,
      String KTEXT,
      List<Worker> list,
      Function(bool t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildChangeOrderXml(PERNR, QMNUM, AUFNR, APPSTATUS,
        APPTRADENO, URGRP, URCOD, EQUNR, KTEXT, list);
    try {
      Response response = await getHttp().post(
          "/zpm_change_order_status/888/zpm_change_order_status/zpm_change_order_status",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readChangeOrderXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 委外维修
  static outerRepair(String AUFNR, String PERNR, Function(bool t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildOuterRepairXml(AUFNR, PERNR);
    try {
      Response response = await getHttp().post(
          "/zpm_change_ww/888/zpm_change_ww/zpm_change_ww",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readOuterRepairXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 确认完工
  static completeOrder(
      String PERNR,
      String AUFNR,
      String APPSTATUS,
      String APPTRADENO,
      Function(bool t) onSuccess,
      Function(DioError err) onError) async {
    var xml =
        XmlUtils.buildCompleteOrderXml(PERNR, AUFNR, APPSTATUS, APPTRADENO);
    try {
      Response response = await getHttp().post(
          "/zpm_order_confirm/888/zpm_order_confirm/zpm_order_confirm",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readCompleteOrderXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 查询设备BOM及备件库库存接口
  static searchBom(String EQUNR, Function(List<Materiel> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildSearchBomXml(EQUNR);
    try {
      Response response = await getHttp().post(
          "/zpm_search_bom/888/zpm_search_bom/zpm_search_bom",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readSearchBomXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 查询维修工列表
  static searchWorker(String PERNR, Function(List<Worker> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildWorkerXml(PERNR);
    try {
      Response response = await getHttp().post(
          "/zpm_search_wcg/888/zpm_search_wcg/zpm_search_wcg",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readWorkerXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 查询维修工列表
  static searchWorkerByWCPLGR(
      String QMNUM,
      String WCPLGR,
      Function(List<Worker> t) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildWorkerByWCPLGRXml(QMNUM, WCPLGR);
    try {
      Response response = await getHttp().post(
          "/zpm_search_wcgqy/888/zpm_search_wcgqy/zpm_search_wcgqy",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readWorkerXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 维修工单添加物料
  static addMateriel(
      String AUFNR,
      String MATNR,
      String MAKTX,
      int MENGE,
      String EQUNR,
      Function(bool) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildAddMaterielXml(AUFNR, MATNR, MAKTX, MENGE, EQUNR);
    try {
      Response response = await getHttp().post(
          "/zpm_change_components/888/zpm_change_components/zpm_change_components",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readAddMaterielXml(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 历史订单接口
  static historyOrder(String PERNR, String WCTYPE,
      Function(List<Order>) onSuccess, Function(DioError err) onError) async {
    var xml = XmlUtils.buildHistoryOrder(PERNR, WCTYPE);
    try {
      Response response = await getHttp().post(
          "/zpm_search_order_history/888/zpm_search_order_history/zpm_search_order_history",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readHistoryOrder(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 工单需求物料数量查询
  static searchMaterialTemp(
      String AUFNR,
      Function(List<SubmitMateriel>) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildMaterialTemp(AUFNR);
    try {
      Response response = await getHttp().post(
          "/zpm_search_wxrec_temp/888/zpm_search_wxrec_temp/zpm_search_wxrec_temp",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readMaterialTemp(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }

  /// 协助单所有已加入人员查询
  static listHelpWorker(
      String AUFNR,
      Function(List<String>) onSuccess,
      Function(DioError err) onError) async {
    var xml = XmlUtils.buildHelpWorker(AUFNR);
    try {
      Response response = await getHttp().post(
          "/zpm_search_order_jr_pernr/888/zpm_search_order_jr_pernr/zpm_search_order_jr_pernr",
          data: xml,
          options: Options(contentType: 'text/xml'));
      return await onSuccess(XmlUtils.readHelpWorker(response.data));
    } on DioError catch (e) {
      return await onError(e);
    }
  }
}
