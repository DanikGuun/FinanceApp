//
//  ColorPickerCollectionView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 17.06.2024.
//

import Foundation
import UIKit

class ColorpickerCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var parentView: ColorpickerDelegate!
    var activeColor: UIColor?
    var colors: [UIColor] = []
    required init?(coder: NSCoder) {
        
        activeColor = Model.shared.activeColor
        colors = Model.shared.getRandomColors(count: 6)
        if let startColor = self.activeColor { colors[0] = startColor }//если есть, то ставим текущий цвет
        super.init(coder: coder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorpickCell", for: indexPath) as! ColorpickCell
        
        if indexPath.row < colors.count {cell.setup(color: colors[indexPath.row])}
        else {cell.setup(color: .systemGray4, image: UIImage(systemName: "ellipsis.circle.fill")!)}
        
        if indexPath.row == 0{
            cell.selectColor()
            parentView.colorPick(cell.color)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as! ColorpickCell
        
        if indexPath.row != collectionView.visibleCells.count - 1{
            for otherCell in collectionView.visibleCells as! [ColorpickCell]{
                otherCell.deselectColor()
            }
            cell.selectColor()
        }
        //если не меню выбора цветов
        if indexPath.row != collectionView.visibleCells.count - 1 {parentView.colorPick(cell.color)}
        else {parentView.moreColorsPressed()}
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.height
        let height = width
        return CGSize(width: width, height: height)
    }
    
    ///используется для обновления списка цветов, например при выборе цвета из меню
    func inserColor(_ color: UIColor){
        activeColor = color
        
        //если что заменяем повтор
        for (index, c) in colors.enumerated(){
            if c == color {
                colors[index] = Model.shared.getRandomColors(count: 1, otherwise: colors)[0]
            }
        }
        
        colors.insert(color, at: 0)
        colors = colors.dropLast()
        self.reloadData()
    }
}
protocol ColorpickerDelegate{
    func colorPick(_ color: UIColor)
    func moreColorsPressed()
}
