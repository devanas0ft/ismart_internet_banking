import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class LoanScheduleWidget extends StatefulWidget {
  @override
  State<LoanScheduleWidget> createState() => _LoanScheduleWidgetState();
}

class _LoanScheduleWidgetState extends State<LoanScheduleWidget> {
  @override
  void initState() {
    fetchLoanSchedule();
    super.initState();
  }

  fetchLoanSchedule() async {
    context.read<UtilityPaymentCubit>().fetchDetails(
      serviceIdentifier: "",
      accountDetails: {
        "accountNumber":
            RepositoryProvider.of<CustomerDetailRepository>(
              context,
            ).selectedAccount.value!.accountNumber,
        "mPin": '778899',
      },
      apiEndpoint: "api/loan/schedule",
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return PageWrapper(
      body: CommonContainer(
        verticalPadding: 0,
        horizontalPadding: 0,
        topbarName: "Loan Schedule",
        showRoundBotton: false,
        body: Column(
          children: [
            BlocBuilder<UtilityPaymentCubit, CommonState>(
              builder: (context, state) {
                if (state is CommonStateSuccess) {
                  final UtilityResponseData response = state.data;
                  final _response = response.findValue(primaryKey: "data");
                  return response.details.isNotEmpty
                      ? Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStatePropertyAll(
                                _theme.primaryColor.withOpacity(0.05),
                              ),
                              columnSpacing: 10,
                              columns: const [
                                DataColumn(label: Text('Date')),
                                DataColumn(
                                  label: Text(
                                    'Schedule\nNumber',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                DataColumn(label: Text('Amount')),
                                DataColumn(label: Text('Principal')),
                                DataColumn(label: Text('Interest')),
                                DataColumn(
                                  label: Text(
                                    'Principal\nBalance',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              rows: List.generate(
                                _response.length,
                                (index) => DataRow(
                                  color: MaterialStatePropertyAll(
                                    index.isEven
                                        ? CustomTheme.white
                                        : _theme.primaryColor.withOpacity(0.03),
                                  ),
                                  cells: [
                                    DataCell(
                                      Text(
                                        "${_response[index]['scheduleDate']}\n${_response[index]['scheduleDateNepali'].toString()}",
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          _response[index]['scheduleNumber']
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        _response[index]['scheduleAmount']
                                            .toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        _response[index]['principal']
                                            .toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        _response[index]['interest'].toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        _response[index]['principalBalance']
                                            .toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      : NoDataScreen(
                        title: "No Statement Found",
                        details: response.message.toString(),
                      );
                } else if (state is CommonLoading) {
                  return const CommonLoadingWidget();
                } else if (state is CommonError) {
                  return NoDataScreen(
                    title: "No Loan Schedule Found",
                    details: state.message,
                  );
                } else {
                  return Text(state.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
