//
//  ToDoViewModel.swift
//  REST_TODO
//
//  Created by 준우의 MacBook 16 on 5/18/24.
//

import Combine
import Foundation

final class ToDoViewModel: ViewModelType {
    let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    private let output: PassthroughSubject<Output, Never> = .init()
    private var subcriptions = Set<AnyCancellable>()

    private(set) var todos: [ToDoData]?
    private(set) var page: Int = 1
    private(set) var isHide: Bool = false
    private(set) var isTapped: Bool = false
    private(set) var fetchingMore: Bool = false

    enum Input {
        case requestGETTodos
        case requestGETSearchToDos(query: String)
        case requestPUTToDo(todo: ToDoData)
        case requestDELETEToDo(id: Int)
        case requestGoToEdit(id: Int)

        case requestHideComplete
        case requestScrolling
        case requestScrollingWithQuery(query: String)
        case requestTapFloattingButton
    }

    enum Output {
        case showGETTodos(todos: [ToDoData])
        case showGETSearchToDosAPI(todos: [ToDoData])
        case goToEdit(id: Int)

        case scrolling(todos: [ToDoData])
        case tapFloattingButton(isTapped: Bool)

        /// Error
        case sendError(error: Error)
    }

    var groupedTodos: [String: [ToDoData]] {
        let groupedDictionary = Dictionary(grouping: todos ?? []) { todo in
            return todo.createdAt?.dateFormatterForDate() ?? ""
        }
        return groupedDictionary
    }

    var sortedSectionKeys: [String] {
        return groupedTodos.keys.sorted(by: >)
    }
}

// MARK: - API 및 Output

extension ToDoViewModel {
    /// Input -> Output
    /// - Parameter input: Input Publisher
    /// - Returns: Output Publisher
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .requestGETTodos:
                if self?.isHide == true {
                    self?.requestGETNonCompletedTodos()
                } else {
                    self?.requestGETTodos()
                }

            case .requestGETSearchToDos(let query):
                self?.requestGETSearchToDosAPI(query: query)

            case .requestPUTToDo(let todo):
                self?.requestPUTToDoAPI(todo: todo)

            case .requestDELETEToDo(let id):
                self?.requestDELETEToDoAPI(id: id)

            case .requestGoToEdit(let id):
                self?.output.send(.goToEdit(id: id))

            case .requestHideComplete:
                self?.requestGETTodos()

            case .requestScrolling:
                if self?.isHide == true {
                    self?.requestScrollingNonCompleted()
                } else {
                    self?.requestScrolling()
                }

            case .requestScrollingWithQuery(let query):
                self?.requestScrollingWithQuery(query: query)

