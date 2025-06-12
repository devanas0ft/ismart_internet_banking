import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/constants/fonts.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class FeedBackWidget extends StatefulWidget {
  final String? transactionIdentifier;
  const FeedBackWidget({super.key, this.transactionIdentifier});

  @override
  State<FeedBackWidget> createState() => _FeedBackWidgetState();
}

class _FeedBackWidgetState extends State<FeedBackWidget> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  final dateNow = DateTime.now();

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
          } else if (state is! CommonLoading && _isLoading) {
            _isLoading = false;
            NavigationService.pop();
          }
          if (state is CommonError) {
            showPopUpDialog(
              context: context,
              message: state.message,
              title: "Error",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }
          if (state is CommonStateSuccess<UtilityResponseData>) {
            showPopUpDialog(
              context: context,
              message: state.data.message,
              title: state.data.status.toString(),
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.popUntilFirstPage();
              },
            );

            _formKey.currentState!.reset();
          }
        },
        child: CommonContainer(
          title: "Report a Problem",
          buttonName: "Submit",
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<UtilityPaymentCubit>().makePayment(
                serviceIdentifier: "",
                accountDetails: {
                  "email": emailController.text,
                  "message":
                      "${widget.transactionIdentifier} ${messageController.text}",
                },
                body: {},
                apiEndpoint: "/api/addSuggestionBox",
                mPin: "",
              );
            }
          },
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: messageController,
                  title: "Date",
                  customHintTextStyle: true,
                  hintText: dateNow.toString(),
                ),
                if (widget.transactionIdentifier != null)
                  CustomTextField(
                    title: "Transaction Identifier",
                    hintText: widget.transactionIdentifier.toString(),
                    customHintTextStyle: true,
                  ),
                CustomTextField(
                  maxLine: 3,
                  hintText: "Message",
                  title: "Message",
                  textInputType: TextInputType.multiline,
                  validator:
                      (value) =>
                          FormValidator.validateFieldNotEmpty(value, "Message"),
                ),
                const Text(
                  "Picture",
                  style: TextStyle(
                    fontFamily: Fonts.poppin,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: CustomTheme.lightTextColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child:
                      _image == null
                          ? Container(
                            width: _width,
                            decoration: BoxDecoration(
                              color: _theme.primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            height: _height * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Assets.uploadImageIcon,
                                  height: 50.hp,
                                ),
                                SizedBox(height: 10.hp),
                                Text(
                                  "Upload Picture",
                                  style: _textTheme.titleSmall,
                                ),
                              ],
                            ),
                          )
                          : Container(
                            alignment: Alignment.center,
                            height: 140.hp,
                            child: Image.file(_image!),
                          ),
                ),
              ],
            ),
          ),
          topbarName: "Report Issue",
        ),
      ),
    );
  }

  File? _image;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      NavigationService.pop();
    }
  }
}
