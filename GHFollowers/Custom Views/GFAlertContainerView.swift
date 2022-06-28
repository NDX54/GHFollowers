//
//  GFAlertContainerView.swift
//  GHFollowers
//
//  Created by Jared Juangco on 28/6/22.
//

//import UIKit
//
//class GFAlertContainerView: UIViewController {
//
//    let containerView = UIView()
//
//    var alertTitle: String?
//    var message: String?
//    var buttonTitle: String?
//
//    let padding: CGFloat = 20
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    init(alertTitle: String? = "Error", message: String? = "Something went wrong", buttonTitle: String? = "OK") {
//        super.init(nibName: nil, bundle: nil)
//        self.alertTitle = alertTitle
//        self.message = message
//        self.buttonTitle = buttonTitle
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    private func configureContainerView() {
//        view.addSubview(containerView)
//        containerView.backgroundColor       = .systemBackground
//        containerView.layer.cornerRadius    = 16
//        containerView.layer.borderWidth     = 2
//        containerView.layer.borderColor     = UIColor.white.cgColor
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            containerView.widthAnchor.constraint(equalToConstant: 280),
//            containerView.heightAnchor.constraint(equalToConstant: 220)
//        ])
//    }
//
//
//
//}
