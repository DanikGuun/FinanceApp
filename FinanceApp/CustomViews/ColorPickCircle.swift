//
//  ColorPickCircle.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 13.06.2024.
//

import Foundation
import UIKit

class ColorPickCircle: UIImageView{
    private let delegate: ColorPickCircleDelegate
    
    init(color: UIColor, frame: CGRect, delegate: ColorPickCircleDelegate){
        self.delegate = delegate
        super.init(frame: frame)
        self.tintColor = color
        self.isUserInteractionEnabled = true
        self.image = UIImage(systemName: "circle.fill")
        self.layer.cornerRadius = frame.width/2
    }
    
    required init?(coder: NSCoder) {
        self.delegate = CategoryHandlerViewController()
        super.init(coder: coder)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate.colorPicked(color: self)
    }
    
}
protocol ColorPickCircleDelegate{
    func colorPicked(color: ColorPickCircle) -> ()
}
