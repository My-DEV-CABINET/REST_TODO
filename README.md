# REST_TODO

## Introduce

REST API 를 사용하여 나만의 할 일을 만들 수 있습니다.

## Schedule

- 개발 일정 : 2024.05.16 - 2024.05.23 (1주일)

## Development Environment & Libraries

![Swift](https://img.shields.io/badge/Swift-5.10-blue.svg) ![iOS](https://img.shields.io/badge/Platform-iOS-red.svg)

### Deployment Target

- 16.0.0

### Libraries

|   이름   |     목적     | 사용 버전 |
| :------: | :----------: | :-------: |
| SQLLite3 | 로컬 DB 저장 | iOS 16.0  |
| Combine  | 이벤트 처리  |     -     |

## Features

|                                                  할일 조회                                                   |                                                  할일 생성                                                   |                                                  할일 검색                                                   |
| :----------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------: |
| <img src="https://velog.velcdn.com/images/jakkujakku98/post/99719843-fbb6-40bb-a283-35241f16772c/image.gif"> | <img src="https://velog.velcdn.com/images/jakkujakku98/post/01e08646-fb7f-458e-99fb-dd863fcb1fac/image.gif"> | <img src="https://velog.velcdn.com/images/jakkujakku98/post/69df556b-c75e-4373-8d0e-61337152ada8/image.gif"> |
|                                        - 최신 ToDo 데이터들 조회<br/>                                        |                                           - ToDo 데이터 생성<br/>                                            |                                  - 검색어와 일치하는 ToDo 데이터 조회<br/>                                   |
|                                            **완료된 할일 숨기기**                                            |                                                **할일 수정**                                                 |                                                **할일 삭제**                                                 |
| <img src="https://velog.velcdn.com/images/jakkujakku98/post/3b6d7623-153e-4753-97ef-2f05bdccf1e9/image.gif"> | <img src="https://velog.velcdn.com/images/jakkujakku98/post/7d993b09-fca9-4932-a507-3411f723d6ed/image.gif"> | <img src="https://velog.velcdn.com/images/jakkujakku98/post/ba1d8861-0665-41b0-a2a4-3e505a56a01c/image.gif"> |
|                                    - 완료되지 않은 ToDo 데이터 조회<br/>                                     |                                       - ToDo 데이터 내용 업데이트<br/>                                       |                                           - ToDo 데이터 삭제<br/>                                            |
|                                              **무한 스크롤링**                                               |                                                                                                              |                                                                                                              |
| <img src="https://velog.velcdn.com/images/jakkujakku98/post/6d670d85-d23c-4d05-b820-d5fd1de420ea/image.gif"> |                                                                                                              |                                                                                                              |
|                                 - 아래 스크롤시, ToDo 데이터 추가 조회<br/>                                  |                                                                                                              |                                                                                                              |

## 💣Trouble Shooting

<details>
<summary>Info.plist 위치 이동 후 발생하는 오류</summary>
<div markdown="1">

### 상황(Situation) : Clean Architecture 와 같이 프로젝트 폴더를 정리하기 위해 Info.plist 위치를 조정한 후, 아래와 같은 오류 코드를 발생시킴.

```
Multiple commands produce '/Users/wnsdnrla/Library/Developer/Xcode/DerivedData/REST_TODO-bjguvmrozrxmmvdepdzivnsioeca/Build/Products/Debug-iphonesimulator/REST_TODO.app/Info.plist'
```

### 목표(Task) : 해당 오류 코드가 사라지면서, Info.plist 가 정상적으로 인식되어야 함.

### 행동(Action)

Info.plist 경로가 문제라는 것을 확인함.

Targets/Build Settings/Packings/Info.plist.File 을 지워줌.

![스크린샷 2024-05-17 오후 4.26.08.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/4a852067-92a5-4e08-bd8e-febf1e351430/914a8ae1-8677-4684-8746-3fabdc34517b/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2024-05-17_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_4.26.08.png)

### 결과(Result)

정상적으로 빌드가 되는 것을 확인함.

- **테스트 중 `Mock-up Data Decoding` 오류**
  ## 상황(Situation)
  서버에 GET 요청을 하여 Mocks 데이터를 조회하는 테스트 코드 작성 도중, 데이터가 Decoding 되지 못하는 상황이 발생함.
  ## 목표(Task)
  서버로부터 받은 데이터를 무사히 스위프트 구조체로 Decoding 될 수 있도록 변환하는 것
  ## 행동(Action)
  먼저, Mocks 데이터의 구조 형식을 다시 살펴봄.
  ```objectivec
  {
    "data": [
      {
        "id": 154,
        "title": "(주)빡코더스)",
        "email": "test@email.com",
        "content": "더미데이터 입니다",
        "avatar": "https://www.gravatar.com/avatar/72b6e54c23ce447df86b15c32521c9f0.jpg?s=200&d=robohash",
        "created_at": "2022-10-25T14:11:46.000000Z",
        "updated_at": "2022-10-25T14:11:46.000000Z"
      }
    ],
    "meta": {
      "current_page": 1,
      "from": 1,
      "last_page": 16,
      "per_page": 10,
      "to": 10,
      "total": 154
    },
    "message": "목록 조회가 완료되었습니다"
  }
  ```
  그리고 나의 구조체 형식을 살펴봄.
  ```objectivec
  import Foundation

  struct ToDo: Codable {
      let data: ToDoData? --> 여기가 원인임.
      let meta: ToDoMeta?
      let message: String?
  }

  struct ToDoData: Codable {
      let id: Int?
      let title: String?
      let isDone: Bool?
      let createdAt: String?
      let updatedAt: String?

      enum CodingKeys: String, CodingKey {
          case id
          case title
          case isDone = "is_done"
          case createdAt = "created_at"
          case updatedAt = "updated_at"
      }
  }

  struct ToDoMeta: Codable {
      let currentPage: Int?
      let from: Int?
      let lastPage: Int?
      let perPage: Int?
      let to: Int?
      let total: Int?

      enum CodingKeys: String, CodingKey {
          case currentPage = "current_page"
          case from
          case lastPage = "last_page"
          case perPage = "per_page"
          case to
          case total
      }
  }

  ```
  살펴본 결과, Mocks 데이터의 data 는 [] 로 감싸져 있는데, 구조체는 [] 감싸져 있지 않은 것이 문제의 원인임을 확인함.
  ```objectivec
  // Before
  let data: ToDoData?

  // After
  let data: [ToDoData]?
  ```
  ## 결과(Result) : 해결한 결과 (Image, Gif, 코드 첨부)
  변환 후, 테스트를 실행한 결과 정상적으로 데이터가 출력이 되는 것을 확인함.
  ```objectivec
  Test Suite 'All tests' started at 2024-05-18 22:40:49.140.
  Test Suite 'REST_TODOTests.xctest' started at 2024-05-18 22:40:49.141.
  Test Suite 'REST_TODOTests' started at 2024-05-18 22:40:49.141.
  Test Case '-[REST_TODOTests.REST_TODOTests testFetchTodos]' started.
  Todos: ToDo(data: Optional([REST_TODO.ToDoData(id: Optional(239), title: Optional("예진연구소"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(243), title: Optional("상욱보험"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(178), title: Optional("(유)소정캐피탈"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(203), title: Optional("(주)서연보험"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(207), title: Optional("도연스튜디오"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(216), title: Optional("예은미디어"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(201), title: Optional("재훈인터넷"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(234), title: Optional("(주)선호"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(204), title: Optional("민서식품"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(179), title: Optional("정은모바일"), isDone: nil, createdAt: nil, updatedAt: nil)]), meta: Optional(REST_TODO.ToDoMeta(currentPage: Optional(1), from: Optional(1), lastPage: Optional(25), perPage: Optional(10), to: Optional(10), total: Optional(244))), message: Optional("성공"))
  ```

</div>
</details>

<details>
<summary>테스트 중 Mock-up Data Decoding 오류</summary>
<div markdown="1">

## 상황(Situation)

서버에 GET 요청을 하여 Mocks 데이터를 조회하는 테스트 코드 작성 도중, 데이터가 Decoding 되지 못하는 상황이 발생함.

## 목표(Task)

서버로부터 받은 데이터를 무사히 스위프트 구조체로 Decoding 될 수 있도록 변환하는 것

## 행동(Action)

먼저, Mocks 데이터의 구조 형식을 다시 살펴봄.

```objectivec
{
  "data": [
    {
      "id": 154,
      "title": "(주)빡코더스)",
      "email": "test@email.com",
      "content": "더미데이터 입니다",
      "avatar": "https://www.gravatar.com/avatar/72b6e54c23ce447df86b15c32521c9f0.jpg?s=200&d=robohash",
      "created_at": "2022-10-25T14:11:46.000000Z",
      "updated_at": "2022-10-25T14:11:46.000000Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 16,
    "per_page": 10,
    "to": 10,
    "total": 154
  },
  "message": "목록 조회가 완료되었습니다"
}
```

그리고 나의 구조체 형식을 살펴봄.

```objectivec
import Foundation

struct ToDo: Codable {
    let data: ToDoData? --> 여기가 원인임.
    let meta: ToDoMeta?
    let message: String?
}

struct ToDoData: Codable {
    let id: Int?
    let title: String?
    let isDone: Bool?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isDone = "is_done"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ToDoMeta: Codable {
    let currentPage: Int?
    let from: Int?
    let lastPage: Int?
    let perPage: Int?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case perPage = "per_page"
        case to
        case total
    }
}

```

살펴본 결과, Mocks 데이터의 data 는 [] 로 감싸져 있는데, 구조체는 [] 감싸져 있지 않은 것이 문제의 원인임을 확인함.

```objectivec
// Before
let data: ToDoData?

// After
let data: [ToDoData]?
```

## 결과(Result) : 해결한 결과 (Image, Gif, 코드 첨부)

변환 후, 테스트를 실행한 결과 정상적으로 데이터가 출력이 되는 것을 확인함.

```objectivec
Test Suite 'All tests' started at 2024-05-18 22:40:49.140.
Test Suite 'REST_TODOTests.xctest' started at 2024-05-18 22:40:49.141.
Test Suite 'REST_TODOTests' started at 2024-05-18 22:40:49.141.
Test Case '-[REST_TODOTests.REST_TODOTests testFetchTodos]' started.
Todos: ToDo(data: Optional([REST_TODO.ToDoData(id: Optional(239), title: Optional("예진연구소"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(243), title: Optional("상욱보험"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(178), title: Optional("(유)소정캐피탈"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(203), title: Optional("(주)서연보험"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(207), title: Optional("도연스튜디오"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(216), title: Optional("예은미디어"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(201), title: Optional("재훈인터넷"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(234), title: Optional("(주)선호"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(204), title: Optional("민서식품"), isDone: nil, createdAt: nil, updatedAt: nil), REST_TODO.ToDoData(id: Optional(179), title: Optional("정은모바일"), isDone: nil, createdAt: nil, updatedAt: nil)]), meta: Optional(REST_TODO.ToDoMeta(currentPage: Optional(1), from: Optional(1), lastPage: Optional(25), perPage: Optional(10), to: Optional(10), total: Optional(244))), message: Optional("성공"))
```

</div>
</details>

<details>
<summary>불러온 데이터와 서버의 날짜 데이터가 안 맞는 오류</summary>
<div markdown="1">

## 상황(Situation) : 문제 상황 설명

시뮬레이터에서 서버에 GET 요청을 한 후, 데이터를 불러와 스크롤링 하는 코드를 짜던 중, 데이터의 `Update_at` 날짜와 서버의 날짜가 일치하지 않는 것을 발견

## 목표(Task) : 해결 목표

서버와 시뮬레이터의 날짜를 일치 시키는 것

## 행동(Action) : 문제 해결 과정 or 시도

원인 분석을 하기 위해, **2가지 경우의 수**를 생각함.

1. **서버에서 잘못된 데이터를 준 경우**
2. **받아온 데이터를 잘못 가공한 경우**

위 두 가지 경우를 분석하기 위해, Log 내역을 살펴봄.

1 의 경우, 값이 정상적으로 불러온 것으로 확인되어, 소거됨.

그래서 2번의 경우일 확률이 높다 생각하여, 코드를 다시 살펴봄.

거기서 가공한 데이터가 받아온 데이터 보다 9시간 더 추가되서 반환되어 진 것을 확인함.

원인을 파악한 후, 반환되기 직전 9시간을 따로 빼서 반환처리 진행

- 문제 코드

```swift
 func dateFormatterForDate() -> String {
        let dateString = self

        // 입력 날짜 형식 정의
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"

        // 입력 문자열을 Date 객체로 변환
        if let dateDate = inputFormatter.date(from: dateString) {
            // 출력 날짜 형식 정의
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd" - -> 한국 날짜 적용 X

            // 변환된 Date 객체를 String 객체로 변환
            let resultString = outputFormatter.string(from: dateDate)

            return resultString
        }

        return "n/a"
    }
```

```swift
func dateFormatterForDate() -> String {
        let dateString = self

        // 입력 날짜 형식 정의
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"

        // 입력 문자열을 Date 객체로 변환
        if let dateDate = inputFormatter.date(from: dateString) {
            // 9시간을 뺀 새로운 날짜 계산 - -> 변경 처리한 부분.
            if let adjustedDate = Calendar.current.date(byAdding: .hour, value: -9, to: dateDate) {
                // 출력 날짜 형식 정의
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyy.MM.dd"

                // 변환된 Date 객체를 String 객체로 변환
                let resultString = outputFormatter.string(from: adjustedDate)

                return resultString
            }
        }

        return "n/a"
    }
```

## 결과(Result) : 해결한 결과 (Image, Gif, 코드 첨부)

서버와 시뮬레이터의 데이터 날짜가 일치하는 것을 확인함.

</div>
</details>

<details>
<summary>Network API 모듈화를 하며 겪은 문제</summary>
<div markdown="1">

### 기존 Network API 처리 모델

- 설명
  기존 모델의 **문제점**
  ```swift
  enum ContentType {
      case json

      var code: String {
          switch self {
          case .json:
              return "application/json"
          }
      }
  }

  enum Filter: String {
      case createdAt = "created_at"
      case updatedAt = "updated_at"
  }

  enum Order: String {
      case desc
      case asc
  }

  enum HTTPMethod: String {
      case get = "GET"
      case post = "POST"
      case put = "PUT"
      case delete = "DELETE"
  }

  enum NetworkAPI {
      case requestTodos(dto: ToDoResponseDTO) // GET - 전체 데이터 조회
      case requestTodoWithID(id: Int)
      case requestSearchTodos(dto: ToDoResponseDTO) // GET - ID 사용하여 데이터 조회
      case postTodo(dto: ToDoPOSTDTO) // POST - 데이터 추가
      case putTodo(id: Int, dto: ToDoPOSTDTO) // PUT - 데이터 수정
      case deleteTodo(id: Int) // DELETE - 데이터 삭제

      var baseURL: String {
          return Constants.BASE_URL
      }

      var method: HTTPMethod {
          switch self {
          case .requestTodos, .requestTodoWithID, .requestSearchTodos:
              return .get
          case .postTodo:
              return .post
          case .putTodo:
              return .put
          case .deleteTodo:
              return .delete
          }
      }

      var path: String {
          switch self {
          case .requestTodos:
              return "/api/v2/todos"
          case .requestTodoWithID(let id):
              return "/api/v2/todos/\(id)"
          case .requestSearchTodos:
              return "/api/v2/todos/search"
          case .postTodo, .putTodo, .deleteTodo:
              return "/api/v2/todos"
          }
      }

      var param: [URLQueryItem] {
          switch self {
          case .requestTodos(let dto):
              return [
                  URLQueryItem(name: "filter", value: dto.filter?.rawValue),
                  URLQueryItem(name: "order_by", value: dto.orderBy?.rawValue),
                  URLQueryItem(name: "page", value: dto.page?.description),
                  URLQueryItem(name: "per_page", value: dto.perPage?.description)
              ]
          case .requestTodoWithID(id: let id), .deleteTodo(let id):
              return [
                  URLQueryItem(name: "id", value: id.description)
              ]
          case .postTodo(let dto):
              return [
                  URLQueryItem(name: "title", value: dto.title),
                  URLQueryItem(name: "is_done", value: dto.isDone.description)
              ]

          case .putTodo(let id, let dto):
              return [
                  URLQueryItem(name: "id", value: id.description),
                  URLQueryItem(name: "title", value: dto.title),
                  URLQueryItem(name: "is_done", value: dto.isDone.description)
              ]
          case .requestSearchTodos(let dto):
              return [
                  URLQueryItem(name: "query", value: dto.query),
                  URLQueryItem(name: "filter", value: dto.filter?.rawValue),
                  URLQueryItem(name: "order_by", value: dto.orderBy?.rawValue),
                  URLQueryItem(name: "page", value: dto.page?.description),
                  URLQueryItem(name: "per_page", value: dto.perPage?.description),
                  URLQueryItem(name: "is_done", value: dto.isDone?.description)
              ]
          }
      }

      func asURLRequest() throws -> URLRequest {
          let url = baseURL
          var components = URLComponents(string: url)
          components?.path = path
          components?.queryItems = param

          guard let url = components?.url else { throw URLError(.badURL) }

          var request = URLRequest(url: url)
          request.httpMethod = method.rawValue
          request.setValue(ContentType.json.code, forHTTPHeaderField: Constants.HTTP_Header_Field)

          return request
      }
  }
  ```
  위 구조의 API 모델을 사용할려면, 아래와 같은 코드로 사용해야합니다.
  ```swift
  func requestTodosFromServer(dto: ToDoResponseDTO) -> AnyPublisher<ToDo, any Error> {
      do {
          let url = try NetworkAPI.requestTodos(dto: dto).asURLRequest()

          return URLSession.shared
              .dataTaskPublisher(for: url)
              .tryMap { output in
                  guard output.response is HTTPURLResponse else {
                      throw NetworkError.serverError(code: 0, error: "Server error")
                  }
                  return output.data
              }
              .decode(type: ToDo.self, decoder: JSONDecoder())
              .mapError { error in
                  return NetworkError.invalidJSON(String(describing: error))
              }
              .eraseToAnyPublisher()
      } catch {
          return Fail(error: NetworkError.badURL("Invalid URL!")).eraseToAnyPublisher()
      }
  }
  ```
  제일 문제라고 생각했던 부분은 아래 코드 입니다.
  ```swift
  let url = try NetworkAPI.requestTodos(dto: dto).asURLRequest()
  ```
  그리고 `GET`, `POST`, `PUT`, `DELETE` 통신은 `Parameter`, `Response` 가 달라 처리하는 함수가 여러개로 나뉘어지는 문제도 있습니다.
  ```swift
  protocol APIServiceProtocol {
       func requestTodosFromServer(dto: ToDoResponseDTO) -> AnyPublisher<ToDo, Error>
       func requestQueryToDosFromServer() -> AnyPublisher<ToDo, Error>

       func insertToDoToServer() -> AnyPublisher<Bool, Error>
       func updateToDoAtServer() -> AnyPublisher<Bool, Error>
       func removeToDoAtServer() -> AnyPublisher<Bool, Error>
   }
  ```
  이런 구조다 보니, 당연히 데이터를 받아오기 위해 거쳐야 하는 단계도 많아지는 문제가 발생함
  > View > ViewModel Input > API Service
  그래서 API 를 처리하는 공통의 추상화한 Protocol 을 만들고, Protocol 을 채택한 구조체들을 생성하는 방식으로 변경 하는 것을 선택하였습니다.
  제일 먼저, 추상화한 `Protocol` 입니다. API 의 공통된 부분을 추출한 것입니다.
  ```swift
  protocol NetworkAPIDefinition {
      typealias URLInfo = NetworkAPI.URLInfo
      typealias RequestInfo = NetworkAPI.RequestInfo

      associatedtype Parameter: Encodable
      associatedtype Response: Decodable

      var urlInfo: URLInfo { get }
      var requestInfo: RequestInfo<Parameter> { get }
  }
  ```
  다음 Protocol 을 구체화한 통신 API 입니다.
  왼쪽은 `GET`, 오른쪽은 `POST` 입니다.
  세세한 부분에서 차이가 있는 것이 보이십니까??
  `Parameter` 과 `URL`, `Body` 부분에서 차이가 있습니다.
  ```swift
  // 모든 할일 목록 가져오기 - 완료 숨김 X
  struct GETTodosAPI: NetworkAPIDefinition {
      let page: String
      let filter: String
      let orderBy: String
      let perPage: String

      // BODY Parameter
      struct Parameter: Encodable {
          // Parameters for the GET request
      }

      typealias Response = ToDos

      var urlInfo: NetworkAPI.URLInfo {
          NetworkAPI.URLInfo(
              host: Constants.host,
              path: Constants.path,
              query: [
                  "page": page,
                  "filter": filter,
                  "order_by": orderBy,
                  "per_page": perPage,
              ]
          )
      }

      var requestInfo: NetworkAPI.RequestInfo<Parameter> {
          NetworkAPI.RequestInfo(
              method: .get,
              headers: [Constants.accept: Constants.applicationJson]
          )
      }
  }
  ```
  ```swift
  // 할일 추가
  struct POSTToDoAPI: NetworkAPIDefinition {
      let dto: ToDoBodyDTO

      struct Parameter: Encodable {
          let title: String
          let is_done: Bool
      }

      struct Response: Decodable {
          // Response for the POST request
      }

      var urlInfo: NetworkAPI.URLInfo {
          NetworkAPI.URLInfo(
              host: Constants.host,
              path: Constants.postPath
          )
      }

      var requestInfo: NetworkAPI.RequestInfo<Parameter> {
          NetworkAPI.RequestInfo(
              method: .post,
              headers: [
                  Constants.accept: Constants.applicationJson,
                  Constants.contentType: Constants.applicationJson,
              ],
              parameters: Parameter(
                  title: dto.title,
                  is_done: dto.is_Done
              )
          )
      }
  }
  ```
  그리고 그 다음은 API 를 호출하는 부분 역시 변경이 이루어졌습니다.
  기존 API 는 `GET`, `POST` 와 같이 다른 통신에서는 각각의 호출함수가 있었습니다. 그러나 변경된 함수는 공통의 모듈에서 뽑아 사용하도록 설계되어 있습니다.
  왼쪽은 `(구)GET 통신`, 오른쪽은 `(현)GET 통신`입니다.
  protocol 타입을 `Generic`으로 만들어 사용했습니다.
  ```swift
  func requestTodosFromServer(dto: ToDoResponseDTO) -> AnyPublisher<ToDo, any Error> {
           do {
               let url = try NetworkAPI.requestTodos(dto: dto).asURLRequest()

               return URLSession.shared
                   .dataTaskPublisher(for: url)
                   .tryMap { output in
                       guard output.response is HTTPURLResponse else {
                           throw NetworkError.serverError(code: 0, error: "Server error")
                       }
                       return output.data
                   }
                   .decode(type: ToDo.self, decoder: JSONDecoder())
                   .mapError { error in
                       return NetworkError.invalidJSON(String(describing: error))
                   }
                   .eraseToAnyPublisher()
           } catch {
               return Fail(error: NetworkError.badURL("Invalid URL!")).eraseToAnyPublisher()
           }
       }
  ```
  ```swift
  func request<T: NetworkAPIDefinition>(_ api: T) -> AnyPublisher<T.Response, Error> {
          let url = api.urlInfo.url
          let request = api.requestInfo.requests(url: url)

          print("#### 클래스명: \(String(describing: type(of: self))), 함수명: \(#function), Line: \(#line), 출력 Log: \(url)")

          return URLSession.shared.dataTaskPublisher(for: request)
              .tryMap { output in
                  guard let response = output.response as? HTTPURLResponse else {
                      throw NetworkError.serverError(code: 0, error: "Server error")
                  }
                  guard (200 ... 299).contains(response.statusCode) else {
                      throw NetworkError.serverError(code: response.statusCode, error: "Server error with code: \(response.statusCode)")
                  }

                  return output.data
              }
              .decode(type: T.Response.self, decoder: JSONDecoder())
              .mapError { error in
                  return NetworkError.invalidJSON(error.localizedDescription)
              }
              .receive(on: RunLoop.main)
              .eraseToAnyPublisher()
      }
  ```
  이런식으로 변경이 이루어지니, 어떤 API 를 사용해도 메서드가 변경될 일이 적어 에러 핸들링에 대응하기 편해졌습니다.
  두 개의 메서드가 있습니다.
  왼쪽은 `GET` 통신, 오른쪽은 `POST` 통신입니다.
  사용하는 `apiService.request(api)` 부분은 같다는 것을 알 수 있습니다.
  즉, 사용하는 api 만 다르게 하면, 다른 통신을 할 수 있다는 것입니다.
  ```swift
  /// ToDo 데이터 10개 호출 - 완료 숨김 X
  private func requestGETTodos() {
      let api = GETTodosAPI(
          page: page.description,
          filter: Filter.createdAt.rawValue,
          orderBy: Order.desc.rawValue,
          perPage: 10.description
      )

      apiService.request(api)
          .sink { completion in
              switch completion {
              case .failure(let error):
                  print("#### Error fetching todos: \(error)")
                  self.output.send(.sendError(error: error))
              case .finished:
                  print("#### Finished \(completion)")
              }
          } receiveValue: { [weak self] response in
              self?.todos = response.data
              self?.output.send(.showGETTodos(todos: response.data ?? []))
          }
          .store(in: &subcriptions)
  }
  ```
  ```swift
  private func requestPOSTToDoAPI(title: String, isDone: Bool) {
          let dto = ToDoBodyDTO(title: title, is_Done: isDone)
          let api = POSTToDoAPI(dto: dto)

          apiService.request(api)
              .sink { completion in
                  switch completion {
                  case .failure(let error):
                      print("#### Error Posting todo: \(error)")
                      self.output.send(.sendError(error: error))
                  case .finished:
                      print("#### Finished \(completion)")
                  }
              } receiveValue: { [weak self] response in
                  guard let self = self else { return }
                  output.send(.dismissView)
              }
              .store(in: &subcriptions)
      }
  ```

위와 같은 과정을 거쳐, 공통 API 모듈을 만들어 사용하게 되었습니다.

</div>
</details>

<details>
<summary>완료여부 변경시, 누르지 않은 셀의 완료여부 변경되는 문제</summary>
<div markdown="1">

## 상황(Situation) : 문제 상황 설명

1번 셀의 CheckBox 를 클릭하여, 일의 완료여부를 처리하던 도중, 내가 누르지 않은 셀의 CheckBox 완료 여부가 변경되는 상황 발생

## 목표(Task) : 해결 목표

내가 완료여부를 처리한 셀만 변경이 이루어지도록 해야함.

## 행동(Action) : 문제 해결 과정 or 시도

CheckBox 의 UIAction 이 선언된 위치를 먼저 확인함.

이유는 셀이 재사용될 때, Configure이 호출이 되는데, 그 안의 delegate 코드 역시 호출이 될 것으로 생각하고 접근함.

그 결과, Configure 가 호출이 될 때, delegate 가 재사용되는 셀의 todo 데이터도 반환하는 것을 확인함.

- 문제의 코드

```swift
func configure(todo: ToDoData) {
      self.todo = todo
      guard let isDone = todo.isDone else { return }

      titleLabel.text = todo.title
      if let date = todo.createdAt {
          dateLabel.text = date.dateFormatterForTime()
      }

      let checkImageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
      let checkImage = UIImage(systemName: isDone ? "checkmark.square.fill" : "square", withConfiguration: checkImageConfig)

      checkBox.setImage(checkImage, for: .normal)

      checkBox.addAction(UIAction(handler: { [weak self] _ in
          guard let self = self, let todo = self.todo else { return }
          delegate?.didTapCheckBox(todo: todo)
      }), for: .touchUpInside)

      let favoriteImageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
      let favoriteImage = UIImage(systemName: "star", withConfiguration: favoriteImageConfig)

      favoriteButton.setImage(favoriteImage, for: .normal)
  }
```

- 변경된 사항
  - 기존의 configure에 선언된 addAction 함수를 UI 생성하는 곳으로 옮김.

```swift
private func configureCheckBox() {
      checkBox.translatesAutoresizingMaskIntoConstraints = false

      checkBox.tintColor = .black
      checkBox.layer.cornerRadius = 10
      checkBox.layer.masksToBounds = true

      let constraints = [
          checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
          checkBox.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
          checkBox.widthAnchor.constraint(equalToConstant: 30),
          checkBox.heightAnchor.constraint(equalToConstant: 30)
      ]

      NSLayoutConstraint.activate(constraints)

      checkBox.addAction(UIAction(handler: { [weak self] _ in
          guard let self = self, let todo = self.todo else { return }
          delegate?.didTapCheckBox(todo: todo)
      }), for: .touchUpInside)
  }
```

## 결과(Result) : 해결한 결과 (Image, Gif, 코드 첨부)

정상적으로 내가 지정한 셀의 완료여부만 변경이 되는 것을 확인함.

</div>
</details>

<details>
<summary>PUT 통신 Encoded 문제</summary>
<div markdown="1">

## 상황(Situation) : 문제 상황 설명

`PUT` 통신을 사용하여 데이터를 보내는 작업을 진행함.

그러나, 데이터를 정상적으로 입력하고 데이터 전송을 시도했음에도 불구하고 전송이 안되는 상황이 발생함.

## 목표(Task) : 해결 목표

서버에 `PUT` 통신을 성공적으로 전달하는 것

## 행동(Action) : 문제 해결 과정 or 시도

단계별로 점검을 진행함.

1. **`API` 작업에 문제가 있는지 확인**
2. **데이터를 서버로 보내는 과정에서 오류가 발생했는지 확인**
3. **데이터 자체에 문제가 있는지 확인**

### API 작업에 문제가 있는지 확인

- 서버에서 정상적으로 입력받을 때 `Curl`

```swift
curl -X 'PUT' \
  'https://phplaravel-574671-2962113.cloudwaysapps.com/api/v2/todos/5126' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'X-CSRF-TOKEN: q4PSs9s42v2gUQlUCIfrjs0U2TlhgiTG6mF5iXxf' \
  -d 'title=Don'\''t%20open%20dead%20inside&is_done=true'
```

- 내가 만든 API 모듈 구조

```swift
// 특정 할일 수정 - ID 기반
struct PUTToDoAPI: NetworkAPIDefinition {
    let idDTO: ToDoIDDTO
    let bodyDTO: ToDoBodyDTO

    struct Parameter: Encodable {
        let title: String
        let is_done: Bool
    }

    struct Response: Decodable {
        // Response for the POST request
    }

    var urlInfo: NetworkAPI.URLInfo {
        NetworkAPI.URLInfo(
            host: Constants.host,
            path: "\(Constants.path)/\(idDTO.id)"
        )
    }

    var requestInfo: NetworkAPI.RequestInfo<Parameter> {
        NetworkAPI.RequestInfo(
            method: .put,
            headers: [
                Constants.accept: Constants.applicationJson,
                Constants.contentType: Constants.applicationXw3FormUrlencoded,
            ],
            parameters: Parameter(
                title: bodyDTO.title,
                is_done: bodyDTO.is_Done
            )
        )
    }
}
```

### 1차 검사 결과

- 현재의 구조에는 별다른 특이점은 발견하지 못함.

### 데이터를 서버로 보내는 과정에서 오류가 발생했는지 확인

서버와 `REST API` 통신을 하는 코드를 살펴본 결과, 해당 코드에서 오류는 발생하지 않음.

그러나, 별다른 오류코드를 내보내지는 않으나, **서버에 데이터가 반영이 안되는 문제가 있음.**

- 문제의 코드

```swift
func request<T: NetworkAPIDefinition>(_ api: T) -> AnyPublisher<T.Response, Error> {
        let url = api.urlInfo.url
        let request = api.requestInfo.requests(url: url)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.serverError(code: 0, error: "Server error")
                }
                guard (200 ... 299).contains(response.statusCode) else {
                    throw NetworkError.serverError(code: response.statusCode, error: "Server error with code: \(response.statusCode)")
                }
                return output.data
            }
            .decode(type: T.Response.self, decoder: JSONDecoder())
            .mapError { error in
                return NetworkError.invalidJSON(String(describing: error))
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
```

### 2차 검사 결과

- 해당 코드는 오류 발생 ❌, 그러나 데이터가 서버로 전송이 안됨.

### 데이터 자체에 문제가 있는지 확인

API 구조에 문제가 있는지 확인하던 도중, 발견한 부분

```swift
curl -X 'PUT' \
  'https://phplaravel-574671-2962113.cloudwaysapps.com/api/v2/todos/5126' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'X-CSRF-TOKEN: q4PSs9s42v2gUQlUCIfrjs0U2TlhgiTG6mF5iXxf' \
  -d 'title=Don'\''t%20open%20dead%20inside&is_done=true' - -> 주목!!
```

기존 `GET, POST, DELETE` 에서는 `application/json` 이었지만, `PUT` 은 `application/x-www-form-urlencoded` 을 사용함.

`application/x-www-form-urlencoded` 을 사용하면, 기존 json 형식 사용 불가 ❌

데이터를 별도의 변환 과정을 거쳐야 한다는 것을 확인함.

왜 변환 과정을 거쳐야 하는지 살펴본 결과

Hello World 라는 값을 `json` 으로 전송

```swift
title: "Hello World"
```

Hello World 라는 값을 `x-www-form-urlencoded` 으로 전송

```swift
title=Hello%20World
```

그래서 `extension` 으로 `URLRequest` 만들어서 `Encoded` 처리를 하기로 함.

```swift
extension URLRequest {
    private func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")

        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }

    mutating func percentEncodeParameters(parameters: [String: String]) {
        let parameterArray: [String] = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value))"
        }

        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}

```

만든 Extension 을 API 통신하는 메서드에 적용함.(사용 코드)

```swift
let url = api.urlInfo.url
var request = api.requestInfo.requests(url: url)

let requestParams: [String: String] = ["title": api.bodyDTO.title, "is_done": api.bodyDTO.is_Done.description]

request.percentEncodeParameters(parameters: requestParams) // Encoded
```

### 3차 검사 결과

서버에 PUT 통신을 요청한 결과, 데이터가 정상적으로 서버에 반영이 되는 것을 확인함.

## 결과(Result) : 해결한 결과 (Image, Gif, 코드 첨부)

위 단계를 거쳐 코드를 수정하여 서버에 PUT 통신을 보낸 결과, 서버에 정상적으로 데이터가 반영이 되는 것을 확인함.

</div>
</details>

<details>
<summary>PUT, DELETE 통신시, 자동적으로 페이지가 이동되는 문제 - 1</summary>
<div markdown="1">

## 상황(Situation) : 문제 상황 설명

PUT, DELETE 통신을 한 후, 서버 데이터를 조회를 시도하면 페이지가 이동되어버리는 문제

페이지 1 에서 페이지 2 로 스크롤링을 진행한 후, PUT 통신을 진행하면 페이지 1이 없어져 버림. 즉, 현재 최근 페이지가 페이지 1이 아닌 페이지 2가 되어버림.

## 목표(Task) : 해결 목표

PUT, DELETE 통신을 한 후 페이지 이동이 되지 않도록 막아야 함.

## 행동(Action) : 문제 해결 과정 or 시도

총 2번의 시도가 있었다.

1. API 연쇄 호출
2. 로컬 데이터 업데이트 후, API 호출

## API 연쇄 호출

- 기존 코드

먼저 DELETE 통신 진행한 후, 바로 GET 통신을 요청하여 데이터를 갱신을 진행하였다.

```swift
private func requestDELETEToDoAPI(id: Int) {
   let dto = ToDoIDDTO(id: id.description)
   let api = DELETEToDoAPI(dto: dto)

   return apiService.request(api).flatMap { _ in
       let api = GETTodosAPI(page: self.page.description, filter: Filter.updatedAt.rawValue, orderBy: Order.desc.rawValue, perPage: 10.description)

       return self.apiService.request(api).eraseToAnyPublisher()
   }
   .sink { completion in
       switch completion {
       case .failure(let error):
           print("Error fetching todos: \(error)")
       case .finished:
           break
       }
   } receiveValue: { [weak self] response in
       self?.todos = response.data
       self?.output.send(.showGETTodos(todos: response.data ?? []))
   }
   .store(in: &subcriptions)
}
```

그러나, DELETE 통신이 진행된 후 GET 통신이 되었음에도 페이지 데이터가 변경이 되는 문제가 생겼다.

## 로컬 데이터 업데이트 후, API 호출

변경된 코드입니다.

DELETE 통신을 진행한 후, 로컬 데이터를 업데이트 하는 식으로 진행하였습니다.

```swift
/// ToDo 데이터 삭제
/// - Parameter id: 삭제할 ToDo 데이터의 ID 값
private func requestDELETEToDoAPI(id: Int) {
    let dto = ToDoIDDTO(id: id.description)
    let api = DELETEToDoAPI(dto: dto)

    apiService.request(api)
        .sink { completion in
            switch completion {
            case .failure(let error):
                print("#### Error Delete todos: \(error)")
                self.output.send(.sendError(error: error))
            case .finished:
                print("#### Finished \(completion)")
            }
        } receiveValue: { [weak self] _ in
            guard let self = self else { return }
            // 로컬 데이터 업데이트
            if let index = self.todos?.firstIndex(where: { $0.id == id }) {
                self.todos?.remove(at: index)
                self.output.send(.showGETTodos(todos: self.todos ?? []))
            }
        }
        .store(in: &subcriptions)
}
```

## 결과(Result) : 해결한 결과 (Image, Gif, 코드 첨부)

2 번 DELETE 통신 후 로컬 데이터를 업데이트(= 동기화) 시키는 식으로 진행한 결과, 페이지 이동 없이 데이터가 PUT, DELETE 통신이 원활히 되는 것을 확인할 수 있는 것을 확인하였습니다.

</div>
</details>

<details>
<summary>PUT, DELETE 통신시, 테이블 뷰 스크롤의 Offset 이 초기화되는 문제 - 2</summary>
<div markdown="1">

## 상황(Situation) : 문제 상황 설명

PUT, DELETE 통신 후, 테이블 뷰 스크롤의 Offset 이 초기화되어버리는 문제가 생김.

## 목표(Task) : 해결 목표

PUT, DELETE 통신 후에도 마지막으로 선택된 위치에 위치해야함.

## 행동(Action) : 문제 해결 과정 or 시도

이벤트가 일어나기 직전, 테이블뷰의 Offset 을 입력받았다가 이벤트가 끝나거나 진행될 때 테이블뷰 Offset 에 직전 저장해둔 Offset 을 입력

```swift
func didTapCheckBox(todo: ToDoData) {
    var updateToDo = todo
    if let isDone = updateToDo.isDone {
        updateToDo.isDone = !isDone
    }

    let currentOffset = tableView.contentOffset

    input.send(.requestPUTToDoAPI(todo: updateToDo))

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.tableView.setContentOffset(currentOffset, animated: true)
    }
}
```

## 결과(Result) : 해결한 결과 (Image, Gif, 코드 첨부)

통신 이벤트가 일어난 이후에도 화면이동이 발생하지 않는 것을 확인함.

</div>
</details>

<details>
<summary>TODO 단일 데이터 조회시 발생한 문제</summary>
<div markdown="1">

## 상황(Situation) : 문제 상황 설명

TODO 단일 데이터를 조회하기 위해 GET 통신 진행

그러나, JSON 을 변환할 수 없다는 에러가 발생함.

## 목표(Task) : 해결 목표

TODO 단일 데이터를 조회할 수 있어야함.

## 행동(Action) : 문제 해결 과정 or 시도

서버에서 데이터를 보내오는 데이터 구조를 다시 확인함.

왜냐하면, 나는 보통 서버 확인 > 모델 확인 > 통신 메서드 확인 순으로 확인함.

## 서버에서 보낸 TODO 데이터 값

```swift
{
  "data": {
    "id": 4698,
    "title": "73. 최고에 도달하려면 최저에서 시작하라. -P.시루스",
    "is_done": true,
    "created_at": "2023-09-16T18:07:38.000000Z",
    "updated_at": "2024-05-21T06:32:19.000000Z"
  },
  "message": "할일 조회 성공"
}
```

그리고 나의 모델 구조

```swift
/// ToDo 데이터들
struct ToDos: Codable {
    var data: [ToDoData]?
    var meta: ToDoMeta?
    var message: String?
}
```

처음에는 모델 구조에 이상이 없는 줄 알았으나, data 가 다중 데이터가 아닌, 단일 데이터라는 것을 알게됨.

그래서 모델 구조를 변경함.

## 결과(Result) : 해결한 결과 (Image, Gif, 코드 첨부)

다중 데이터를 불러올 때와 단일 데이터를 불러오는 모델을 분리함.

```swift
/// ToDo 데이터들
struct ToDos: Codable {
    var data: [ToDoData]?
    var meta: ToDoMeta?
    var message: String?
}

/// 단일 ToDo 데이터
struct ToDo: Codable {
    var data: ToDoData?
    var meta: ToDoMeta?
    var message: String?
}
```

그 결과, 정상적으로 단일 데이터를 불러오는 것을 확인함.

</div>
</details>

<details>
<summary>SQLLIte3 을 사용하면서 알게된 것들</summary>
<div markdown="1">

처음으로 `SQLLite3` 을 사용하게 되었습니다.

지금까지 `CoreData`, `SwiftData`, `Realm`, `Firebase` 등 다양한 DB 를 사용해봤지만, `SQLLite3` 은 사용방식이 조금 달랐음.

`String` 값으로 먼저 “SQL 구문으로 DB에서 수행할 동작”을 만듬.

그 이후, `SQLLite3` 메서드를 사용하여 실행하여 데이터를 처리함.

그래서, 단순하게 전체 데이터를 조회하는 방식을 살펴보겠음.

```swift
// 전체 Favorite 데이터 조회
func getAllFavorite() -> [Favorite] {
    let queryStatementString = "SELECT * FROM Favorite;"
    var queryStatement: OpaquePointer?
    var favorites: [Favorite] = []

    if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            let id = sqlite3_column_int(queryStatement, 0)

            favorites.append(Favorite(id: Int(id)))
            print("#### Favorite Details: \(id)")
        }
    } else {
        print("#### SELECT statement is failed.")
    }
    sqlite3_finalize(queryStatement)
    return favorites
}
```

위 코드를 보면 기존 DB 들을 사용하는 것과 다른 게 몇 군데 보일 거임.

```swift
let queryStatementString = "SELECT * FROM Favorite;"
```

SQL 구문의 동작을 `String` 값으로 만듬.

그리고 아까 말한 `SQLLite3` 메서드를 살펴보겠음.

```swift
if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
    while sqlite3_step(queryStatement) == SQLITE_ROW {
        let id = sqlite3_column_int(queryStatement, 0)

        favorites.append(Favorite(id: Int(id)))
        print("#### Favorite Details: \(id)")
    }
} else {
    print("#### SELECT statement is failed.")
}
sqlite3_finalize(queryStatement)
```

DB 에 내가 만든 String 값을 넣은 후 실행, 그리고 DB에 일치하는 것이 있는지 확인을 하고 출력함.

이 코드 뿐만 아니라, 다른 `Create`, `Update`, `Delete` 들도 위 코드들과 비슷한 방식으로 진행됨.

</div>
</details>


<details>
<summary>생성한 Network 통신 API 관리 문제</summary>
<div markdown="1">

## 상황(Situation) : 문제 상황 설명

이전에 생성한 API 들을 관리해야할 필요성을 느끼고 있음.

왜냐하면 각 API 를 사용하는 함수에 계속해서 API 를 생성하는 문제가 발생하기 때문

- GET 요청하는 메소드에서 생성된 API

```swift
let api = GETTodosAPI(
    page: page.description,
    filter: Filter.createdAt.rawValue,
    orderBy: Order.desc.rawValue,
    perPage: 10.description
)
```

- PUT 요청하는 메소드에서 생성된 API

```swift
let idDTO = ToDoIDDTO(id: id.description)
let bodyDTO = ToDoBodyDTO(title: title, is_Done: isDone)
let api = PUTToDoAPI(idDTO: idDTO, bodyDTO: bodyDTO)
```

## 목표(Task) : 해결 목표

최대한 관리가 용이하게 변경하기

## 행동(Action) : 문제 해결 과정 or 시도

스위프트에는 여러가지 Case 를 관리할 수 있는 Enum 이라는 것이 존재함.

그래서 Enum 을 활용하여 API 객체를 사용하는 상황을 구분 짓기로 함.

아래의 코드는 GET, PUT 통신을 하는 상황을 Case 로 분리하고, 해당 요청이 들어오면 API 를 반환하기로 하는 Enum

```swift
enum ToDoAPI {
    case getTodos(page: Int)
    case putToDo(idDTO: ToDoIDDTO, bodyDTO: ToDoBodyDTO)

    var api: any NetworkAPIDefinition {
        switch self {
        case .getTodos(let page):
            return GETTodosAPI(
                page: page.description,
                filter: Filter.createdAt.rawValue,
                orderBy: Order.desc.rawValue,
                perPage: 10.description
            )

        case .putToDo(let idDTO, let bodyDTO):
            return PUTToDoAPI(idDTO: idDTO, bodyDTO: bodyDTO)
        }
    }
}
```

## 결과(Result) : 해결한 결과 (Image, Gif, 코드 첨부)

기존 GET 통신시 API 사용 모습

```swift
let api = GETTodosAPI(
    page: page.description,
    filter: Filter.createdAt.rawValue,
    orderBy: Order.desc.rawValue,
    perPage: 10.description
)
```

Enum이 추가된 후의 GET 통신시 API 사용 모습

```swift
let api = ToDoAPI.getTodos(page: page).api as! GETTodosAPI
```

조금 더 관리가 용이하게 변경이됨.

</div>
</details>
