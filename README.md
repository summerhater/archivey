
---
# <p align="center">아카이비 archivey</p>

### <p align="center">📁 수집의 재발견, AI가 요약하고 태그하는 링크 아카이빙 서비스</p>

![](https://velog.velcdn.com/images/brchoi97/post/f063a67e-cf69-418b-8b0f-f6e5ef4e5009/image.png)

**<p align="center"><a href="https://apps.apple.com/kr/app/%EC%95%84%EC%B9%B4%EC%9D%B4%EB%B9%84-archivey/id6758512074" target="_blank">App Store (iOS)</a>&nbsp;&nbsp; | &nbsp;&nbsp;Google Play (Android) - 심사 중&nbsp;&nbsp; | &nbsp;&nbsp;<a href="https://m.onestore.co.kr/v2/ko-kr/app/0001004476" target="_blank">ONE Store (Android)</a></p>**

---
### 목차
1. [프로젝트 개요](#1-프로젝트-개요)
2. [프로젝트 소개](#2-프로젝트-소개)
    - [1) 프로젝트 배경](#1-프로젝트-배경)
    - [2) 프로젝트 목표](#2-프로젝트-목표)
3. [주요 기능 및 페이지 구성](#3-주요-기능-및-페이지-구성)
    - [1) 회원가입 및 로그인](#1-회원가입-및-로그인)
    - [2) 수집물 추가하기](#2--수집물-추가하기)
    - [3) 대분류-소분류 카테고리](#3-대분류-소분류-카테고리)
    - [4) 수집물 목록과 검색 기능 (FTS)](#4-수집물-목록과-검색-기능-fts)
    - [5) 외부 공유하기](#5-외부-공유하기)
    - [6) 설정](#6-설정)
4. [인프라 아키텍처](#4-인프라-아키텍처)
5. [개발 환경](#5-개발-환경)
    - [1) 기술 스택](#1-기술-스택)
    - [2) 핵심 패키지](#2-핵심-패키지)
6. [팀원 소개](#6-팀원-소개)
7. [Technical Deep Dive (개발 문서)](#7-technical-deep-dive-개발-문서)
8. [프로젝트 결과 및 성과](#8-프로젝트-결과-및-성과)
9. [개선 사항 및 추후 계획](#9-개선-사항-및-추후-계획)

---

<br>

## 1. 프로젝트 개요
* **프로젝트명**: 아카이비 (archivey)
* **진행 기간**: 2025.12 - 2026.02 (8주)
* **프로젝트 형태**: 2인 팀 프로젝트 (최란 / 이우형)
* **목표**: 여기저기 흩어져 있어 다시 찾기 힘든 링크들을 자동으로 한데 모아 찾는 번거로움은 줄이고 읽는 즐거움은 더하도록, 무거운 기능대신 기록과 탐색의 번거로움을 최소화한 생산성 앱을 목표
* **주요 타겟**: 
    - 다양한 플랫폼(인스타, 유튜브, 뉴스, 웹 등)에서 정보를 수집하는 헤비 유저
    - 저장한 링크를 어디 저장했는지 다시 찾지 못해 어려움을 겪는 사용자
    - 링크를 한데 모아 체계적으로 정리 할 수 있는 아카이브를 구축하고 싶은 생산성 도구 사용자

<br>

## 2. 프로젝트 소개

#### 1) 프로젝트 배경
우리는 날마다 유익한 정보를 발견합니다. 인스타그램에 저장하거나 유튜브에서 '좋아요'를 누르고 나중에 찾아보기도 하고, 카카오톡 '나에게 보내기'로 키워드를 달아 링크를 보내두기도 하죠. 이렇게 여러 곳에 흩어져 저장된 링크들은 막상 필요할 때 찾기 어렵고 결국 잊히기 마련입니다.

저희는 "나중에 보려고 저장했지만, 정작 어디에 있는지 몰라 한참을 뒤적거리는 번거로움"을 해결하고 싶었습니다. 모든 기능을 다 담은 무거운 도구보다는, 정보를 저장하고 다시 꺼내 보는 그 짧은 순간이 조금이라도 더 편안해지는 서비스를 만들고자 아카이비를 기획했습니다.

#### 2) 프로젝트 목표
* **통합 관리**: 분산된 콘텐츠 링크를 한곳에서 카테고리별로 관리
* **검색성 극대화**: Firebase Gemini를 활용한 자동 요약 및 태그 생성으로 빠른 정보 재접근 지원
* **끊김 없는 경험**: Share Extension을 통한 즉각적인 수집과 오프라인 우선 저장 전략(Local-first) 실천

<br>

## 3. 주요 기능 및 페이지 구성

#### 1) 회원가입 및 로그인
* **회원가입**: 
	- 서비스 이용약관 및 개인정보 처리방침 동의 -> 이메일 입력 -> 비밀번호 입력 -> 이메일 인증 순

* **로그인**: 이메일 / 비밀번호
    - 로그인 성공 시 Index(카테고리 목록) 페이지로 이동

<p align="center"><img src="https://velog.velcdn.com/images/brchoi97/post/d27bc267-2156-4840-b529-269175a03f15/image.gif" width="250"/> <img src="https://velog.velcdn.com/images/brchoi97/post/d27bc267-2156-4840-b529-269175a03f15/image.gif" width="250"/> <img src="https://velog.velcdn.com/images/brchoi97/post/d27bc267-2156-4840-b529-269175a03f15/image.gif" width="250"/></p>

<br>

#### 2) 수집물 추가하기
* **AI 콘텐츠 분석 및 링크 저장** : AI 콘텐츠 분석 및 링크 저장
    - **백그라운드 AI 분석**: Gemini 2.5 Flash 기반 콘텐츠 자동 분석
    - **유동적 프롬프트 전략**: 데이터 품질에 따른 프롬프트 최적화로 정교한 요약 및 태그 추출
    - **로컬 우선 저장**: SQLite(Drift)에 즉시 저장하여 사용자에게 기다림 없는 응답성 제공
    - **실시간 동기화**: Firestore-로컬 DB 간 타임스탬프 기반 동기화로 여러 기기에서 수정 사항 즉시 반영
    

* **Share Extension 기반 링크 수집** : 모바일 환경 특성 활용 사용자 경험 최적화
    - **즉시 수집**: 외부 앱/브라우저에서 '공유하기' 선택 시 앱으로 즉시 진입 및 URL 자동 완성
    - **유연한 입력**: 공유하기 미지원 콘텐츠를 위한 클립보드 복사-붙여넣기 기능 지원

#### 3) 대분류-소분류 카테고리
* **대분류 카테고리**
    - `All 탭 - Index 페이지`에서 오른쪽 하단의 '새 카테고리 추가' 버튼으로 추가 가능
    - 메뉴 아이콘 또는 카테고리 목록을 드래그해 카테고리 순서 변경 가능  
    - 카테고리의 순서는 오른쪽 세로 네비게이션과 1:1 맵핑. 편의성에 따라 자주 확인하는 카테고리 상단 배치 가능.
    - 더보기 아이콘 : 카테고리 수정 / 삭제, 카테고리 공유하기
    - **카테고리 공유하기**
    	- **크로스 플랫폼 개발을 통한 웹 배포**로 제3자에게 URL 링크 형태로 카테고리 공유 가능
       - 제3자도 카테고리 내 필터링 / 검색 가능


* **소분류 카테고리**
    - 해당 대분류 카테고리 안에서 `+` 아이콘으로 추가 가능
    - 카테고리 수정 / 삭제 : 해당 소분류 카테고리 Long Tap시 가능

#### 4) 수집물 목록과 검색 기능(FTS)
* **Drift FTS**: 서버 통신 없이 제목, 요약, 메모, 태그를 아우르는 빠른 통합 검색 구현
* **실시간 동기화**: Firestore-로컬 DB 간 타임스탬프 기반 동기화로 여러 기기에서 수정 사항 즉시 반영

#### 5) 외부 공유하기
* **수집물 공유하기**
    - Kakao SDK 및 클립보드 복사를 통한 수집물 원문 링크 공유
* **카테고리 공유하기**
    - **웹 호스팅 공유**: Kakao SDK 및 크로스 플랫폼 개발을 통한 Web Hosting으로 공유 URL 링크 제공
    	- 앱 미설치자도 공유받은 수집물 조회 / 검색 / 필터링 가능
        
#### 6) 설정
* 로그아웃 / 탈퇴 / 공지사항 / 문의하기 / 앱 버전 / 약관 및 정책

<br>

## 4. 인프라 아키텍처
아카이비는 확장 가능한 **MVVM 패턴**과 서버리스 환경을 결합하여 구축되었습니다.

* **Frontend**: Flutter (iOS, Android, Web 크로스 플랫폼)
* **State Management**: Provider 6.1.5 (의존성 주입 및 전역 상태 관리)
* **Database**: SQLite3 + Drift (로컬), Cloud Firestore (서버)
* **Backend**: Firebase (Authentication / Cloud Functions (Proxy Server for Web) / Hosting)
* **AI Engine**: Firebase Gemini 2.5 Flash

<br>

## 5. 개발 환경

#### 1) 기술 스택
| Category | Stack |
|----------|-------|
| **Frontend** | <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=Flutter&logoColor=white"> <img src="https://img.shields.io/badge/Provider-0175C2?style=for-the-badge&logo=Dart&logoColor=white"> |
| **Backend** | <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=Firebase&logoColor=black"> <img src="https://img.shields.io/badge/Firebase%20Auth-FFCA28?style=for-the-badge&logo=Firebase&logoColor=black"> <img src="https://img.shields.io/badge/Cloud%20Firestore-FFCA28?style=for-the-badge&logo=Firebase&logoColor=black"> <img src="https://img.shields.io/badge/Cloud%20Functions-FFCA28?style=for-the-badge&logo=Firebase&logoColor=black"> |
| **Database** | <img src="https://img.shields.io/badge/SQLite3-003B57?style=for-the-badge&logo=SQLite&logoColor=white"> <img src="https://img.shields.io/badge/Drift-0175C2?style=for-the-badge&logo=Dart&logoColor=white"> |
| **AI** | <img src="https://img.shields.io/badge/Gemini%202.5%20Flash-8E75B2?style=for-the-badge&logo=Google&logoColor=white"> |

#### 2) 핵심 패키지
* **Navigation**: `GoRouter`
* **통신**: `html`, `http`, `metadata_fetch`
* **Local DB**: `drift`, `sqlite3_flutter_libs`
* **Sharing**: `kakao_flutter_sdk`, `flutter_sharing_intent`
* **UI/UX**: `shimmer`, `flutter_native_splash`, `flutter_svg`

<br>

## 6. 팀원 소개

| 이름 | 역할 | 수행 업무 |
| :--- | :--- | :--- |
| **최란** | **Full-Cycle Dev<br>**팀장 | • 서비스 기획 총괄 및 UI/UX 디자인 <br> • 앱 화면 70% 이상 구현 및 모듈화 FE 개발 <br> • Gemini 기반 AI 파이프라인 및 데이터 아키텍처 설계 BE 개발 <br> • Firebase 서버리스 인프라 구축 및 출시 프로세스 총괄 |
| **이우형** | **Core BE Dev<br>**팀원 | • 로컬 데이터베이스 연동 및 오프라인 동기화 로직 구현 <br> • 성능 중심의 기술 아키텍처 설계 <br> • 회원가입 및 로그인 FE/BE 개발 <br> • 서비스 안전 이용 가이드 및 체계 수립 |

<br>

## 7. Technical Deep Dive (개발 문서)
기술적 한계를 극복하고 아키텍처를 개선한 과정을 상세히 기록했습니다.

* [📂 CORS 제약 극복 및 Cloud Functions Proxy 구축](docs/cors_proxy.md)
* [📂 제약 조건 내 가용성을 극대화한 적응형 AI 요약 시스템](docs/adaptive_ai.md)
* [📂 AppState 도입을 통한 상태 관리 아키텍처 개선](docs/app_state.md)
* [📂 위젯 리빌드 최적화를 통한 UI 렌더링 성능 개선](docs/ui_performance.md)

<br>

## 8. 프로젝트 결과 및 성과
* **공식 앱 출시**: Apple AppStore 및 ONE Store 정식 런칭 및 운영 중 (2026.02 ~) / Google PlayStore 심사 중
* **우수 프로젝트 선정**: 청년취업사관학교(SeSAC) 우수 프로젝트 선정
* **기술적 도달**: 
    - 단순 기능 구현을 넘어 **'사용자에게 닿는 기술'**에 집중하여 실사용 상용 서비스 구축
    - Provider 기반의 중앙 집중식 상태 관리 도입으로 복잡한 데이터 흐름 제어 성공

<br>

## 9. 개선 사항 및 추후 계획
* **플랫폼 최적화**: 다크 모드 지원 및 태블릿 전용 UI 최적화로 UX 강화
* **소셜/협업 확장**: SNS 간편 로그인(OAuth) 도입 및 카테고리 공동 편집 기능 추가
* **AI 고도화**: AI 파이프라인 강화와 OpenAI Whisper 연동 등 고도화 방안 검토 후 영상 오디오 분석 및 이미지 텍스트 요약 기능 추가
* **성능 고도화**: 이미지 Lazy Loading 및 디스크 캐싱 전략 개선을 통한 네트워크 리소스 최적화

---
**Team Archivey**
기록은 모을 때가 아니라, 다시 볼 때 비로소 가치가 생깁니다.

<img width="1500" height="300" alt="archivey_cover" src="https://github.com/user-attachments/assets/11417546-5fa3-4535-930f-b66cd60902bc" />
