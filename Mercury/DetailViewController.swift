import UIKit

class DetailViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mercury Workspace"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Build from a calmer starting point: review readiness, choose a next action, and keep important signals visible."
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.accessibilityIdentifier = "workspaceStateLabel"
        return label
    }()

    private let stateDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Refresh Workspace", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.accessibilityHint = "Reloads workspace cards and readiness information."
        return button
    }()

    private let actionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    private enum WorkspaceState {
        case loading
        case empty
        case ready([String])
        case error(String)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Workspace"
        view.backgroundColor = .systemBackground
        setupLayout()
        setupAccessibility()
        retryButton.addTarget(self, action: #selector(refreshWorkspace), for: .touchUpInside)
        refreshWorkspace()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(bodyLabel)
        contentStack.addArrangedSubview(loadingIndicator)
        contentStack.addArrangedSubview(stateLabel)
        contentStack.addArrangedSubview(stateDetailLabel)
        contentStack.addArrangedSubview(retryButton)
        contentStack.addArrangedSubview(actionsStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 32),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    private func setupAccessibility() {
        titleLabel.accessibilityTraits = .header
        stateLabel.accessibilityTraits = .updatesFrequently
    }

    @objc private func refreshWorkspace() {
        render(.loading)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) { [weak self] in
            let actions = [
                "Review Today’s Signals",
                "Start a Focus Session",
                "Secure Notes"
            ]
            self?.render(actions.isEmpty ? .empty : .ready(actions))
        }
    }

    private func render(_ state: WorkspaceState) {
        actionsStack.arrangedSubviews.forEach { view in
            actionsStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        switch state {
        case .loading:
            loadingIndicator.startAnimating()
            stateLabel.text = "Loading workspace…"
            stateDetailLabel.text = "Preparing actions and checking the latest local state."
            retryButton.isHidden = true
            actionsStack.isHidden = true

        case .empty:
            loadingIndicator.stopAnimating()
            stateLabel.text = "No workspace actions yet"
            stateDetailLabel.text = "When Mercury has tasks, shortcuts, or secure workflows to show, they will appear here."
            retryButton.isHidden = false
            actionsStack.isHidden = true

        case .ready(let actions):
            loadingIndicator.stopAnimating()
            stateLabel.text = "Workspace ready"
            stateDetailLabel.text = "Choose a starter action below. You can expand these into utilities, widgets, or secure workflows."
            retryButton.isHidden = true
            actionsStack.isHidden = false
            actions.forEach { actionsStack.addArrangedSubview(makeActionCard(title: $0)) }
            animateCards()

        case .error(let message):
            loadingIndicator.stopAnimating()
            stateLabel.text = "Something needs attention"
            stateDetailLabel.text = message
            retryButton.isHidden = false
            actionsStack.isHidden = true
        }

        UIAccessibility.post(notification: .announcement, argument: stateLabel.text)
    }

    private func makeActionCard(title: String) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.subtitle = "Double tap to open"
        configuration.image = UIImage(systemName: "sparkles")
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = .secondarySystemBackground
        configuration.baseForegroundColor = .label
        configuration.cornerStyle = .large

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        button.accessibilityLabel = title
        button.accessibilityHint = "Opens this Mercury workspace action."
        button.addAction(UIAction { [weak self] _ in
            self?.presentPlaceholder(for: title)
        }, for: .touchUpInside)
        return button
    }

    private func animateCards() {
        guard UIAccessibility.isReduceMotionEnabled == false else { return }
        let cards = actionsStack.arrangedSubviews
        for (index, card) in cards.enumerated() {
            card.alpha = 0
            card.transform = CGAffineTransform(translationX: 0, y: 12)
            UIView.animate(withDuration: 0.35, delay: Double(index) * 0.08, options: [.curveEaseOut, .allowUserInteraction]) {
                card.alpha = 1
                card.transform = .identity
            }
        }
    }

    private func presentPlaceholder(for title: String) {
        let alert = UIAlertController(
            title: title,
            message: "This action is ready for a future workflow. For now, Mercury keeps you oriented without pretending work was completed.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Done", style: .default))
        present(alert, animated: true)
    }
}

private extension UIFont {
    func bold() -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(.traitBold) else { return self }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
