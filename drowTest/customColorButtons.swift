//
//  customColorButtons.swift
//  drowTest
//
//  Created by Руслан Сидоренко on 13.06.2024.
//

import Foundation
import UIKit

class customColorButtons: UIButton {
    
    enum colorsForButtons {
        case red
        case blue
        case yellow
        case green
        case brown
        case gray
        case orange
        case purple
        case white
        case black
    }
    
    private let colorsButton: colorsForButtons
    
    init(colorsButton: colorsForButtons) {
        self.colorsButton = colorsButton
        super.init(frame: .zero)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        switch colorsButton {
        case .red:
            backgroundColor = .red
            
        case .blue:
            backgroundColor = .blue
            
        case .yellow:
            backgroundColor = .yellow
            
        case .green:
            backgroundColor = .green
            
        case .brown:
            backgroundColor = .brown
            
        case .gray:
            backgroundColor = .gray
            
        case .orange:
            backgroundColor = .orange
            
        case .purple:
            backgroundColor = .purple
            
        case .white:
            backgroundColor = .white
            
        case .black:
            backgroundColor = .black
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
   
    
    
    
}
