
import 'package:flutter/material.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/widget/back_ios.dart';




class HomeNewsDetailPage extends StatefulWidget {
  const HomeNewsDetailPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeNewsDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMe,
      //   label: Text('My location'),
      //   icon: Icon(Icons.near_me),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const BackIOS(),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    "assets/images/news1.png",
                    fit: BoxFit.fitWidth,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          ColorCustom.black,
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: const Text(
                      "ฮีโน่ฯ เดินหน้าสนับสนุน บุรีรัมย์",
                      style: TextStyle(
                        color: ColorCustom.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        color: ColorCustom.greyBG,
                      ),
                      child: InkWell(
                        onTap: () {
                          // showFilter();
                        },
                        child: const Column(
                          children: [
                            Icon(
                              Icons.thumb_up_off_alt,
                              size: 20,
                              color: ColorCustom.primaryColor,
                            ),
                            Text(
                              'Like',
                              style: TextStyle(
                                color: ColorCustom.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        color: ColorCustom.greyBG,
                      ),
                      child: InkWell(
                        onTap: () {
                          // showFilter();
                        },
                        child: const Column(
                          children: [
                            Icon(
                              Icons.share,
                              size: 20,
                              color: ColorCustom.primaryColor,
                            ),
                            Text(
                              'Share',
                              style: TextStyle(
                                color: ColorCustom.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'บริษัท ฮีโน่มอเตอร์สเซลส์ (ประเทศไทย) จำกัด โดย ดลฤดี ศรีม่วง ผู้ช่วยกรรมการผู้จัดการใหญ่ ได้ร่วมส่งมอบรถโดยสารนักกีฬาปรับอากาศแบบ VIP 22 ที่นั่ง ให้กับสโมสร “ปราสาทสายฟ้า”',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 1, color: Colors.grey)),
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        "assets/images/iov_icon.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'iov Thailand',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '10 post · Updated last week',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
