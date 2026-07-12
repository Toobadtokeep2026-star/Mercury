import UIKit

class DetailViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mercury Workspace"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "A clean, sideload-ready design for your iPhone 14. This demo app includes a polished UI, dynamic navigation, and a path to expand into utilities, widgets, or secure workflows."
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
}