            case .requestTapFloattingButton:
                self?.toggleIsTapped()
            }
        }
        .store(in: &subcriptions)

        return output.eraseToAnyPublisher()
    }

    /// ToDo 데이터 10개 호출 - 완료 숨김 X
    private func requestGETTodos() {
        guard let api = APICase.getTodos(page: page).api as? GETTodosAPI else { return }

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
                self?.todos = response.data ?? []
                self?.output.send(.showGETTodos(todos: self?.todos ?? []))
            }
            .store(in: &subcriptions)
    }

    /// ToDo 데이터 10개 호출 - 완료 숨김 O
    private func requestGETNonCompletedTodos() {
        guard let api = APICase.getNonCompletedTodos(page: page, isDone: false).api as? GETHideCompletedTodosAPI else { return }

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

    /// 서버에서 Query 값을 기준으로 ToDo 데이터 검색
    /// - Parameter query: 검색 값
    private func requestGETSearchToDosAPI(query: String) {
        resetPageCount()
        let dto = ToDoQueryDTO(query: query, page: page.description, filter: Filter.createdAt.rawValue, orderBy: Order.desc.rawValue, perPage: 10.description)
        guard let api = APICase.getSearchTodos(dto: dto).api as? GETSearchToDosAPI else { return }

        apiService.request(api)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("#### Error Searching todos: \(error)")
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

    /// ToDo 데이터 업데이트
    /// - Parameter todo: 변경할 ToDo 데이터
    private func requestPUTToDoAPI(todo: ToDoData) {
        guard let title = todo.title,
              let isDone = todo.isDone,
              let id = todo.id else { return }

        let idDTO = ToDoIDDTO(id: id.description)
        let bodyDTO = ToDoBodyDTO(title: title, is_Done: isDone)
        guard let api = APICase.putToDo(idDTO: idDTO, bodyDTO: bodyDTO).api as? PUTToDoAPI else { return }

        apiService.requestWithEncoded(api)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("#### Error updating todo: \(error)")
                    self.output.send(.sendError(error: error))
                case .finished:
                    print("#### Finished \(completion)")
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                // 로컬 데이터 업데이트
                if let index = self.todos?.firstIndex(where: { $0.id == id }) {
                    self.todos?[index].isDone = isDone
                    self.output.send(.showGETTodos(todos: self.todos ?? []))
                }
            }
            .store(in: &subcriptions)
    }

    /// ToDo 데이터 삭제
    /// - Parameter id: 삭제할 ToDo 데이터의 ID 값
    private func requestDELETEToDoAPI(id: Int) {
        let dto = ToDoIDDTO(id: id.description)
        guard let api = APICase.deleteTodo(dto: dto).api as? DELETEToDoAPI else { return }

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

    /// 무한 스크롤링 - 검색 X, 완료 숨김 X
    private func requestScrolling() {
        guard let api = APICase.infiniteScrolling(page: page).api as? GETTodosAPI else { return }

        apiService.request(api)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("#### Error fetching more todos: \(error)")
                    self.output.send(.sendError(error: error))
                case .finished:
                    print("#### Finished \(completion)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.todos? += response.data ?? []
                self.output.send(.scrolling(todos: self.todos ?? []))
            }
            .store(in: &subcriptions)
    }

    /// 무한 스크롤링 - 검색 X, 완료 숨김 O
    private func requestScrollingNonCompleted() {
        guard let api = APICase.infiniteScrollingNonCompleted(page: page, isDone: false).api as? GETHideCompletedTodosAPI else { return }

        apiService.request(api)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("#### Error fetching more todos: \(error)")
                case .finished:
                    print("#### Finished \(completion)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.todos? += response.data ?? []
                self.output.send(.scrolling(todos: self.todos ?? []))
            }
            .store(in: &subcriptions)
    }

    /// 무한 스크롤링 - 검색 O - 완료 여부 숨김 처리 X
    private func requestScrollingWithQuery(query: String) {
        let dto = ToDoQueryDTO(query: query, page: page.description, filter: Filter.createdAt.rawValue, orderBy: Order.desc.rawValue, perPage: 10.description)
        guard let api = APICase.infiniteScrollingWithQuery(dto: dto).api as? GETSearchToDosAPI else { return }

        apiService.request(api)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("#### Error Searching todos: \(error)")
                case .finished:
                    print("#### Finished \(completion)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.todos? += response.data ?? []
                self.output.send(.scrolling(todos: self.todos ?? []))
            }
            .store(in: &subcriptions)
    }
}

// MARK: - ViewModel's Origin Method

extension ToDoViewModel {
    func toggleIsTapped() {
        isTapped.toggle()
        output.send(.tapFloattingButton(isTapped: isTapped))
    }

    func toggleFetchingMore() {
        fetchingMore.toggle()
    }

    func resetFetchMore() {
        fetchingMore = false
    }

    func increasePageCount() {
        page += 1
    }

    func decreasePageCount() {
        if page <= 0 {
            page = 1
        } else {
            page -= 1
        }
    }

    func resetPageCount() {
        page = 1
    }

    func toggleIsHide() {
        isHide.toggle()
    }

    func resetIsHide() {
        isHide = false
    }
}
