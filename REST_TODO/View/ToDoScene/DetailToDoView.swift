//
//  DetailToDoView.swift
//  REST_TODO
//
//  Created by 준우의 MacBook 16 on 5/18/24.
//

import Combine
import UIKit

private enum Detail {
    case add
    case edit
    case basic

    var defaultTitle: String {
        switch self {
        case .add:
            return "할일 추가"
        case .edit:
            return "할일 수정"
        case .basic:
            return "n/a"
        }
    }

    var placeHolder: String {
        return "할일을 입력해주세요"
    }

    var defaultStr: String {
        return "할일"
    }

    var isDone: String {
        return "완료"
    }
}

final class DetailToDoView: UIViewController {
    var viewModel: DetailToDoViewModel!

    private let input: PassthroughSubject<DetailToDoViewModel.Input, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()

    private let titleDefaultLabel = UILabel(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let titleTextField = UITextField(frame: .zero)

    private let isDoneLabel = UILabel(frame: .zero)
    private let isDoneSwitch = UISwitch(frame: .zero)

    private let doneButton = UIButton(frame: .zero)

    var delegate: ToDoViewDelegate?

    deinit {
        print("&&&& DetailToDoView Deinitialized")
    }
}

// MARK: - View Life Cycle

extension DetailToDoView {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        confirmUserAction(action: viewModel.currentUserAction)
    }
}

// MARK: - ViewModel Binding

extension DetailToDoView {
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output.sink { [weak self] event in
            switch event {
            case .dismissView:
                self?.delegate?.dismissView()

            case .getToDo(let todo):
                self?.configure(action: .edit, todo: todo)

            case .sendError(let error):
                self?.showAlert(title: error.localizedDescription)
            }
        }
        .store(in: &subscriptions)
    }
}

// MARK: - Setting Up View

extension DetailToDoView {
    private func setupUI() {
        view.backgroundColor = .init(hexCode: "#F7F8FA")
        addView()

        configureTitleDefaultLabel()
        configureTitleLabel()
        configureTitleTextField()
        configureIsDoneLabel()
        configureIsDoneSwitch()
        configureDoneButton()

        configureBackButton()
    }

    private func addView() {
        [titleDefaultLabel, titleLabel, titleTextField, isDoneLabel, isDoneSwitch, doneButton].forEach { view.addSubview($0) }
    }

    private func configure(action: UserAction, todo: ToDoData?) {
        if action == UserAction.add {
            navigationItem.title = Detail.add.defaultTitle
            titleDefaultLabel.text = Detail.add.defaultTitle
            titleLabel.text = Detail.basic.defaultStr
            titleTextField.placeholder = Detail.basic.placeHolder
            isDoneLabel.text = Detail.basic.isDone
            isDoneSwitch.isOn = false
            doneButton.setTitle(Detail.basic.isDone, for: .normal)
        } else {
            guard let title = todo?.title else { return }
            guard let isDone = todo?.isDone else { return }

            DispatchQueue.main.async {
                self.navigationItem.title = Detail.edit.defaultTitle
                self.titleDefaultLabel.text = Detail.edit.defaultTitle
                self.titleLabel.text = Detail.basic.defaultStr
                self.titleTextField.placeholder = Detail.basic.placeHolder
                self.titleTextField.text = title
                self.isDoneLabel.text = Detail.basic.isDone
                self.isDoneSwitch.isOn = isDone
                self.doneButton.setTitle(Detail.basic.isDone, for: .normal)
            }
        }
    }

    func confirmUserAction(action: UserAction) {
        if action == .add {
            configure(action: action, todo: nil)
        } else {
            input.send(.requestGETToDo)
        }
    }
}

// MARK: - Configure

extension DetailToDoView {
    private func configureTitleDefaultLabel() {
        titleDefaultLabel.translatesAutoresizingMaskIntoConstraints = false

        titleDefaultLabel.font = .systemFont(ofSize: 35, weight: .bold)
        titleDefaultLabel.textColor = .black

        let constraints = [
            titleDefaultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleDefaultLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            titleDefaultLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            titleDefaultLabel.heightAnchor.constraint(equalToConstant: 30)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black

        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: titleDefaultLabel.bottomAnchor, constant: 30),
            titleLabel.leftAnchor.constraint(equalTo: titleDefaultLabel.leftAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureTitleTextField() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false

        titleTextField.layer.borderColor = UIColor.systemGray4.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.cornerRadius = 10

        titleTextField.font = .systemFont(ofSize: 17, weight: .regular)
        titleTextField.textColor = .black

        titleTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        titleTextField.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        titleTextField.leftViewMode = .always
        titleTextField.rightViewMode = .always

        let constraints = [
            titleTextField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            titleTextField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 15),
            titleTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            titleTextField.heightAnchor.constraint(equalToConstant: 40)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureIsDoneLabel() {
        isDoneLabel.translatesAutoresizingMaskIntoConstraints = false

        isDoneLabel.font = .systemFont(ofSize: 20, weight: .bold)
        isDoneLabel.textColor = .black

        let constraints = [
            isDoneLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 90),
            isDoneLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            isDoneLabel.widthAnchor.constraint(equalToConstant: 50),
            isDoneLabel.heightAnchor.constraint(equalToConstant: 30)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureIsDoneSwitch() {
        isDoneSwitch.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            isDoneSwitch.topAnchor.constraint(equalTo: isDoneLabel.topAnchor),
            isDoneSwitch.bottomAnchor.constraint(equalTo: isDoneLabel.bottomAnchor),
            isDoneSwitch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            isDoneSwitch.widthAnchor.constraint(equalToConstant: 50)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureDoneButton() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 10

        doneButton.tintColor = .white
        doneButton.backgroundColor = .black

        let constraints = [
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.topAnchor.constraint(equalTo: isDoneLabel.bottomAnchor, constant: 50),
            doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ]

        NSLayoutConstraint.activate(constraints)

        doneButton.addAction(UIAction(handler: { [weak self] _ in
            guard let text = self?.titleTextField.text else { return }
            guard let isDone = self?.isDoneSwitch.isOn else { return }

            if self?.viewModel.currentUserAction == .add {
                self?.input.send(.requestPOSTToDoAPI(title: text, isDone: isDone))
            } else {
                self?.input.send(.requestPUTToDoAPI(title: text, isDone: isDone))
            }

        }), for: .touchUpInside)
    }
}

extension DetailToDoView {
    private func configureBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("닫기", for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 18)

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        backButton.setImage(image, for: .normal)
        backButton.sizeToFit()

        backButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.dismiss(animated: true)
        }), for: .touchUpInside)

        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
}

// MARK: - Alert

extension DetailToDoView {
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}
