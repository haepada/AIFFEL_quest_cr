import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SecondPage extends StatelessWidget {
  final bool isCat;

  const SecondPage({Key? key, required this.isCat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.dog),
            onPressed: () {
              print("AppBar 아이콘 클릭 - 현재 isCat 상태: $isCat");
              Navigator.pop(context, true); // 돌아갈 때 true로 설정
            },
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // "Back" 버튼
            ElevatedButton(
              onPressed: () {
                print("Back 버튼 클릭 - 현재 isCat 상태: $isCat");
                Navigator.pop(context, true); // 돌아갈 때 true로 설정
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: Text('Back'),
            ),
            SizedBox(height: 20),

            // 강아지 이미지 출력
            GestureDetector(
              onTap: () {
                print("강아지 이미지 클릭 - 현재 isCat 상태: $isCat");
              },
              child: Image.network(
                'https://cdn.pixabay.com/photo/2017/09/25/13/12/dog-2785074_960_720.jpg',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
