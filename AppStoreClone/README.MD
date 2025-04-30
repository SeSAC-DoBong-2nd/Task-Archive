# 박신영\_AppStore Clone

### 각 화면

[화면 GIF PR 첨부](https://github.com/SeSAC-DoBong-2nd/Task-Archive/pull/18)

### 주요 기능

1. 앱 검색
   - ITunes API를 활용한 실시간 앱 검색
   - 무한 스크롤(페이지네이션)
   - 검색 결과 리스트 및 상세 정보 진입
2. 앱 다운로드/설치/삭제 시뮬레이션
   - 다운로드 버튼(받기/다운로드중/재개/열기/다시받기)
   - 다운로드 진행률, 일시정지/재개, 설치/삭제 상태 관리
   - 다운로드 상태는 UserDefaults에 영구 저장
3. 앱 아카이브(설치된 앱 목록)
   - 설치된 앱만 필터링
   - 검색 및 삭제(다시받기) 지원
4. 앱 상세 정보
   - 앱 아이콘, 이름, 버전, 새로운 소식(릴리즈 노트), 미리보기(스크린샷)
   - 릴리즈 노트 3줄 초과 시 "더 보기" 기능
   - 스크린샷 상세 뷰
5. 네트워크 상태 감지 및 대응
   - NWPathMonitor + Ping(HTTP) 기반 네트워크 감지
   - 네트워크 단절 시 모든 화면에 오버레이 안내
   - 네트워크 단절 시 다운로드 자동 일시정지, 복구 시 자동 재개
   - 네트워크 요청 실패 시 즉시 오버레이 표시
6. SwiftUI & MVVM 아키텍처
   - 각 화면별 ViewModel 분리
   - Combine 기반 상태 관리

### 폴더구조

```swift
AppStoreClone/
├── App/                # 앱 진입점(AppStoreCloneApp.swift)
├── Presentation/       # 모든 화면 및 UI 컴포넌트
│   ├── Search/         # 검색 화면, 검색 결과, SearchViewModel
│   ├── AppDetail/      # 앱 상세, 상세 컴포넌트, AppDetailViewModel
│   ├── AppArchive/     # 설치앱 목록, AppArchiveViewModel
│   └── UIComponent/    # 공통 UI(다운로드 버튼 등)
├── Data/               # 모델, 데이터 구조체
├── Utility/            # AppDownloadManager, NetworkMonitor 등
├── Resource/           # 이미지, 리소스
└── ...
```

### 기술 스택

- Swift 5.7+ / SwiftUI (iOS 16+)
- Combine (상태 관리, MVVM)
- NWPathMonitor, URLSession[ping] (네트워크 감지)
- UserDefaults (상태 영속화)
- ITunes API (앱 검색 등)

### 주요 아키텍처/구현 포인트

- MVVM + Combine 아키텍처 적용: 각 화면별로 ViewModel을 분리하여 상태와 비즈니스 로직을 관리하고 Combine 기반 상태 관리로 데이터 바인딩과 단방향 데이터 흐름을 적용해 UI와 로직의 결합도를 낮추고, 테스트와 유지보수를 용이하게 했습니다.
- 신뢰성 높은 네트워크 감지: NWPathMonitor와 HTTP Ping을 함께 사용하여 네트워크 연결 상태를 이중으로 확인합니다. 시스템 네트워크 상태뿐 아니라 실제 인터넷 접근 가능성까지 체크해, 네트워크 단절 시 오버레이 안내와 다운로드 일시정지 등 사용자 경험을 개선했습니다.
- 다운로드 상태 중앙 관리: AppDownloadManager 싱글톤에서 다운로드 진행률, 일시정지/재개, 설치/삭제 등 모든 상태를 통합 관리합니다. Observable 패턴을 통해 UI에 실시간 반영하며, 백그라운드 작업과 상태 영구 저장을 지원해 앱 재시작 시에도 일관된 경험을 제공합니다.

<br>

ps: '받기' 상태의 버튼 색상은 그런 색상이어야 더 좋을 것 같아 일부러 바꿔보았습니다..!
