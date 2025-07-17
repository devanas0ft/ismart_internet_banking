import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/statement/fullStatement/cubit/full_statement_cubit.dart';
import 'package:ismart_web/features/statement/fullStatement/model/full_statement_model.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';

class FullStatementHomeWidget extends StatefulWidget {
  const FullStatementHomeWidget({super.key});

  @override
  State<FullStatementHomeWidget> createState() =>
      _FullStatementHomeWidgetState();
}

class _FullStatementHomeWidgetState extends State<FullStatementHomeWidget> {
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 90));
  DateTime toDateAlert = DateTime.now();
  DateTime toDate = DateTime.now();
  ValueNotifier<FullStatementModel?> fullStatementDetail = ValueNotifier(null);
  ValueNotifier<CustomerDetailModel?> customerDetail = ValueNotifier(null);

  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  void getData({required DateTime fromdate, required DateTime todate}) {
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

  _addListener(BuildContext context) {
    RepositoryProvider.of<CustomerDetailRepository>(
      context,
    ).customerDetailModel.addListener(() {
      getData(fromdate: fromDate, todate: toDate);
    });
  }

  @override
  void initState() {
    super.initState();
    // getData(fromdate: fromDate, todate: toDate);

    _addListener(context);
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FullStatementCubit, CommonState>(
      builder: (context, state) {
        if (state is CommonLoading) {
          return const SizedBox(height: 500, child: CommonLoadingWidget());
        }

        if (state is CommonStateSuccess<FullStatementModel>) {
          return _buildStatementTable(context, state.data);
        }

        return const Center(
          child: NoDataScreen(
            title: "No transactions yet",
            details: "Make Your First Transfer",
          ),
        );
      },
    );
  }

  Widget _buildStatementTable(BuildContext context, FullStatementModel data) {
    final screenHeight = MediaQuery.of(context).size.height;

    final availableHeight =
        screenHeight * 0.8; // Reduced from 1.0 to prevent overflow

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      child: SizedBox(
        height: availableHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccountHeader(data),
            const Divider(),
            Expanded(
              // Added Expanded to prevent overflow
              child: _buildScrollableTable(data),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountHeader(FullStatementModel data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderInfo('Account Holder', data.accountName),
                  const SizedBox(width: 20),
                  _buildHeaderInfo('Account Number', data.accountNumber),
                  const SizedBox(width: 20),
                  _buildHeaderInfo('Account Type', data.accountType),
                  const SizedBox(width: 20),
                  _buildHeaderInfo('Address', data.address),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderInfo('From Date', data.fromDate),
                  const SizedBox(width: 20),
                  _buildHeaderInfo('To Date', data.toDate),
                  const SizedBox(width: 20),
                  _buildHeaderInfo(
                    'Opening Balance',
                    data.openingBalance.toString(),
                  ),
                  const SizedBox(width: 20),
                  _buildHeaderInfo(
                    'Closing Balance',
                    data.closingBalance.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(String label, String value) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 120,
      ), // Added min width for consistency
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableTable(FullStatementModel data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(16),
      child: Scrollbar(
        controller: _horizontalController,
        thumbVisibility: true,
        child: Scrollbar(
          controller: _verticalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              controller: _verticalController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth:
                      MediaQuery.of(context).size.width < 1033
                          ? MediaQuery.of(context).size.width - 64
                          : 1033,
                  maxWidth: 1033,
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.grey[100]!,
                  ),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  dataTextStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  columnSpacing: 8,
                  horizontalMargin: 8,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'S.N',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Transaction Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Withdraw',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Deposit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Balance',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      numeric: true,
                    ),
                  ],
                  rows: _buildDataRows(data),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows(FullStatementModel data) {
    if (data.accountStatementDtos.isEmpty) {
      return [
        const DataRow(
          cells: [
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('No transactions found')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
          ],
        ),
      ];
    }

    return data.accountStatementDtos.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final transaction = entry.value;

      return DataRow(
        cells: [
          DataCell(
            Text(
              index.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          DataCell(
            Text(
              transaction.transactionDate,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          DataCell(
            SizedBox(
              width: 200,
              child: Text(
                transaction.remarks,
                style: const TextStyle(fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          DataCell(
            Text(
              transaction.debit > 0 ? _formatCurrency(transaction.debit) : '-',
              style: TextStyle(
                color: transaction.debit > 0 ? Colors.red[600] : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          DataCell(
            Text(
              transaction.credit > 0
                  ? _formatCurrency(transaction.credit)
                  : '-',
              style: TextStyle(
                color: transaction.credit > 0 ? Colors.green[600] : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          DataCell(
            Text(
              _formatCurrency(transaction.balance),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      );
    }).toList();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }
}
