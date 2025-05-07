import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/constants/env.dart';
import 'package:ismart_web/common/utils/file_download_utils.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/primary_account_box.dart';
import 'package:ismart_web/common/widget/statement_detail_box.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/statement/fullStatement/cubit/full_statement_cubit.dart';
import 'package:ismart_web/features/statement/fullStatement/model/full_statement_model.dart';
import 'package:path_provider/path_provider.dart';

class FullStatementWidget extends StatefulWidget {
  @override
  State<FullStatementWidget> createState() => _FullStatementWidgetState();
}

class _FullStatementWidgetState extends State<FullStatementWidget> {
  Dio dio = Dio();
  String url = "https://www.africau.edu/images/default/sample.pdf";
  int startDay = 15;
  List numberOfDaysText = ["15 Days", "1 Month", "3 Month"];
  List numberOfDays = [15, 30, 90];

  DateTime fromDate = DateTime.now();
  DateTime fromDateAlert = DateTime.now();
  DateTime toDateAlert = DateTime.now();

  DateTime toDate = DateTime.now();
  ValueNotifier<FullStatementModel?> fullStatementDetail = ValueNotifier(null);
  ValueNotifier<CustomerDetailModel?> customerDetail = ValueNotifier(null);
  void getData({required DateTime fromdate, required todate}) {
    context.read<FullStatementCubit>().fetchFullStatement(
      accountNumber:
          RepositoryProvider.of<CustomerDetailRepository>(
            context,
          ).selectedAccount.value?.accountNumber ??
          "",
      fromDate: fromdate,
      toDate: todate,
    );
  }

  bool sortList = false;

  @override
  void initState() {
    super.initState();
    getData(
      fromdate: fromDate.subtract(Duration(days: startDay)),
      todate: toDate,
    );
  }

