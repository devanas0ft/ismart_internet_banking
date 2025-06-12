import 'package:flutter/material.dart';

import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/models/downloaded_file.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_detail_box.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';

class DownloadWidget extends StatefulWidget {
  const DownloadWidget({Key? key}) : super(key: key);

  @override
  State<DownloadWidget> createState() => _DownloadWidgetState();
}

class _DownloadWidgetState extends State<DownloadWidget> {
  List<DownloadedFile> _dowloadedFiles = [];

  @override
  void initState() {
    _populateDownloads();
    super.initState();
  }

  _populateDownloads() async {
    _dowloadedFiles = await SharedPref.getDownloads();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: CommonContainer(
        showRoundBotton: false,
        title: "Downloads",
        detail: "All your downloaded documents are stored here.",
        showDetail: true,
        topbarName: "More",
        body: Container(
          height: 500.hp,
          child:
              _dowloadedFiles.isNotEmpty
                  ? ListView.builder(
                    itemCount: _dowloadedFiles.length,
                    itemBuilder: (context, index) {
                      return CommonDetailBox(
                        leadingImage: Assets.statement,
                        title: _dowloadedFiles[index].fileName,
                        detail:
                            "Downloaded on :" +
                            _dowloadedFiles[index].downloadedDate.toString(),
                        showTrailingIcon: false,
                        onBoxPressed: () {},
                      );
                    },
                  )
                  : const Center(
                    child: Text(
                      "No downloads available.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
