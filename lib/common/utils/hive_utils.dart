import 'package:hive_flutter/hive_flutter.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/appServiceManagement/model/app_service_management_model.dart';
import 'package:ismart_web/features/wallet_transfer/model/wallet_model.dart';

class ServiceHiveUtils {
  static final ServiceHiveUtils _walletHiveUtils = ServiceHiveUtils._internal();

  factory ServiceHiveUtils() {
    return _walletHiveUtils;
  }

  ServiceHiveUtils._internal();

  static const String _serviceListing = "serviceListing";
  static const String _serviceDetails = "serviceDetails";
  static const String _appServiceListing = "appServiceListing";
  static const String _appServiceDetails = "appServiceDetails";
  static const String _walletServiceListing = "walletServiceListing";
  static const String _walletServiceDetails = "walletServiceDetails";

  static init() async {
    print("Hive Initialized");
    await Hive.initFlutter();
  }

  static Future<List<CategoryList>> getUtilitiesServices({
    required String slug,
  }) async {
    try {
      final _utilitiesHive = await Hive.openBox(_serviceListing);
      final _data = _utilitiesHive.get(slug);
      final _items = List.from(_data ?? []);
      await _utilitiesHive.close();
      return _items
          .map((e) => CategoryList.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> setUtilitiesServices({
    required List<CategoryList> item,
    required String slug,
  }) async {
    final _utilitiesHive = await Hive.openBox(_serviceListing);
    await _utilitiesHive.put(slug, item.map((e) => e.toJson()).toList());
    await _utilitiesHive.close();
  }

  static Future<CategoryList?> getUtilityService({required String slug}) async {
    try {
      final _utilitiesHive = await Hive.openBox(_serviceDetails);
      final _data = _utilitiesHive.get(slug);
      Map<String, dynamic> _item = Map.from(_data ?? {});
      await _utilitiesHive.close();
      return CategoryList.fromJson(_item);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> setService({
    required CategoryList item,
    required String slug,
  }) async {
    final _utilitiesHive = await Hive.openBox(_serviceDetails);
    await _utilitiesHive.put(slug, item.toJson());
    await _utilitiesHive.close();
  }

  static close() async {
    await Hive.close();
  }

  static Future<void> setAppService({
    required List<AppServiceManagementModel> item,
    required String slug,
  }) async {
    final _utilitiesHive = await Hive.openBox(_appServiceDetails);
    await _utilitiesHive.put(slug, item.map((e) => e.toJson()).toList());
    await _utilitiesHive.close();
  }

  static Future<List<AppServiceManagementModel>> getAppService({
    required String slug,
  }) async {
    try {
      final _utilitiesHive = await Hive.openBox(_appServiceListing);
      final _data = _utilitiesHive.get(slug);
      final _items = List.from(_data ?? []);
      await _utilitiesHive.close();
      return _items
          .map(
            (e) => AppServiceManagementModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> setWalletList({
    required List<WalletModel> item,
    required String slug,
  }) async {
    final _utilitiesHive = await Hive.openBox(_walletServiceDetails);
    await _utilitiesHive.put(slug, item.map((e) => e.toJson()).toList());
    await _utilitiesHive.close();
  }

  static Future<List<WalletModel>> getWalletList({required String slug}) async {
    try {
      final _utilitiesHive = await Hive.openBox(_walletServiceListing);
      final _data = _utilitiesHive.get(slug);
      final _items = List.from(_data ?? []);
      await _utilitiesHive.close();
      return _items
          .map((e) => WalletModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
