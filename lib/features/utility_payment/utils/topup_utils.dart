import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/utility_payment/enums/topup_type.dart';

class TopUpUtils {
  String getTopUpServiceType({required TopupType type}) {
    if (type == TopupType.NTCPostpaid) {
      return "ntc_postpaid_topup";
    } else if (type == TopupType.NTCPrepaid) {
      return "ntc_prepaid_topup";
    } else if (type == TopupType.Ncell) {
      return "ncell_prepaid_topup";
    } else {
      return "";
    }
  }

  ServiceList getTopUpServiceImage({
    required String type,
    required CategoryList categories,
  }) {
    final serviceType = categories.services.where(
      (element) => element.uniqueIdentifier == type,
    );
    return serviceType.first;
  }
}
