import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iov/model/news.dart';
import 'package:iov/page/home_news_detail.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/widget/back_ios.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../api/api.dart';

class HomeNewsPage extends StatefulWidget {
  const HomeNewsPage({Key? key}) : super(key: key);

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

class _PageState extends State<HomeNewsPage> {
  @override
  void initState() {
    getNews(context);
    super.initState();
  }

  showDetail() {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const HomeNewsDetailPage(),
    );
  }

  List<News> listNews = [];

  getNews(BuildContext context) {
    Api.get(context, Api.news).then((value) => {
          if (value != null)
            {
              listNews = List.from(value['result']['news_management'])
                  .map((a) => News.fromJson(a))
                  .toList(),
              refresh()
            }
          else
            {}
        });
  }

  refresh(){
    setState(() {

    });
  }

  // List<News> datas = [
  //   News("ฮีโน่ฯ เดินหน้าสนับสนุน บุรีรัมย์",
  //       "ฮีโน่ดำเนินการส่งมอบรถโดยสารนักกีฬา พร้อมเดินทางไปคว้าชัย"),
  //   News("ฮีโน่ฯ เดินหน้าสนับสนุน บุรีรัมย์",
  //       "ฮีโน่ดำเนินการส่งมอบรถโดยสารนักกีฬา พร้อมเดินทางไปคว้าชัย")
  // ];
  //
  // List<News> datas2 = [
  //   News("โปรโมชั่น…. ฉลองปีใหม่!!! 🎉",
  //       "ทำงานวันแรกของปี แวะไปเติมพลังให้เต็มอิ่มที่ร้านกาแฟพันธุ์.."),
  //   News("โปรโมชั่น…. ฉลองปีใหม่!!! 🎉",
  //       "ทำงานวันแรกของปี แวะไปเติมพลังให้เต็มอิ่มที่ร้านกาแฟพันธุ์.."),
  // ];

  TabController? tabController;

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: TabBar(
              controller: tabController,
              tabs: const [
                Tab(text: "ข่าว"),
                Tab(text: "โปรโมชั่น"),
              ],
              indicatorColor: ColorCustom.primaryAssentColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.kanit(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              controller: tabController,
              children: [
                Container(
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    //physics:BouncingScrollPhysics(),
                    children: listNews
                        .map(
                          (data) => GestureDetector(
                              onTap: () {
                                showDetail();
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: Image.network(data.urlImage!)),
                                    const Text(
                                      "test",
                                      style: TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      "test",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    //physics:BouncingScrollPhysics(),
                    children: listNews
                        .map(
                          (data) => GestureDetector(
                              onTap: () {
                                showDetail();
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        "assets/images/promo1.png",
                                      ),
                                    ),
                                    const Text(
                                      "test",
                                      style: TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      "test",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
            Container(
              margin: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "แจ้งเตือน",
                style: TextStyle(
                  color: ColorCustom.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    color: ColorCustom.greyBG,
                  ),
                  child: InkWell(
                    onTap: () {
                      // showFilter();
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.filter_alt,
                          size: 15,
                          color: Colors.black,
                        ),
                        Text(
                          'กลุ่มรถ A',
                          style: TextStyle(
                            color: ColorCustom.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    color: ColorCustom.greyBG,
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Icon(
                          Icons.sort_by_alpha,
                          size: 15,
                          color: Colors.black,
                        ),
                        Text(
                          'เรียง',
                          style: TextStyle(
                            color: ColorCustom.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _tabSection(context)
          ],
        ),
      )),
    );
  }
}
