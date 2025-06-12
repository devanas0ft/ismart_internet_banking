// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';

// class PersonalDetail extends StatefulWidget {
//   final CustomerDetailModel? detail;
//   final AccountDetail? selectedAccountNotifier;
//   const PersonalDetail({
//     super.key,
//     required this.detail,
//     required this.selectedAccountNotifier,
//   });

//   @override
//   State<PersonalDetail> createState() => _PersonalDetailState();
// }

// class _PersonalDetailState extends State<PersonalDetail> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool isEdit = true;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Form(
//       key: _formKey,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 1,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Wrap(
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   spacing: 50,
//                   runSpacing: 10,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(50),
//                       child: Image.asset(
//                         'assets/images/profile.png',
//                         width: 100,
//                         height: 100,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 buildPersonalDetail(
//                   'assets/icons/user_account/personal/name.svg',
//                   'Full Name',
//                   widget.detail?.firstName == null
//                       ? ''
//                       : '${widget.detail?.firstName} ${widget.detail?.middleName} ${widget.detail?.lastName}'
//                           .trim(),

//                   screenWidth,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 buildPersonalDetail(
//                   'assets/icons/user_account/personal/mail.svg',
//                   'Email',
//                   (widget.detail?.email.isEmpty ?? true)
//                       ? 'Not Available'
//                       : widget.detail?.email ?? '',

//                   screenWidth,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 buildPersonalDetail(
//                   'assets/icons/user_account/personal/mobile.svg',
//                   'Mobile Number',
//                   (widget.detail?.mobileNumber.isEmpty ?? true)
//                       ? 'Not Available'
//                       : widget.detail?.mobileNumber ?? '',

//                   screenWidth,
//                 ),
//                 SizedBox(height: 10),
//               ],
//             ),
//           ),

//           Expanded(
//             flex: 1,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 30),
//                 buildPersonalDetail(
//                   'assets/icons/user_account/personal/location.svg',
//                   'Province',
//                   'Not Available yet',
//                   screenWidth,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 buildPersonalDetail(
//                   'assets/icons/user_account/personal/city.svg',
//                   'City',
//                   (widget.detail?.city.isEmpty ?? true)
//                       ? 'Not Available'
//                       : widget.detail?.city ?? '',
//                   screenWidth,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 buildPersonalDetail(
//                   'assets/icons/user_account/personal/ward.svg',
//                   'Ward No.',
//                   "Not Available",
//                   screenWidth,
//                 ),
//                 if (!isEdit) SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildPersonalDetail(
//     String img,
//     String title,
//     String body,
//     double screenWidth,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               // Icon(icon, color: Color(0xff010c80)),
//               if (isEdit) ...[
//                 SvgPicture.asset(
//                   img,
//                   width: 20,
//                   height: 20,
//                   color: Color(0xff010c80),
//                 ),
//                 SizedBox(width: 10),
//               ],
//               Text(title, style: TextStyle(fontSize: 16)),
//               SizedBox(width: 10),
//             ],
//           ),
//           SizedBox(height: 10),
//           isEdit
//               ? Padding(
//                 padding: const EdgeInsets.only(left: 30.0),
//                 child: Text(
//                   body,
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               )
//               : SizedBox(
//                 width: screenWidth * 0.2,
//                 child: CustomTextField(body),
//               ),
//         ],
//       ),
//     );
//   }

//   Widget CustomTextField(String hintText) {
//     return isEdit
//         ? Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(hintText, style: TextStyle(fontSize: 16, color: Colors.grey)),
//             SizedBox(height: 20),
//           ],
//         )
//         : TextFormField(
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey[200],
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//               borderSide: BorderSide(color: Colors.transparent),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//               borderSide: BorderSide(color: Colors.transparent),
//             ),
//             hintText: hintText,
//           ),
//         );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';

class PersonalDetail extends StatefulWidget {
  final CustomerDetailModel? detail;
  final AccountDetail? selectedAccountNotifier;
  const PersonalDetail({
    super.key,
    required this.detail,
    required this.selectedAccountNotifier,
  });

  @override
  State<PersonalDetail> createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEdit = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768 && size.width <= 1024;
    final isMobile = size.width <= 768;
    final isSmallMobile = size.width <= 480;

