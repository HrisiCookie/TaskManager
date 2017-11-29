//
//  ColorCell.swift
//  TaskManager
//
//  Created by Hristina Bailova on 29.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation
import UIKit

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configureCell(index: Int) {
        colorView.backgroundColor = ChooseColorViewController().categoryColours[index]
    }
    
    func setupView() {
        self.colorView.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

