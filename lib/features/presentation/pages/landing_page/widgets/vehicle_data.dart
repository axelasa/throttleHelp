import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trnk_ice/core/common/widgets/screen_title.dart';

import '../../../../../core/common/widgets/app_font.dart';
import '../../../../../provider/user_provider.dart';
import '../../auth/models/user_data.dart';

class VehicleData extends StatefulWidget {
  const VehicleData({super.key});

  @override
  State<VehicleData> createState() => _VehicleDataState();
}

class _VehicleDataState extends State<VehicleData> {

  UserData? userdata;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.arrow_back_outlined),
                    ),
                    const SizedBox(width: 48,),
                    const Center(
                      child:  ScreenTitle(title: 'Vehicle Info'),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Card(
                  color: Colors.white,
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Text(
                        //       'Vehicle Type:',
                        //       style: TextStyle(
                        //           fontSize: 18,
                        //           fontWeight: FontWeight.w600,
                        //           fontFamily: AppFont.font),
                        //     ),
                        //     Text(
                        //       userdata?.vehicleType ?? "",
                        //       style: const TextStyle(
                        //           color: Colors.grey,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.w500,
                        //           fontFamily: AppFont.font),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vehicle model:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFont.font),
                            ),
                            Text(
                              userdata?.motorCycleModel ?? "",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFont.font),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vehicle Registration:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFont.font),
                            ),
                            Text(
                              userdata?.motorCycleRegistration ?? "",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFont.font),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vehicle Make:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFont.font),
                            ),
                            Text(
                              userdata?.motorCycleMake ?? "",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFont.font),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vehicle Color:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFont.font),
                            ),
                            Text(
                              userdata?.motorCycleColor ?? "",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFont.font),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
  _updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
    setState(() {
      userdata = userProvider.getUser;
    });
    debugPrint(
        'HERE IS USERDATA FACIAL ${userdata!.alias}');
  }

}
