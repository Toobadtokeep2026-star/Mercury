import UIKit

class MainViewController: UIViewController {
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let glyphLabel: UILabel = {
        let label = UILabel()
        label.text = "☿"
        label.font = UIFont.systemFont(ofSize: 72, weight: .bold)
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityLabel = "Mercury symbol"
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mercury"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "A focused productivity hub with clear guidance, quick feedback, and room to grow."
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Ready to open your workspace."
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "launchStatusLabel"
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Launch Mercury", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.accessibilityHint = "Opens the Mercury workspace after a quick readiness check."
        button.accessibilityIdentifier = "launchMercuryButton"
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        return indicator
    }()

    private var launchWorkItem: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        setupLayout()
        setupAccessibility()
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateEntranceIfNeeded()
    }

    private func setupLayout() {
        view.addSubview(contentStack)
        contentStack.addArrangedSubview(glyphLabel)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(subtitleLabel)
        contentStack.addArrangedSubview(statusLabel)

        view.addSubview(actionButton)
        actionButton.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -72),

            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            actionButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            actionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),

            activityIndicator.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor, constant: -20)
        ])
    }

    private func setupAccessibility() {
        titleLabel.accessibilityTraits = .header
        subtitleLabel.accessibilityLabel = "Mercury is a focused productivity hub with clear guidance, quick feedback, and room to grow."
    }

    private func animateEntranceIfNeeded() {
        guard UIAccessibility.isReduceMotionEnabled == false else { return }
        contentStack.alpha = 0
        contentStack.transform = CGAffineTransform(translationX: 0, y: 18)
        actionButton.alpha = 0
        actionButton.transform = CGAffineTransform(translationX: 0, y: 18)

        UIView.animate(withDuration: 0.55, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            self.contentStack.alpha = 1
            self.contentStack.transform = .identity
        }

        UIView.animate(withDuration: 0.55, delay: 0.12, options: [.curveEaseOut, .allowUserInteraction]) {
            self.actionButton.alpha = 1
            self.actionButton.transform = .identity
        }
    }

    @objc private func didTapAction() {
        setLoading(true)

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.setLoading(false)

            guard self.navigationController != nil else {
                self.presentLaunchError(message: "Mercury could not find a navigation stack. Please restart the app and try again.")
                return
            }

            let detailVC = DetailViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        }

        launchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: workItem)
    }

    private func setLoading(_ isLoading: Bool) {
        actionButton.isEnabled = !isLoading
        actionButton.alpha = isLoading ? 0.85 : 1
        actionButton.setTitle(isLoading ? "Opening…" : "Launch Mercury", for: .normal)
        statusLabel.text = isLoading ? "Checking workspace readiness…" : "Ready to open your workspace."
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        UIAccessibility.post(notification: .announcement, argument: statusLabel.text)
    }

    private func presentLaunchError(message: String) {
        statusLabel.text = "Launch interrupted."
        let alert = UIAlertController(title: "Could not launch Mercury", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            self?.didTapAction()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    deinit {
        launchWorkItem?.cancel()
    }
}

private extension UIFont {
    func bold() -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(.traitBold) else { return self }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
