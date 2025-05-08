import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/features/wallet_transfer/model/wallet_model.dart';
import 'package:ismart_web/features/wallet_transfer/ui/screens/load_wallet_form_screen.dart';

class WalletBoxWidget extends StatefulWidget {
  const WalletBoxWidget({Key? key, required this.wallet}) : super(key: key);

  final WalletModel wallet;

  @override
  State<WalletBoxWidget> createState() => _WalletBoxWidgetState();
}

class _WalletBoxWidgetState extends State<WalletBoxWidget> {
  String _iconUrl = "";

  @override
  void initState() {
    _iconUrl =
        RepositoryProvider.of<CoOperative>(context).baseUrl +
        "ismart/serviceIcon/" +
        widget.wallet.icon;

    print(_iconUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return InkWell(
      onTap: () {
        NavigationService.push(
          target: LoadWalletFormScreen(selectedWallet: widget.wallet),
        );
      },
      child: Container(
        padding: EdgeInsets.all(25.wp),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        width: _width * 0.2,
        height: _width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: CustomTheme.gray,
        ),
        child: Column(
          children: [
            Expanded(
              child: CustomCachedNetworkImage(url: _iconUrl, fit: BoxFit.cover),
            ),
            SizedBox(height: _height * 0.01),
            Text(widget.wallet.name),
          ],
        ),
      ),
    );
  }
}
