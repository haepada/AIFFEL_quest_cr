import 'package:flutter/material.dart';
import 'FirstPage.dart'; // FirstPage import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: 'Navigation Example',
      home: FirstPage(), // 앱 시작 페이지 설정
    );
  }
}


/*
오류 및 개선

문제:
- FirstPage에서 `isCat = false;`로 설정한 후 SecondPage로 전달했지만, FirstPage로 돌아왔을 때 `isCat` 값이 원래대로 복구되지 않음.
- 둘 다 False가 나오거나 둘다 True 가 나오는 문제 발생
- 즉, SecondPage에서 `Navigator.pop(context, true);`로 반환했지만, FirstPage에서 그 값을 반영하지 않아 계속 `false`로 유지됨.

해결:
- `Navigator.push().then()`을 사용하여 SecondPage에서 반환된 값을 받아 `setState()`로 `isCat`을 업데이트하도록 수정.
- 즉, SecondPage에서 `Navigator.pop(context, true);`를 실행하면, FirstPage에서 `then((returnedValue) { setState(() { isCat = returnedValue; }); })`로 값을 반영함.
- `Navigator.push().then((returnedValue)`를 활용하면 이전 페이지에서 반환된 데이터를 받아 처리할 수 있다.
- 페이지 간 상태 전달 시, 돌아올 때 상태를 반영하려면 `Navigator.pop()`과 `then()`을 함께 활용해야 한다.

*/

/*
전승아 개인회고
- 의훈님과 문제에 대한 정의부터 같이 고민하면서 진행했다.
- 서로 코드를 교환하며 부족한 점을 보완.
- 중간에 True/False 가 계속 제대로 나오지 않는 문제가 발생했는데, (두개 다 true/ 두개 다 false)  서로 논의하며 원활하게 해결
- 협업의 과정은 생각하지 못한 개선점을 찾을 수 있게 되어서 뿌듯하다.

김의훈 개인회고
- 퀘스트는 개인적으로 코드를 짜고 그 후에 상의하는 방식으로 진행되었고,
- 화면 공유를 통해서 서로의 코드들을 확인하면서 진행하였다.
- 각각의 페이지들을 만들고 순탄하게 진행되었으나, 마지막에 isCat의 상태가 FirstPage 에서 True 로 나오는 것은 맞았는데, SecondPage 에서 False로 나와야할 부분이
  True로 나와서 오류를 해결하느라 시간을 쏟았다.
- 승아님의 진두지휘아래 많은 것을 함께하고 배울 수 있었던 퀘스트였다.

 */

