// lib/features/cooperative/resource/cooperative_repository.dart

import 'package:flutter/material.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/models/coop_model_response.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/features/dynamicCoop/cooperative_api_provider.dart';

class CooperativeRepository {
  final ApiProvider apiProvider;
  final String baseUrl;
  late CooperativeApiProvider cooperativeApiProvider;
  



  CooperativeRepository({
    required this.apiProvider,
    required this.baseUrl,
  }) {
    cooperativeApiProvider = CooperativeApiProvider(
      baseUrl: baseUrl,
      apiProvider: apiProvider,
    );
  }

  Future<DataResponse<CoOperative>> fetchCooperativeConfig() async {
    try {
      final response = await cooperativeApiProvider.fetchCooperativeConfig();

      if (response['data']?['code'] == "M0000") {
        final Map<String, dynamic> detailRaw = Map.from(
          response['data']?['detail'] ?? {}
        );

        if (detailRaw.isNotEmpty) {
          final Detail detail = Detail.fromJson(
            detailRaw,
          );
          
          final CoOperative config = _mapApiResponseToConfig(detail);
          await SharedPref.setDynamicCoopDetails(detail);
          return DataResponse.success(config);
        } else {
          return DataResponse.error("No cooperative configuration found.");
        }
      } else {
        return DataResponse.error(
          response['data']?['message'] ?? "Error fetching cooperative config.",
        );
      }
    } catch (e) {
      print('Error fetching cooperative config: $e');
      return DataResponse.error("Error fetching cooperative configuration");
    }
  }

  CoOperative _mapApiResponseToConfig(
    Detail detail,
  ) {
    return CoOperative(
      coOperativeName: detail.name?.toLowerCase() ?? '',
      clientCode: detail.clientID ?? '',
      clientSecret: detail.clientSecret ?? '',
      
      // Map banner - use API URL if available
      bannerImage: detail.bannerUrl?.isNotEmpty == true
          ? _formatImageUrl(detail.bannerUrl!)
          : '',
      
      // Map logo
      coOperativeLogo: detail.logoUrl?.isNotEmpty == true
          ? _formatImageUrl(detail.logoUrl!)
          : '',
      
      // Map splash image
      splashImage: detail.iconUrl?.isNotEmpty == true
          ? _formatImageUrl(detail.iconUrl!)
          : '',
      
      // Parse colors
      primaryColor: _parseColor(detail.themeColorPrimary) ?? 
          const Color.fromARGB(255, 22, 128, 1),
      
      // Map app title
      appTitle: detail.name ?? 'iSmart',
  
      // Keep default values
      baseUrl: baseUrl,
      backgroundImage: detail.bannerUrl?.isNotEmpty == true
          ? _formatImageUrl(detail.bannerUrl!)
          : '',

    );
  }

  String _formatImageUrl(String url) {
    return baseUrl + url;
  }

  Color? _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return null;
    
    try {
      String hexColor = colorString.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      print('Error parsing color: $e');
      return null;
    }
  }
}