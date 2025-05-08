// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/common/data_state.dart';
// import 'package:ismart/common/models/key_value.dart';
// import 'package:ismart/common/widget/common_button.dart';
// import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
// import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';
// import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

// class AirlinesNationalityList extends StatelessWidget {
//   const AirlinesNationalityList({
//     Key? key,
//     required this.onChanged,
//   }) : super(key: key);
//   final ValueChanged<KeyValue> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       lazy: false,
//       create: (context) => UtilityPaymentCubit(
//         utilityPaymentRepository:
//             RepositoryProvider.of<UtilityPaymentRepository>(context),
//       )..makePayment(
//           body: {},
//           mPin: "",
//           serviceIdentifier: "",
//           accountDetails: {},
//           apiEndpoint: "/api/arsnationality"),
//       child: BlocBuilder<UtilityPaymentCubit, CommonState>(
//         builder: (context, state) {
//           if (state is CommonStateSuccess<UtilityResponseData>) {
//             final _counters = state.data.findValue(primaryKey: "data");
//             final _list = List.generate(
//               _counters?.length ?? 0,
//               (index) => KeyValue(
//                   title: _counters?[index]["nationalityName"],
//                   value: _counters?[index]["nationalityCode"]),
//             );
//             return Row(
//               children: [
//                 ...List.generate(
//                     _list.length,
//                     (index) => CustomRoundedButtom(
//                           onPressed: () {
//                             onChanged(_list[index]);
//                           },
//                           title: _list[index].title,
//                         ))
//               ],
//             );
//           } else {
//             return Container();
//           }
//         },
//       ),
//     );
//   }
// }
