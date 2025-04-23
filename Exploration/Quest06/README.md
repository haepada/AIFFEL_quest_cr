# StableDiffusion ControlNet 이미지 생성 실험

## 개요
Diffusers 라이브러리의 버전 차이(0.31 vs 0.33)에 따른 ControlNet 이미지 생성 결과 비교 및 다중 ControlNet 적용 실험 프로젝트입니다.

## 주요 실험
1. **버전 차이 비교**: 동일한 코드와 프롬프트("disco dancer with colorful lights")로 다른 버전에서 실행했을 때 결과물 차이 분석
2. **다중 ControlNet**: OpenPose와 Canny 엣지 감지를 동시에 적용한 이미지 생성

## 주요 발견
- Diffusers 0.33 버전은 0.31 버전보다 더 자연스럽고 완성도 높은 이미지를 생성
- 0.33에서 도입된 메모리 최적화, 캐싱 메커니즘, 양자화 개선이 이미지 품질 향상에 기여
- 다중 ControlNet 적용 시 각 조건에 가중치를 다르게 부여하여 결과물을 조절 가능

## 실행 환경
- Google Colab 및 아이펠 LMS 환경
- Diffusers 라이브러리 (0.31, 0.33 버전)
- PyTorch with CUDA

## 향후 연구 방향
- 다양한 ControlNet 모델 조합 실험
- 최적의 조건부 가중치 탐색
- 다양한 스케줄러 비교 실험
