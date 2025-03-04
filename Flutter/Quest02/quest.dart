import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue, //(3) 색상 blue 추가
            title: Text("플러터 앱 만들기"), //(2) 앱바 중앙 플러터 앱 만들기 텍스트 추가
            centerTitle: true,
            leading: IconButton(
              onPressed: (){},
              icon: Icon(Icons.menu) //(1) 앱바 상단 아이콘 추가
            ),),
        body : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
                ElevatedButton( //(4) 텍스트 버튼 추가
                  onPressed: (){
                    print("버튼이 눌렸습니다.");}, //(4-2) 버튼 클릭 시 텍스트 출력
                  child: Text('Text')),
                SizedBox(height: 20), // 간격 추가
                Stack( //(5) 5개 컨테이너 추가/중첩처리
                  alignment: Alignment.topLeft, // 좌측 상단 기준 정렬
                  children: [
                    Container(width: 300, height: 300, color: Colors.blue),
                    Container(width: 240, height: 240, color: Colors.orange),
                    Container(width: 180, height: 180, color: Colors.red),
                    Container(width: 120, height: 120, color: Colors.green),
                    Container(width: 60, height: 60, color: Colors.yellow),
                ],
          ),],
        ),),
      ),);
  }
}

// 회고노트

// 오류 확인 및 개선

/* 1차. 앱바 구조 문제 해결
- 초기에는 앱바 내 아이콘과 텍스트를 Row 위젯을 사용하여 좌우 배치하려고 시도했음.
- 그러나 텍스트가 중앙 정렬되지 않는 문제 발생.
- 325페이지의 힌트를 참고하여 centerTitle: true 옵션을 추가하여 텍스트를 중앙에 정렬하고, 아이콘은 leading 속성을 활용하여 왼쪽에 배치함.
- 최종적으로 아이콘은 좌측, 텍스트는 중앙에 배치하는 형태로 해결됨.
//기존코드
            children: [
              FaIcon(FontAwesomeIcons.heart, size: 24, color: Colors.white),
              Text("플러터 앱 만들기"),
            ],
*/


/* 2차. 겹치는 박스 정렬 문제 해결
- Stack 위젯을 사용하여 컨테이너들을 겹쳐서 배치.
- 기본 정렬 방식인 Alignment.center 대신, Alignment.topLeft 를 사용하여 박스들이 왼쪽 상단을 기준으로 겹쳐지도록 조정.
- 이렇게 하여 가장 큰 박스를 기준으로 차례대로 내부에 작은 박스들이 겹쳐지는 형태를 구현함.

 */


/* 3차. 전체 화면 중앙 정렬 문제 해결
- 처음에는 Column만 사용하여 정렬하려 했으나, 전체 요소가 중앙에 위치하지 않는 문제가 발생.
- 해결 방법으로 body를 Center 위젯으로 감싸고, Column을 child로 추가하여 전체를 중앙에 배치함.
- mainAxisAlignment: MainAxisAlignment.center 옵션을 추가하여 세로 정렬을 조정함.
//기존코드
        body : Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children:[
              ElevatedButton(
                onPressed: (){
                  print("버튼이 눌렸습니다.");},
                child: Text('Text')),
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(width: 300, height: 300, color: Colors.blue),
                  Container(width: 240, height: 240, color: Colors.orange),
                  Container(width: 180, height: 180, color: Colors.red),
                  Container(width: 120, height: 120, color: Colors.green),
                  Container(width: 60, height: 60, color: Colors.yellow),

 */


// 개인 회고
// 전승아 - 종현님과 먼저 문제를 정의하고, 해당 과제를 차근차근 협업하며 해결해나갔습니다.
// 코딩의 매력은 생각한 것을 구현하고, 이를 상호작용을 통해 바로 피드백을 볼 수 있다는 점이 가낭 매력적인 부분입니다.
// 서로 부족한 부분은 보완하며 협업하는 과정이었습니다.