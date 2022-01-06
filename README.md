# Exposition-Universelle
## Information
* 프로젝트 기간 : 2021.07.05. ~ 2021.07.16.
* 프로젝트 인원 : 3명 Marco(@Keeplo), Soll(@soll4u), Yescoach(@YesCoach)
* 프로젝트 소개 
    > 1900 파리 만국박람회 기본 정보와 한국 출품작을 리스트로 소개해주는 앱
* Pull Requests
    * [Step 1](https://github.com/yagom-academy/ios-exposition-universelle/pull/86)
    * [Step 2](https://github.com/yagom-academy/ios-exposition-universelle/pull/97)
    * [Step 3](https://github.com/yagom-academy/ios-exposition-universelle/pull/104)
### Tech Stack
* Swift 5.4
* Xcode 12.5
* iOS 14.0
### Demo
<details><summary>Demo</summary><div markdown="1">


</div></details>
<details><summary>UML - Data</summary><div markdown="1">

![image](https://user-images.githubusercontent.com/59643667/125462069-37423bdf-61e3-4093-a4d0-fb7b2ae90760.png)
</div></details>


## Troubleshootings
<details><summary>JSON데이터 Decodable 이용해서 파싱하기</summary><div markdown="1">

Decodable을 채택한 타입은 디코딩이 완료되면 해당 데이터를 하나의 인스턴스로 만들기 때문에 `init()`
initializer를 구현하는 것과 구현하지 않는 것 등등 다양한 방향을 고민해봄

* 매서드 또는 초기자 내부 구현을 잘꾸미면 JSON 내부 프로퍼티 ≡ 매칭할 타입의 프로퍼티 가 1대1 대응 할 필요 없거나 다른 타입으로 타입 캐스팅이 가능해짐    
    ```swift
    struct Exposition: Decodable {
        let title: String?
        let duration: Date?

            private enum CodingKeys: String, CodingKey {
                    case title
                    case duration
            }

            required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
                    let interbal (try? container.decode(Double.self, forKey: .duration)) ?? 0
                    
                    if let dates = stringDate {
                        self.duration = Date(timeIntervalSince1970: interbal)
                    } else {
                        self.duration = nil
                    }
            }
    }
    ```
* 과연 init(from decoder: Decoder) 필요한가?
    ```swift
    struct Entry: Decodable {

        let name: String?
        var imageName: String?

        private enum CodingKeys: String, CodingKey {
            case imageName = "image_nam" // test
            case name
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decode(String.self, forKey: .name)
            imageName = try values.decode(String.self, forKey: .imageName)
                // 둘중 하나라도 오류 발생시 throw - 인스턴스 생성 안됨.
        }
    }
    ```
    init을 위 코드처럼 처리하면 하나의 프로퍼티 값 만이라도 `오류`가 발생하면 바로 인스턴스 만들지 않고 에러를 던짐
    
* init을 구현하지 않음
    ```swift    
    let decoder = JSONDecoder()
            
    do {
       let data = NSDataAsset(name: "items")?.data
       let instance = try decoder.decode(Array<Entry>.self, from: data!)
                
       print(instance)
    } catch {
       print(error)
    }
    ```
    위 코드처럼 구현될때 프로퍼티가 비어있으면 nil 담고 인스턴스 생성됨

**적용코드**  
하나의 데이터가 누락되었다고 해서 모든 데이터 파싱을 실패할 필요가 없기 때문에 초기화에서 모든 데이터를 확인하고 옵셔널처리

</div></details>
<details><summary>화면 전환시 값 전달</summary><div markdown="1">

- 화면 이동 할때 데이터 넘기기 다양한 방법을 고민   
    (참고 블로그 [Swift에서 데이터 전달하는 6가지 방법 정리!!
](https://i-colours-u.tistory.com/6))
    - 스토리보드에서 버튼과 ViewController 바로 연결하기
    - ViewController 간에 Segue 연결하고 스토리보드에 포함된 ViewController의 인스턴스를 생성해서 present 하기
    - 델리게이트를 이용한 값 넘김

- 값을 전달할때 해당 인스턴스 내부 데이터를 전달하는 방식을 고민  
    질문 내용
    
    리뷰어의 피드백을 통해 인스턴스 내부 프로퍼티 값을 나누어 전달하는 건 은닉화, 캡슐화를 망가뜨리는 시도라고 인식
    데이터를 담은 인스턴스를 전달하는 형태로 구현

**적용코드**


</div></details>
<details><summary>Default cell style 별로 적용해보기</summary><div markdown="1">
    
기대하는 디자인이 Default cell style 'Subtitle' 으로 생각해서 구현 시도  
**cell.imageView 적용시도**   
문제점) 이미지뷰의 크기를 설정 할 수 없다

**시도 1)** 이미지 뷰의 레이아웃 조정해보기  
> 참고 블로그  
> [How to set fix ImageView size inside TableViewCell programmatically?](https://stackoverflow.com/questions/60199920/how-to-set-fix-imageview-size-inside-tableviewcell-programmatically)  
> [[Swift] AutoLayout 코드작성방법 (Visual Format Language, NSLayoutAnchor, NSLayoutConstraint)](https://nsios.tistory.com/99)
        
**translatesAutoresizingMaskIntoConstraints** : 설정(Autoresizing) 완료된 뷰의 설정 바꾸기 ← 인스턴스 생성되고 화면에 그려질때 true 상태의 뷰를 스토리보드에서 오토레이아웃 셋팅해두면 오토레이아웃 설정이 2개라 충돌해서 에러가 발생
> [translatesAutoresizingMaskIntoConstraints](https://zeddios.tistory.com/474)
        
**시도 2)** UIImage를 셀 크기로 렌더링해서 UIImageView에 넣기  
> 참고 블로그
> [[Swift] Image Resize](https://nsios.tistory.com/154?category=803407)  
    
-> 이미지 크기는 셀 높이에 맞지만 공백 설정하기가 힘듬
        
**시도 3)** UITableVIewCell을 상속한 커스텀셀에 기본셀 override 해서 ImageView 셋팅하기  
> 참고 블로그
> [cell.imageView!.frame size change. Swift](https://stackoverflow.com/questions/35635884/cell-imageview-frame-size-change-swift)  
        
**결론)** Subtitle 이미지 뷰는 셀을 나누는 선이 포함되지 않음. 커스텀 셀로 최종 적용.   
    모든 내용이 cell content 뷰 안에 들어있어야 함(프로젝트 요구사항). 일정한 크기 이미지의 아이콘이 적절

</div></details>
<details><summary>CustomUILabel 만들어서 모든 프로퍼티 설정을 인스턴스 생성마다 설정시키기</summary><div markdown="1">

앱 내부에서 사용되는 모든 UILabel은 동일한 설정을 가지고 있어서 해당 설정을 초기화 단계에서 포함하도록 상속된 class를 생성해서 적용

`extension`으로 추가하기엔 기본 UILabel 기능을 필요로 하는 UI요소가 추가될 가능성이 있기 때문에 상속으로 추가함 

리뷰어의 도움으로 `Protocol`을 이용해서 커스텀 Label이 UILabel이 사용가능한 경우에만 적용되도록 적용
</div></details>
<br>
