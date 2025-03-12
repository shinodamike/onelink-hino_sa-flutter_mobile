
import 'package:flutter/material.dart';
import 'package:iov/model/option_snapshot.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class HomeDetailOptionGalleryPage extends StatefulWidget {
  const HomeDetailOptionGalleryPage({Key? key, required this.optionSnapshots}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final List<OptionSnapshot> optionSnapshots;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeDetailOptionGalleryPage> {

  @override
  void initState() {
    super.initState();
  }


  refresh() {
    setState(() {});
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
      backgroundColor: Colors.black,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMe,
      //   label: Text('My location'),
      //   icon: Icon(Icons.near_me),
      // ),
      body: SafeArea(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.optionSnapshots[index].url!),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.1,
              // heroAttributes: HeroAttributes(tag: galleryItems[index].id),
            );
          },
          itemCount: widget.optionSnapshots.length,
          // loadingBuilder: (context, progress) => Center(
          //   child: Container(
          //     width: 20.0,
          //     height: 20.0,
          //     child: CircularProgressIndicator(
          //       value: _progress == null
          //           ? null
          //           : _progress.cumulativeBytesLoaded /
          //           _progress.expectedTotalBytes,
          //     ),
          //   ),
          // ),
          // backgroundDecoration: widget.backgroundDecoration,
          // pageController: widget.pageController,
          // onPageChanged: onPageChanged,
        ),
      ),
    );
  }
}
