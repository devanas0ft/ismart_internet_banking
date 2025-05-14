import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/scaffold_topbar.dart';

class InternetListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: ListView(
        children: [
          ScaffoldTopBar(
            name: "Payment",
            showBackButton: true,
            onBackPressed: () {
              NavigationService.pop();
            },
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Internet Payment",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "Pay your internet bill of you ISP from here",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: _height * 0.01),
                Text(
                  "Choose Service Provider",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: _height * 0.01),
                SizedBox(
                  height: _height / 3,
                  child: GridView.builder(
                    itemCount: names.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1 / 1.2,
                        ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // NavigationService.pushNamed(
                          //   routeName: Routes.internetUsername,
                          // );
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.05),
                                      offset: const Offset(0, 4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                            Text(
                              names[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "poinssemibold",
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: Text(
                    "OR",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                SizedBox(height: _height * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: _height * 0.06,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0XFFF3F3F3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                            ),
                            hintText: "Search",
                            hintStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 18),
                      padding: const EdgeInsets.all(12),
                      width: _width * 0.115,
                      height: _height * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColor,
                        // border: Border.all(color: Colors.black),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/arrowrightfull.svg",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List names = [
    "NTC FTTH",
    "WorldLink",
    "Classic Tech",
    "Dish Home",
    "CG Net",
    "Subishu Internet",
  ];
}
