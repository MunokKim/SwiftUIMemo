# SwiftUI Memo App

> SwiftUI를 학습하며 만든 메모 애플리케이션

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-2.0-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)](https://www.apple.com/ios/)

---

## 학습 기록

[SwiftUI로 Memo 앱 만들기 - Medium 포스팅](https://munokkim.medium.com/mastering-swiftui-swiftui-memo-1-3-b583803ff765)

---

## 프로젝트 소개

2020년, SwiftUI가 막 등장했을 무렵 새로운 기술을 학습하기 위해 제작한 메모 애플리케이션입니다.

**KxCoding의 Mastering SwiftUI 강좌**를 수강하며 SwiftUI의 핵심 개념과 Combine 프레임워크, Core Data 연동 방법을 실습했습니다.

- **제작 기간**: 2020년 중반 (약 2주)
- **참여 인원**: 개인 프로젝트
- **학습 목표**: SwiftUI의 선언형 UI 패턴과 반응형 프로그래밍 이해

---

## 주요 기능

### 메모 관리
- 메모 작성 / 수정 / 삭제
- 메모 목록 보기
- Swipe to Delete 지원
- 작성 날짜 표시

### 데이터 저장
- Core Data를 이용한 영구 저장
- `@FetchRequest`를 통한 자동 데이터 동기화

### UI/UX
- SwiftUI의 선언형 UI
- 키보드 애니메이션 대응
- Modal & Navigation 화면 전환
- 2-way Data Binding

---

## 기술 스택

### 언어 & 프레임워크
- **Swift 5.0+**
- **SwiftUI 2.0**
- **Combine Framework** - 반응형 프로그래밍
- **Core Data** - 데이터 영구 저장

### 아키텍처 & 패턴
- **MVVM 패턴**
  - `MemoStore`: 메모 목록 관리 (ViewModel 역할)
  - `CoreDataManager`: Core Data CRUD 처리
- **Reactive Programming**
  - `@Published`, `@ObservedObject`, `@EnvironmentObject`를 활용한 상태 관리
  - Combine을 이용한 키보드 노티피케이션 바인딩

### SwiftUI 핵심 개념 적용
- `@State`, `@Binding` - 2-way binding
- `@EnvironmentObject` - 공유 데이터 주입
- `@ObservedObject` - 뷰 자동 업데이트
- `@FetchRequest` - Core Data Entity 자동 동기화
- `NavigationView` & `NavigationLink` - 화면 전환
- `sheet` modifier - Modal 표시
- `UIViewRepresentable` - UIKit TextView 통합

---

## 프로젝트 구조

```
SwiftUIMemo/
├── Model/
│   ├── Memo.swift              # Memo 모델 (Identifiable, ObservableObject)
│   ├── MemoStore.swift         # 메모 목록 관리 (ViewModel)
│   └── CoreDataManager.swift   # Core Data CRUD
├── View/
│   ├── MemoListView.swift      # 메모 목록 화면
│   ├── MemoCell.swift          # 메모 셀 (리팩토링된 Subview)
│   ├── MemoDetailView.swift    # 메모 상세 화면
│   └── WriteMemoView.swift     # 메모 작성/편집 화면
├── Component/
│   └── TextView.swift          # UITextView Wrapper (UIViewRepresentable)
└── Utility/
    ├── DateFormatter+Ext.swift # 날짜 포맷터 확장
    └── KeyboardNotification.swift # 키보드 노티피케이션 처리
```

---

## 주요 구현 사항

### 1. SwiftUI State Management

**@Published + @ObservedObject 패턴**
```swift
class Memo: ObservableObject, Identifiable {
    @Published var memoText: String
    let insertDate: Date
}

class MemoStore: ObservableObject {
    @Published var memoList: [Memo]
}
```

**@EnvironmentObject를 통한 데이터 공유**
- 여러 뷰에서 동일한 `MemoStore` 인스턴스 공유
- Modal 화면에도 `.environmentObject()` modifier로 주입

### 2. Core Data 연동

**@FetchRequest로 자동 동기화**
```swift
@FetchRequest(
    entity: Memo.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Memo.insertDate, ascending: false)]
)
var memoList: FetchedResults<Memo>
```

- Entity 변경 시 자동으로 UI 업데이트
- Core Data의 CRUD 작업을 `CoreDataManager`로 중앙화

### 3. Combine을 이용한 키보드 처리

**키보드 노티피케이션을 뷰에 바인딩**
```swift
class KeyboardNotification: ObservableObject {
    @Published var context: KeyboardContext

    // Combine을 이용해 willShow/willHide 노티피케이션 처리
    // → context 업데이트
    // → 뷰의 padding/animation에 자동 반영
}
```

### 4. UIKit 통합 (UIViewRepresentable)

**SwiftUI에서 UITextView 사용**
```swift
struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView { ... }
    func updateUIView(_ uiView: UITextView, context: Context) { ... }
}
```

---

## 기술적 챌린지 & 해결

### 1. Modal 화면에 EnvironmentObject 주입 문제

**문제**: Modal로 표시한 `WriteMemoView`에서 `MemoStore`에 접근 시 크래시 발생
```
Fatal error: No ObservableObject of type MemoStore found.
```

**원인**: Modal은 자동으로 상위 뷰의 EnvironmentObject를 상속받지 않음

**해결**:
```swift
.sheet(isPresented: $isPresentedWriter) {
    WriteMemoView(isPresentedWriter: self.$isPresentedWriter)
        .environmentObject(self.memoStore)  // 명시적 주입
}
```

### 2. 2-way Binding 구현

**학습 포인트**: `@State`와 `@Binding`의 차이 이해

- `@State`: 뷰 내부에서 값 소유 및 변경
- `@Binding`: 외부 값을 참조하여 변경 ($ prefix 사용)

```swift
// 부모 뷰
@State var isPresentedWriter: Bool = false
PlusButton(show: $isPresentedWriter)  // $로 Binding 전달

// 자식 뷰
@Binding var show: Bool
```

### 3. Core Data에서 SwiftUI로 마이그레이션

**과정**:
1. 초기에는 `Memo` 모델과 `MemoStore`로 In-Memory 관리
2. Core Data Entity 추가
3. `@FetchRequest`로 전환하여 자동 동기화 구현

**배운 점**: SwiftUI의 `@FetchRequest`는 UIKit의 `NSFetchedResultsController`보다 훨씬 간결

---

## 학습 내용

이 프로젝트를 통해 다음을 학습했습니다:

### SwiftUI 핵심 개념
- Property Wrappers (`@State`, `@Binding`, `@ObservedObject`, `@EnvironmentObject`, `@Published`, `@FetchRequest`)
- 선언형 UI 작성
- View Composition (Subview 분리)
- Navigation (NavigationView, NavigationLink, sheet)

### Combine Framework
- Publisher/Subscriber 패턴
- 노티피케이션을 Combine으로 처리
- 반응형 프로그래밍 기초

### Core Data
- SwiftUI에서 Core Data 연동
- `@FetchRequest`를 통한 자동 동기화
- CRUD 구현

### UIKit 통합
- `UIViewRepresentable`을 이용한 UIKit 뷰 통합

---

## 실행 방법

### 요구 사항
- Xcode 12.0+
- iOS 14.0+
- Swift 5.0+

### 설치 및 실행
```bash
# 1. 저장소 클론
git clone https://github.com/MunokKim/SwiftUIMemo.git

# 2. 프로젝트 열기
cd SwiftUIMemo
open SwiftUIMemo.xcodeproj

# 3. Xcode에서 실행 (⌘ + R)
```

---

## 회고

### 잘한 점
- SwiftUI가 막 출시된 시점에 빠르게 학습 시작
- 학습 내용을 Medium 블로그로 정리하여 기록
- Core Data 연동까지 완성하여 실용적인 앱 완성

### 개선할 점
- 단일 커밋으로 업로드하여 개발 과정이 보이지 않음
- README 부재로 프로젝트 설명 누락
- Unit Test 미작성

### 만약 다시 만든다면?
- **SwiftUI 3.0+ 기능 활용**: `@FocusState`, `task` modifier 등
- **MVVM 더 명확하게**: ViewModel 분리 강화
- **TCA (The Composable Architecture) 적용**: 상태 관리 체계화
- **Unit Test 작성**: ViewModel 로직 테스트
- **Git 커밋 세분화**: 기능별로 나눠서 커밋
