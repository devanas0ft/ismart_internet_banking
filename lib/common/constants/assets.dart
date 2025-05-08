import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/models/coop_config.dart';

class Assets {
  static String logoImage =
      RepositoryProvider.of<CoOperative>(
        NavigationService.context,
      ).coOperativeLogo;

  // static const String logoImage = "assets/ismartlogo.png";
  static const String splashImage = "assets/images/splashscreen.jpg";

  static const String fingerPrintImage = "assets/icons/fingerprint_setup.svg";
  static const String translateImage = "assets/icons/languagetranslate.svg";
  static const String groupIcon = "assets/icons/Group 1035.svg";
  static const String verify = "assets/icons/verify your number.svg";
  static const String loader = "assets/icons/ismart_loader_test2.gif";

  static const String profilePicture = "assets/images/profile.png";
  static const String femaleProfilePicture = 'assets/images/femaleProfile.png';
  // static const String profilePicture =
  //     "assets/images/184451271-senior-man-avatar-smiling-elderly-man-with-beard-with-gray-hair-3d-vector-people-character-illustrat 1.png";
  static const String ismartLogo = "assets/ismartlogo.png";

  static const String notificationIcon = "assets/icons/Notification.svg";
  static const String marketPlaceIcon = "assets/icons/marketplace_icon.svg";
  static const String movieSeatIcon = "assets/icons/movie_seat.svg";
  static const String downloadBorderIcon = "assets/icons/download_border.svg";

  static const String searchIcon = "assets/icons/search.svg";
  static const String reveiceMoneyIcon = "assets/icons/fa_download.svg";
  static const String topupPaymentIcon = "assets/icons/Top up payment.svg";
  static const String electricityIcon = "assets/icons/Electricity payment.svg";
  static const String internetIcon = "assets/icons/internet payment.svg";
  static const String airlineIcon = "assets/icons/airline.svg";
  static const String waterIcon = "assets/icons/drinking Water payment.svg";
  static const String insuranceIcon = "assets/icons/Insurance payment.svg";
  static const String busIcon = "assets/icons/Bus payment.svg";
  static const String tvIcon = "assets/icons/TV Payment.svg";
  static const String dataPackIcon = "assets/icons/Data pack.svg";
  static const String ridepaymentIcon = "assets/icons/ride.svg";
  static const String governmentIcon = "assets/icons/Government payment.svg";
  static const String brokerIcon = "assets/icons/broker.svg";
  static const String landlineIcon =
      "assets/icons/landline-1-svgrepo-com 1.svg";
  static const String forwardButtonIcon = "assets/icons/arrowright.svg";
  static const String bankTransfer = "assets/icons/Bank transfer.svg";
  static const String walletIcon = "assets/icons/Group 978.svg";
  static const String logoutIcon = "assets/icons/logout.svg";
  static const String profileIcon = "assets/icons/Personal information.svg";
  static const String homeIcon = "assets/icons/Home unselected.svg";
  static const String bankingIcon = "assets/icons/Banking.svg";
  static const String historyIcon = "assets/icons/Transaction history.svg";
  static const String moreIcon = "assets/icons/More.svg";
  static const String qrCodeIcon = "assets/icons/qrcode.svg";
  static const String mobileBanking = "assets/icons/mobilebanking.svg";
  static const String cardIcon = "assets/icons/Group 1103.svg";
  static const String connectIpsIcon = "assets/icons/Connect ips.svg";
  static const String sapatiIcon = "assets/icons/request sapati.svg";
  static const String remittanceIcon = "assets/icons/Group 958.svg";
  static const String accountInfo = "assets/icons/account info.svg";
  static const String balanceInquiry = "assets/icons/accrued interest.svg";
  static const String statement = "assets/icons/Group 1096.svg";
  static const String loanIcon = "assets/icons/Group 1097.svg";
  static const String fundTransferIcon =
      "assets/icons/money-send-svgrepo-com 1.svg";
  static const String chequeBookIcon = "assets/icons/Group 1098.svg";
  static const String personIcon = "assets/icons/Account Number.svg";
  static const String miniStatement = "assets/icons/ministatement.svg";
  static const String arrowRight = "assets/icons/arrowright.svg";
  static const String arrowUp = "assets/icons/arrowdownfull.svg";
  static const String arrowDown = "assets/icons/arrowupfull.svg";
  static const String filterIcon = "assets/icons/Filter list.svg";
  static const String errorImage = "assets/images/error.png";
  static const String ismartSlogan = "assets/images/ismart_slogan.png";
  static const String luggageIcon = "assets/icon/luggage_icon.svg";
  static const String editIcon = "assets/icon/edit_icon.svg";
  static const String menuIcon = "assets/icon/menu_icon.svg";
  static const String sortIcon = "assets/icons/Group 1100.svg";
  static const String resetPinIcon = "assets/icons/Reset password.svg";
  static const String preference = "assets/icons/preference.svg";

  // send money
  static const String sendMoneyIcon =
      "assets/icons/mingcute_send-plane-fill.svg";

  // More Screen
  static const String discountCalculator =
      "assets/icons/Discount calculator.svg";

  static const String emiCalculator = "assets/icons/EMI Calculator.svg";
  static const String downloadIcon = "assets/icons/Download.svg";
  static const String transactionLimit = "assets/icons/transLimit.svg";
  static const String settingIcon = "assets/icons/settings-svgrepo-com 1.svg";
  static const String contactUsIcon = "assets/icons/Contact us.svg";
  static const String successIcon = "assets/icons/transaction_success.svg";
  static const String calanderIcon = "assets/icons/uit_calender.svg";
  static const String forcedUpdateGraphics =
      "assets/images/infographics_10.png";
  static const String normalUpdateGraphics =
      "assets/images/infographics_10.png";

  //*********//
  static const String instaLoanBanner = "assets/images/insta_lona_banner.png";
  static const String instaLoanIcon = "assets/images/Group 1167.png";
  static const String instaLoanSuccessIcon =
      "assets/images/insta_loan_success copy.png";

  //remittance
  static const String findAgentsRemit = "assets/icons/find agents.svg";
  static const String sendMoneyRemit = "assets/icons/send_money_remit.svg";
  static const String receiveMoneyRemit =
      "assets/icons/receive_money_remit.svg";
  static const String trackMoneyRmit = "assets/icons/track_money_remit.svg";

  //Images
  static const String moneyTransferIcon = "assets/icons/money_transfer.png";
  static const String uploadImageIcon = "assets/images/upload_picture_icon.png";
  //icons

  static const String arrowUpRounded = "assets/icons/arrow_up_rounded.svg";
  static const String feedBackIcon = "assets/icons/feedback_icon.svg";

  //bus
  static const String busSeatIcon = "assets/icons/bus_seat_icon.svg";
  static const String busSideIcon = "assets/icons/bus_side.svg";
  //loan
  static const String loanStatement = "assets/icons/Group 1008.svg";
  static const String loanSchedule = "assets/icons/Group 1069.svg";
  static const String eventIcon = "assets/icons/event icon.svg";
  static const String calenderIconDark = "assets/icons/calender.svg";
}
