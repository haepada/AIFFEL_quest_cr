import 'package:flutter/material.dart';
import 'SecondPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool isCat = true; // 초기값 true

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.cat),
            onPressed: () {}, // FirstPage에서는 뒤로 가기 필요 없음
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // "Next" 버튼
            ElevatedButton(
              onPressed: () {
                print("Next 버튼 클릭 - 현재 isCat 상태: $isCat");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(isCat: false), // SecondPage로 false 전달
                  ),
                ).then((returnedValue) {
                  if (returnedValue != null) {
                    setState(() {
                      isCat = returnedValue; // SecondPage에서 돌아온 값 적용
                      print("돌아온 후 isCat 상태: $isCat");
                    });
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: Text('Next'),
            ),
            SizedBox(height: 20),

            // 고양이 이미지 출력
            GestureDetector(
              onTap: () {
                print("고양이 이미지 클릭 - 현재 isCat 상태: $isCat");
              },
              child: Image.network(
                'https://cdn.pixabay.com/photo/2017/11/09/21/41/cat-2934720_960_720.jpg',
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
