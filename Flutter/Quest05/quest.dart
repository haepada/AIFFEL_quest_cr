import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(JellyfishClassifierApp());
}

class JellyfishClassifierApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF6A40FF), // 변경된 색상
        scaffoldBackgroundColor: Color(0xFF6A40FF), // 배경 색상 조정
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF6A40FF), // 앱바 색상 변경
          foregroundColor: Colors.white,
        ),
      ),
      home: JellyfishClassifierScreen(),
    );
  }
}

class JellyfishClassifierScreen extends StatefulWidget {
  @override
  _JellyfishClassifierScreenState createState() => _JellyfishClassifierScreenState();
}

class _JellyfishClassifierScreenState extends State<JellyfishClassifierScreen> {
  String resultText = "결과가 여기에 표시됩니다";

  Future<void> getPredictionClass() async {
    final url = Uri.parse('https://77fa-35-247-72-71.ngrok-free.app/predict/class');

    try {
      print("📢 서버 요청 시작: $url");
      final response = await http.get(url);

      print("📢 응답 코드: ${response.statusCode}");
      print("📢 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          resultText = "예측 클래스: ${data['predicted_class']}";
        });
      } else {
        print("❌ 서버 오류 발생: ${response.statusCode}");
        setState(() {
          resultText = "서버 오류 발생: ${response.statusCode}";
        });
      }
    } catch (e) {
      print("❌ 서버 연결 실패: $e");
      setState(() {
        resultText = "서버 연결 실패";
      });
    }
  }

  Future<void> getPredictionProbability() async {
    final url = Uri.parse('https://77fa-35-247-72-71.ngrok-free.app/predict/probability');

    try {
      print("📢 서버 요청 시작: $url");
      final response = await http.get(url);

      print("📢 응답 코드: ${response.statusCode}");
      print("📢 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          resultText = "예측 확률: ${data['probability']}";
        });
      } else {
        print("❌ 서버 오류 발생: ${response.statusCode}");
        setState(() {
          resultText = "서버 오류 발생: ${response.statusCode}";
        });
      }
    } catch (e) {
      print("❌ 서버 연결 실패: $e");
      setState(() {
        resultText = "서버 연결 실패";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jellyfish Classifier'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo-removebg-preview.png', height: 30, width: 30),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/image.webp',
              height: 250,
              width: 250,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            resultText,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(20),
                child: IconButton(
                  icon: Icon(Icons.play_arrow, size: 40, color: Colors.white),
                  onPressed: getPredictionClass,
                ),
              ),
              SizedBox(width: 40),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(20),
                child: IconButton(
                  icon: Icon(Icons.play_arrow, size: 40, color: Colors.white),
                  onPressed: getPredictionProbability,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
