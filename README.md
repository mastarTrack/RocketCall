# 🚀 RocketCall

> 우주 테마를 적용한 시간 관리 iOS 앱  
> 알람, 타이머(미션), 스톱워치(자유 항행) 기능을 통해 시간을 더 몰입감 있게 관리할 수 있도록 돕는 앱

<br>

## ✨ 프로젝트 소개

**RocketCall**은 단조로운 기본 시계 앱의 경험에서 벗어나,  
**우주 항행**이라는 컨셉을 기반으로 시간을 더 재미있고 직관적으로 관리할 수 있도록 기획한 앱입니다.

사용자는 단순히 시간을 재는 것이 아니라,  
하나의 미션을 수행하듯 알람을 설정하고, 타이머를 진행하고, 자유롭게 항행하듯 스톱워치를 사용할 수 있습니다.

- **프로젝트명**: RocketCall
- **팀명**: Alarara
- **개발 기간**: 2026.03.20 ~ 2026.03.30

<br>

## 🎯 기획 배경

기본 알람/타이머 앱은 필수 기능은 충분하지만,  
사용자가 시간을 **몰입감 있게 경험하도록 돕는 요소**는 부족하다고 느꼈습니다.

RocketCall은 이 지점에서 출발했습니다.

- 시간 관리를 더 재미있게 만들 수 없을까?
- 뽀모도로, 알람, 스톱워치를 하나의 통일된 컨셉으로 묶을 수 없을까?
- 단순한 기능 앱이 아니라, 사용자가 상태와 흐름을 체감할 수 있는 앱을 만들 수 없을까?

이 고민을 바탕으로 **“시간 = 우주 항행”** 이라는 컨셉을 적용했습니다.

<br>

## 🌌 핵심 컨셉

> **시간 = 우주 항행**

RocketCall은 시간을 하나의 우주 미션처럼 해석합니다.

- **알람**: 발사 카운트다운
- **타이머**: 계획된 미션 수행
- **스톱워치**: 자유 항행
- **홈 화면**: 기록과 현재 상태를 확인하는 관제 센터

이렇게 각각의 기능을 하나의 세계관 안에서 자연스럽게 연결하고자 했습니다.

<br>

## 🛠 주요 기능

### 1. 홈 화면
- 주간 기록 표시
- 가장 가까운 알람 표시

### 2. 알람 기능
- 알람 리스트 확인
- 알람 On / Off
- 알람 추가 / 수정 / 삭제
- 시간 설정
- 반복 설정
- 레이블 이름 및 설명 입력
- 사운드 설정
  - 햅틱
  - 기본 사운드
  - 보관함 노래 선택
- 다시 알림 설정

### 3. 타이머 기능 (미션)
- 미션 리스트 확인
- 시작 / 중지
- 수정 / 삭제
- 멀티 타이머 기능
- 신규 등록 화면
  - 빠른 선택 메뉴
  - 커스텀 설정
- 진행 화면
  - 진행 애니메이션
  - 현재 진행 시간 표시

### 4. 스톱워치 기능 (자유 항행)
- 시작 / 일시정지 / 중단
- Lap 기록
- 재설정

<br>

## 🧩 도전 기능 / 확장 아이디어

다음 기능은 실제 구현 기능과 별도로, 프로젝트 확장 방향으로 기획한 아이디어입니다.

- 미션 달성 시 **NASA API 기반 이미지 보상**
- **Dynamic Island** 활용
- 세계 시계 기능 확장
- 미션 로그 카드
- 위젯 지원
- 우주 앰비언트 사운드

<br>

## 🏗 기술 스택

### Language
- Swift

### UI
- UIKit

### Architecture
- MVVM
- RxSwift Input / Output Pattern

### Persistence
- CoreData

### Library
- RxSwift
- SnapKit
- Then
- Lottie

### Collaboration
- GitFlow
- PR Review
- Gemini Code Assist

<br>

## 📁 폴더 구조

```bash
RocketCall
├── Model
│   ├── CoredataEntity
│   ├── AlarmModel
│   ├── CoreDataManager
│   ├── NotificationManager
│   ├── Payload
│   └── Model
│
├── Util
│   ├── TimeContainerView
│   ├── BaseCardView
│   ├── CircleButton
│   ├── GradientProgressView
│   ├── TitleView
│   └── UIViewController+
│
├── View
│   ├── Alarm
│   ├── HomeTab
│   │   ├── Controller
│   │   └── View
│   ├── Mission
│   │   ├── Create
│   │   ├── List
│   │   └── MissionResultView
│   ├── Stopwatch
│   └── TimerAnimationView
│
├── ViewModel
│   ├── AlarmListViewModel
│   ├── AlarmSettingViewModel
│   ├── CreateMissionViewModel
│   ├── HomeViewModel
│   ├── MissionViewModel
│   ├── StopWatchViewModel
│   ├── TimerAnimationViewModel
│   ├── TimerViewModel
│   └── ViewModelProtocol
│
├── AppDelegate
├── SceneDelegate
└── Assets
```

