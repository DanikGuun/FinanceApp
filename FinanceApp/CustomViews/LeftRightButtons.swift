//
//  LeftRightButtons.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 10.07.2024.
//

import UIKit

class LeftRightButtons: UIView {
    
    private var leftButton: UIButton!
    private var rightButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init(leftHandler: @escaping ((UIAction)) -> (), rightHandler: @escaping ((UIAction)) -> ()) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        setupButtons()
        leftButton.addAction(UIAction(handler: leftHandler), for: .touchUpInside)
        rightButton.addAction(UIAction(handler: rightHandler), for: .touchUpInside)
    }
    
    func constraintToUpRight(to parrent : UIView){
        self.topAnchor.constraint(equalTo: parrent.topAnchor, constant: 10).isActive = true
        self.trailingAnchor.constraint(equalTo: parrent.trailingAnchor, constant: -10).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func setupButtons(){
        leftButton = UIButton(frame: CGRect.zero)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftButton)
        leftButton.setImage(UIImage(systemName: "chevron.left")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)), for: .normal)
        leftButton.tintColor = .systemBlue
        
        leftButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3).isActive = true
        leftButton.widthAnchor.constraint(equalTo: leftButton.heightAnchor, multiplier: 1).isActive = true
        
        
        
        rightButton = UIButton(frame: CGRect.zero)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightButton)
        rightButton.setImage(UIImage(systemName: "chevron.right")?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        rightButton.tintColor = .systemBlue
        
        rightButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 3).isActive = true
        rightButton.widthAnchor.constraint(equalTo: rightButton.heightAnchor, multiplier: 1).isActive = true
    }
}