    return Form(
      key: _formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isMobile) {
            return _buildMobileLayout(context, isSmallMobile);
          } else {
            return _buildDesktopTabletLayout(context, isDesktop, isTablet);
          }
        },
      ),
    );
  }

  Widget _buildDesktopTabletLayout(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildLeftColumn(context, isDesktop, isTablet),
        ),
        SizedBox(width: isDesktop ? 40 : 20),
        Expanded(
          flex: 1,
          child: _buildRightColumn(context, isDesktop, isTablet),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isSmallMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileSection(context, true, isSmallMobile),
        SizedBox(height: isSmallMobile ? 16 : 24),
        _buildPersonalDetailsSection(context, true, isSmallMobile),
      ],
    );
  }

  Widget _buildLeftColumn(BuildContext context, bool isDesktop, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileSection(context, false, false),
        SizedBox(height: isDesktop ? 32 : 24),
        _buildPersonalDetail(
          context,
          'assets/icons/user_account/personal/name.svg',
          'Full Name',
          _getFullName(),
          false,
          false,
        ),
        SizedBox(height: isDesktop ? 24 : 20),
        _buildPersonalDetail(
          context,
          'assets/icons/user_account/personal/mail.svg',
          'Email',
          _getEmail(),
          false,
          false,
        ),
        SizedBox(height: isDesktop ? 24 : 20),
        _buildPersonalDetail(
          context,
          'assets/icons/user_account/personal/mobile.svg',
          'Mobile Number',
          _getMobileNumber(),
          false,
          false,
        ),
      ],
    );
  }

  Widget _buildRightColumn(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: isDesktop ? 120 : 100,
        ), // Align with left column content
        _buildPersonalDetail(
          context,
          'assets/icons/user_account/personal/location.svg',
          'Province',
          'Not Available yet',
          false,
          false,
        ),
        SizedBox(height: isDesktop ? 24 : 20),
        _buildPersonalDetail(
          context,
          'assets/icons/user_account/personal/city.svg',
          'City',
          _getCity(),
          false,
          false,
        ),
        SizedBox(height: isDesktop ? 24 : 20),
        _buildPersonalDetail(
          context,
          'assets/icons/user_account/personal/ward.svg',
          'Ward No.',
          "Not Available",
          false,
          false,
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    bool isMobile,
    bool isSmallMobile,
  ) {
    final profileSize = isSmallMobile ? 80.0 : (isMobile ? 90.0 : 100.0);

    return Align(
      alignment: isMobile ? Alignment.center : Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(profileSize / 2),
        child: Image.asset(
          'assets/images/profile.png',
          width: profileSize,
          height: profileSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: profileSize,
              height: profileSize,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: profileSize * 0.6,
                color: Colors.grey[600],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPersonalDetailsSection(
    BuildContext context,
    bool isMobile,
    bool isSmallMobile,
  ) {
    final details = [
      (
        'assets/icons/user_account/personal/name.svg',
        'Full Name',
        _getFullName(),
      ),
      ('assets/icons/user_account/personal/mail.svg', 'Email', _getEmail()),
      (
        'assets/icons/user_account/personal/mobile.svg',
        'Mobile Number',
        _getMobileNumber(),
      ),
      (
        'assets/icons/user_account/personal/location.svg',
        'Province',
        'Not Available yet',
      ),
      ('assets/icons/user_account/personal/city.svg', 'City', _getCity()),
      (
        'assets/icons/user_account/personal/ward.svg',
        'Ward No.',
        "Not Available",
      ),
    ];

    return Column(
      children:
          details.map((detail) {
            return Padding(
              padding: EdgeInsets.only(bottom: isSmallMobile ? 16 : 20),
              child: _buildPersonalDetail(
                context,
                detail.$1,
                detail.$2,
                detail.$3,
                isMobile,
                isSmallMobile,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildPersonalDetail(
    BuildContext context,
    String iconPath,
    String title,
    String body,
    bool isMobile,
    bool isSmallMobile,
  ) {
    final iconSize = isSmallMobile ? 18.0 : 20.0;
    final titleFontSize = isSmallMobile ? 14.0 : 16.0;
    final bodyFontSize = isSmallMobile ? 14.0 : 16.0;
    final spacing = isSmallMobile ? 8.0 : 10.0;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isEdit) ...[
                SvgPicture.asset(
                  iconPath,
                  width: iconSize,
                  height: iconSize,
                  color: Color(0xff010c80),
                ),
                SizedBox(width: spacing),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          Padding(
            padding: EdgeInsets.only(left: isEdit ? (iconSize + spacing) : 0),
            child:
                isEdit
                    ? Text(
                      body,
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        color: Colors.grey[600],
                      ),
                    )
                    : _buildTextField(body, isMobile, isSmallMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hintText, bool isMobile, bool isSmallMobile) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 300),
      child: TextFormField(
        style: TextStyle(fontSize: isSmallMobile ? 14.0 : 16.0),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: isSmallMobile ? 8 : 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xff010c80), width: 2),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: isSmallMobile ? 14.0 : 16.0,
          ),
        ),
      ),
    );
  }

  String _getFullName() {
    if (widget.detail?.firstName == null) return 'Not Available';
    return '${widget.detail?.firstName ?? ''} ${widget.detail?.middleName ?? ''} ${widget.detail?.lastName ?? ''}'
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  String _getEmail() {
    return (widget.detail?.email?.isEmpty ?? true)
        ? 'Not Available'
        : widget.detail?.email ?? 'Not Available';
  }

  String _getMobileNumber() {
    return (widget.detail?.mobileNumber?.isEmpty ?? true)
        ? 'Not Available'
        : widget.detail?.mobileNumber ?? 'Not Available';
  }

  String _getCity() {
    return (widget.detail?.city?.isEmpty ?? true)
        ? 'Not Available'
        : widget.detail?.city ?? 'Not Available';
  }
}
