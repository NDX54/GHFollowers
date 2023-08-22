//
//  GFItemInfoVC.swift
//  GHFollowers
//
//  Created by Jared Juangco on 4/8/23.
//

import UIKit
// class is deprecated. Use AnyObject instead.
// Ideally in programming, when shooting for optimal code, you dont want things to know about things that they dont know/shouldn't know about.
// Breaking down a delegate is a better idea.

class GFItemInfoVC: UIViewController {
    
    // We're not going to initialise this with the parameters set in because this is our superclass.
    // This holds all the common stuff.
    let stackView = UIStackView()
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let actionButton = GFButton()
    
    var user: User!
    
    // This is a custom init, but we don't have to use convenience init because
    // we don't have a function to call in multiple places.
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        configureActionButton()
        layoutUI()
        configureStackView()
    }
    
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        let infoViews = [itemInfoViewOne, itemInfoViewTwo]
        
        for itemInfoView in infoViews {
            stackView.addArrangedSubview(itemInfoView)
        }
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() { }
    
    private func layoutUI() {
        // The item info views will be added to the stackview, so we don't have to constrain those.
        // The constraints will happen in the stackview.
        view.addSubviews(stackView, actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}