  int selectedDays = 0;
  double progress = 0.0;
  getList({required List<AccountStatementDtos> dataList}) {
    return sortList == true ? dataList.reversed.toList() : dataList;
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: CommonContainer(
        showRoundBotton: false,
        showDetail: true,
        verticalPadding: 0,
        showTitleText: false,
        buttonName: "Close",
        topbarName: "Full Statement",
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: _height * 0.04,
                    child: ListView.builder(
                      itemCount: numberOfDays.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              fromDate = DateTime.now().subtract(
                                Duration(days: numberOfDays[index]),
                              );
                              // fromDateAlert = DateTime.now();
                              selectedDays = index;
                              // startDay = numberOfDays[index];
                            });
                            getData(fromdate: fromDate, todate: toDate);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: _width * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  fromDateAlert != DateTime.now()
                                      ? selectedDays == index
                                          ? _theme.primaryColor
                                          : Colors.white
                                      : Colors.black54,
                              border: Border.all(
                                color:
                                    fromDateAlert != DateTime.now()
                                        ? selectedDays == index
                                            ? _theme.primaryColor
                                            : Colors.black54
                                        : Colors.black54,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${numberOfDaysText[index]}",
                                style: _textTheme.labelLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      fromDateAlert != DateTime.now()
                                          ? selectedDays == index
                                              ? Colors.white
                                              : Colors.black54
                                          : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              actionsPadding: EdgeInsets.zero,
                              actions: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Filter",
                                          style: _textTheme.labelLarge!
                                              .copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        PrimaryAccountBox(),
                                        CustomTextField(
                                          customHintTextStyle: true,
                                          readOnly: true,
                                          onTap: () async {
                                            final DateTime? picked =
                                                await showDatePicker(
                                                  context: context,
                                                  initialDate: fromDate,
                                                  firstDate: DateTime(2000, 8),
                                                  lastDate: DateTime.now(),
                                                );
                                            setState(() {
                                              fromDateAlert = picked!;
                                            });
                                          },
                                          showSuffixImage: true,
                                          title: "From Date",
                                          hintText:
                                              "${fromDateAlert.year}-${fromDateAlert.month}-${fromDateAlert.day}",
                                        ),
                                        CustomTextField(
                                          showSuffixImage: true,
                                          customHintTextStyle: true,
                                          readOnly: true,
                                          hintText:
                                              "${toDateAlert.year}-${toDateAlert.month}-${toDateAlert.day}",
                                          title: "To Date",
                                          onTap: () async {
                                            final DateTime? picked =
                                                await showDatePicker(
                                                  context: context,
                                                  initialDate: toDate,
                                                  firstDate: DateTime(2020, 8),
                                                  lastDate: DateTime.now(),
                                                );
                                            setState(() {
                                              toDateAlert = picked!;
                                            });
                                          },
                                        ),
                                        CustomRoundedButtom(
                                          title: "View",
                                          onPressed: () {
                                            getData(
                                              fromdate: fromDateAlert,
                                              todate: toDateAlert,
                                            );
                                            NavigationService.pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    height: _height * 0.04,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color:
                            fromDateAlert != DateTime.now()
                                ? Colors.black54
                                : _theme.primaryColor,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Text(
                          "Filter",
                          style: _textTheme.labelLarge!.copyWith(
                            color:
                                fromDateAlert != DateTime.now()
                                    ? Colors.black54
                                    : _theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: _width * 0.02),
                        SvgPicture.asset(
                          Assets.filterIcon,
                          height: _height * 0.025,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<FullStatementCubit, CommonState>(
              builder: (context, state) {
                if (state is CommonStateSuccess<FullStatementModel>) {
                  final List<AccountStatementDtos> resData =
                      state.data.accountStatementDtos;
                  final selectedAccount =
                      RepositoryProvider.of<CustomerDetailRepository>(
                        context,
                      ).selectedAccount.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              FileDownloadUtils.downloadFile(
                                downloadLink:
                                    RepositoryProvider.of<CoOperative>(
                                      context,
                                    ).baseUrl +
                                    state.data.pdfUrl.toString(),
                                fileName:
                                    FileDownloadUtils.generateDownloadFileName(
                                      name: "Statement",
                                      filetype: FileType.pdf,
                                    ),
                                context: context,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Download  ",
                                  style: _textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SvgPicture.asset(
                                  Assets.downloadIcon,
                                  height: 20.hp,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Sorting",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: 0.3,
                              color: CustomTheme.primaryColor,
                            ),
                          ),
                          Switch(
                            activeColor: CustomTheme.primaryColor,
                            value: sortList,
                            onChanged: (value) {
                              setState(() {
                                sortList = !sortList;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: _height * 0.01),
                      state.data.accountStatementDtos.isEmpty
                          ? const NoDataScreen(
                            title: "No transactions yet",
                            details: "Make Your First Transfer",
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: _height * 0.01),
                              Text(
                                "Account No. ${selectedAccount!.mainCode}",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Container(
                                padding: const EdgeInsets.all(18),
                                width: double.infinity,
                                height: _height * 0.11,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Opening Balance",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleLarge,
                                        ),
                                        Text(
                                          "NPR ${state.data.openingBalance}",
                                          style: TextStyle(
                                            fontFamily: "popinBold",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Closing Balance",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleLarge,
                                        ),
                                        Text(
                                          "NPR ${state.data.closingBalance}",
                                          style: TextStyle(
                                            fontFamily: "popinBold",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 500,
                                padding: const EdgeInsets.only(bottom: 70),
                                child: ListView.builder(
                                  itemCount: resData.length,
                                  itemBuilder: (context, index) {
                                    final data = getList(dataList: resData);
                                    return StatementDetailBox(
                                      balance: data[index].balance.toString(),
                                      isCredit:
                                          data[index].credit != 0
                                              ? true
                                              : false,
                                      desc: data[index].remarks.toString(),
                                      amount:
                                          data[index].credit == 0
                                              ? data[index].debit.toString()
                                              : data[index].credit.toString(),
                                      dateTime:
                                          data[index].transactionDate
                                              .toString(),
                                      imageUrl: "",
                                      status:
                                          data[index].credit != 0
                                              ? "Deposit"
                                              : "Withdrawl",
                                    );
                                  },
                                ),
                              ),
                              CustomRoundedButtom(
                                title: "Close",
                                onPressed: () {
                                  NavigationService.push(target: Container());
                                },
                              ),
                            ],
                          ),
                    ],
                  );
                } else if (state is CommonLoading) {
                  return const CommonLoadingWidget();
                } else {
                  return const NoDataScreen(
                    title: "No transactions yet",
                    details: "Make Your First Transfer",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$filename";
  }
  // Future<void> downloadPDF(
  //     {required String path, required String fileName}) async {
  //   final url = RepositoryProvider.of<CoOperative>(context)
  //       .baseUrl; // Replace with your PDF URL

  //   final response = await http.get(Uri.parse(url));
  //   final bytes = response.bodyBytes;

  //   final directory = await getExternalStorageDirectory();
  //   final path = '${directory!.path}/$fileName'; // File path on the device

  //   await FlutterDownloader.enqueue(
  //     url: url,
  //     savedDir: directory.filePath,
  //     fileName: 'sample.pdf',
  //     showNotification: true,
  //     openFileFromNotification: true,
  //     headers: {'content-length': response.headers['content-length'] ?? ""},
  //   );
  // }
}

//  SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: DataTable(
//                                   headingRowHeight: 40,
//                                   dataTextStyle: TextStyle(
//                                       fontSize: 12, color: Colors.black),
//                                   headingRowColor:
//                                       MaterialStatePropertyAll(Colors.black12),
//                                   columnSpacing: _width * 0.05,
//                                   columns: [
//                                     // DataColumn(label: Text("SN")),
//                                     DataColumn(label: Text("Date")),
//                                     DataColumn(label: Text("Withdrawl")),
//                                     DataColumn(label: Text("Deposit")),
//                                     DataColumn(label: Text("Balance")),
//                                   ],
//                                   rows: state.data.accountStatementDtos!
//                                       .map((e) => DataRow(
//                                             cells: [
//                                               DataCell(
//                                                 Center(
//                                                   child: Text(e.transactionDate
//                                                       .toString()),
//                                                 ),
//                                               ),
//                                               DataCell(Center(
//                                                 child: Text(
//                                                   e.debit.toString(),
//                                                   style: TextStyle(
//                                                       color: CustomTheme.green),
//                                                 ),
//                                               )),
//                                               DataCell(Center(
//                                                 child: Text(e.credit.toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.red)),
//                                               )),
//                                               DataCell(Center(
//                                                   child: Text(
//                                                       e.balance.toString()))),
//                                             ],
//                                           ))
//                                       .toList(),
//                                 ),
//                               ),