<br>

## 🧠 아키텍처

RocketCall은 MVVM 아키텍처를 기반으로 구현했습니다.

### View
- 사용자 입력을 받고 화면을 구성
- ViewModel의 Output을 바인딩하여 UI를 갱신
### ViewModel
- View에서 전달한 Input을 기반으로 비즈니스 로직을 처리
- 가공된 상태를 Output으로 전달
### Model / Data Layer
- CoreData를 통한 데이터 저장
- 알림 관련 로직 관리
- 필요한 데이터 모델 및 Payload 관리

특히 상태 변화와 이벤트 흐름이 많은 프로젝트 특성상 RxSwift Input / Output 패턴을 활용해 화면과 로직의 흐름을 더 명확히 나누고자 했습니다.

<br>

## 💡 기술적 의사결정

### 1. MVVM 적용
- 기능이 알람, 타이머, 스톱워치, 홈 화면으로 나뉘어 있었기 때문에 화면 로직과 비즈니스 로직을 분리할 필요가 있었습니다.
- MVVM을 적용해 각 계층의 역할을 명확히 나누고, 기능별로 ViewModel을 분리해 유지보수성과 확장성을 높이고자 했습니다.

### 2. RxSwift Input / Output 패턴 사용
- 이번 프로젝트는 단순 화면 구성보다상태 변화, 사용자 입력, 타이머 흐름, 화면 바인딩이 중요한 프로젝트였습니다. 그래서 ViewController가 직접 모든 상태를 처리하기보다, Input을 전달하고 Output을 구독하는 구조로 구성해 흐름을 더 예측 가능하게 만들었습니다.

### 3. CoreData 활용
- 알람, 미션, 기록 등의 데이터를 로컬에 저장하고 관리하기 위해 CoreData를 사용했습니다.

### 4. 공통 컴포넌트 분리
- TitleView, BaseCardView, GradientProgressView 등 공통 UI 컴포넌트를 별도로 분리하여 재사용성을 높이고 화면별 일관성을 유지하고자 했습니다.

<br>

## 👨‍👩‍👧‍👦 팀원 및 역할
|이름 | 담당 |
|:-:|:-:|
|한주헌	| 스톱워치 |
|변예린	| 메인 화면 |
|장예슬	| 타이머 진행 화면(애니메이션) |
|손영빈	| 타이머 화면 |
|김주희	| 알람 화면 |
|공통 | SA 작성, 스크럼 일지 정리 |

<br>

## 🤝 협업 방식
- Scrum
 - 오전 스크럼 (11:00): 회의 및 코드 리뷰
 - 저녁 스크럼 (20:00): 진행 상황 공유
- PR 규칙
 - 모닝스터디 이후 코드리뷰 진행
 - 필요 시 추가 PR 시간 운영
 - Approval 2명 이상 시 Merge
 - Merge 전 팀원 공유
 - AI 리뷰어는 보조적으로만 활용
 - Branch Strategy
 - GitFlow 전략 사용
 - 브랜치 예시: feature/Alarm#1

<br>

## ✅ 코딩 컨벤션

- API Design Guidelines 기본 준수
- camelCase 사용
- 약어 사용 지양
- 접근 제어자 명시
- 기능 및 화면 기준 디렉토리 분리
- // MARK:를 활용한 구분
- extension 단위로 기능 분리
- 커밋 단위 세분화

<br>

## ✅ 커밋 컨벤션

- 🌟feat : 기능 추가
- ♻️refactor : 기능 개선 / 전면 수정
- ✅test : 테스트 추가
- 🩹chore : 네이밍, 컨벤션 등 수정
- 🐛fix : 오류 수정
- 📝docs : 문서 추가 및 수정
- 🚚build : 파일 이동 및 추가

<br>

## 🔭 향후 개선 방향

- NASA API를 활용한 보상형 UX 강화
- Dynamic Island 연동
- 세계 시계 기능 추가
- 미션 로그 카드 제공
- 위젯 지원
- 더 풍부한 애니메이션 및 사운드 연출

<br>

## 🔗 Links

- GitHub: https://github.com/mastarTrack/RocketCall
- Figma: https://www.figma.com/design/ANioKmtZXqKMIYPgXVLUmH/제목-없음
