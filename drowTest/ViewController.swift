//
//  ViewController.swift
//  drowTest
//
//  Created by Руслан Сидоренко on 13.06.2024.
//

import UIKit

//MARK: first and second color palitra
func customColorButtonss(colorsButton: UIColor, tag: Int) -> UIButton {
    let button = UIButton()
    button.backgroundColor = colorsButton
    button.tag = tag
    button.layer.cornerRadius = 7
    button.layer.borderWidth = 0.3
    button.layer.borderColor = UIColor.darkGray.cgColor
    button.clipsToBounds = true
    return button
}

func secondCustomColorButtons(colorsButton: UIColor, tag: Int) -> UIButton {
    let button = UIButton()
    button.backgroundColor = colorsButton
    button.tag = tag
    button.layer.cornerRadius = 7
    button.layer.borderWidth = 0.3
    button.layer.borderColor = UIColor.darkGray.cgColor
    button.clipsToBounds = true
    return button
}

let colorButtons: [UIButton] = [
    customColorButtonss(colorsButton: .red, tag: 1),
    customColorButtonss(colorsButton: .blue, tag: 2),
    customColorButtonss(colorsButton: .yellow, tag: 3),
    customColorButtonss(colorsButton: .green, tag: 4),
    customColorButtonss(colorsButton: .brown, tag: 5)
]

let secondColorButtons: [UIButton] = [
    secondCustomColorButtons(colorsButton: .gray, tag: 6),
    secondCustomColorButtons(colorsButton: .orange, tag: 7),
    secondCustomColorButtons(colorsButton: .purple, tag: 8),
    secondCustomColorButtons(colorsButton: .white, tag: 9),
    secondCustomColorButtons(colorsButton: .black, tag: 10)
    
]

//MARK: undo and clear buttons
func undoAndClearButtons(iconForButton: UIImage, tag: Int) -> UIButton {
    let button = UIButton()
    button.setBackgroundImage(iconForButton, for: .normal)
    return button
}
var widthValue: CGFloat = 1.0
var colorBrush: CGColor = UIColor.black.cgColor

struct Line {
    var points: [CGPoint]
    var width: CGFloat
    var colorBrush: CGColor
}

class draw: UIView {
    
    var lines = [Line]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        lines.forEach { (line) in
            context.setLineWidth(line.width)
            context.setStrokeColor(line.colorBrush)
            
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line(points: [CGPoint](),
                          width: widthValue,
                          colorBrush: colorBrush))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        
        guard var lastLine = lines.popLast() else {
            return
        }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let drawLine = draw()
    let backgroundPicker = UIImagePickerController()
    let addImageToBG = UIButton()
    var backgroundImage: UIImage = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(drawLine)
        drawLine.frame = view.frame
        drawLine.backgroundColor = .white
        setupButtons()
        setupImagePicker()
    }
    
    private func setupImagePicker(){
        view.addSubview(addImageToBG)
        addImageToBG.frame = CGRect(x: Int(view.frame.width) - 70,
                                    y: Int(view.frame.height) - 170,
                                    width: 50,
                                    height: 50)
        addImageToBG.setBackgroundImage(.add, for: .normal)
        addImageToBG.addTarget(self, action: #selector(didTapPickImage), for: .touchUpInside)
        
        backgroundPicker.delegate = self
    }
    
    @objc func didTapPickImage(){
        present(backgroundPicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        dismiss(animated: true)
        DispatchQueue.main.async {
            self.backgroundImage = image!
        }
    }
    
    private func setupButtons(){
        let chooseWidthOfLine = UISlider(frame: CGRect(x: 18,
                                                       y: Int(view.frame.height) - 90,
                                                       width: 150,
                                                       height: 50))
        view.addSubview(chooseWidthOfLine)
        chooseWidthOfLine.minimumValue = 1
        chooseWidthOfLine.maximumValue = 50
        chooseWidthOfLine.addTarget(self, action: #selector(sliderAction(sender:)), for: .valueChanged)
        
        
        //first horizontal color buttons for choose color brush
        let buttonsStack = UIStackView()
        view.addSubview(buttonsStack)
        buttonsStack.frame = CGRect(x: 200,
                                    y: Int(view.frame.height) - 100,
                                    width: 170,
                                    height: 30)
        buttonsStack.axis = .horizontal
        buttonsStack.distribution = .fill
        buttonsStack.spacing = 5.0
        
        colorButtons.forEach { button in
            buttonsStack.addArrangedSubview(button)
        }
        
        for tags in colorButtons {
            tags.addTarget(self, action: #selector(didTapColor(sender: )), for: .touchUpInside)
        }
        
        //second horizontal color buttons for choose color brush
        let secondButtonsStack = UIStackView()
        view.addSubview(secondButtonsStack)
        secondButtonsStack.frame = CGRect(x: 200,
                                    y: Int(view.frame.height) - 60,
                                    width: 170,
                                    height: 30)
        secondButtonsStack.axis = .horizontal
        secondButtonsStack.distribution = .fill
        secondButtonsStack.spacing = 5.0
        
        secondColorButtons.forEach { button in
            secondButtonsStack.addArrangedSubview(button)
        }
        
        for tags in secondColorButtons {
            tags.addTarget(self, action: #selector(didTapColor(sender: )), for: .touchUpInside)
        }
        
        //undo and clear buttons
        let uacButtonsStack = UIStackView()
        view.addSubview(uacButtonsStack)
        uacButtonsStack.frame = CGRect(x: 18,
                                       y: Int(view.frame.height) - 150,
                                       width: 105,
                                       height: 50)
        uacButtonsStack.axis = .horizontal
        uacButtonsStack.spacing = 5.0
        uacButtonsStack.distribution = .fillEqually
        
    }
    
    @objc func sliderAction(sender: UISlider) {
        widthValue = CGFloat(sender.value)
    }
    
    @objc func didTapColor(sender: UIButton){
        switch sender.tag {
        case 1:
            colorBrush = UIColor.red.cgColor
        case 2:
            colorBrush = UIColor.blue.cgColor
        case 3:
            colorBrush = UIColor.yellow.cgColor
        case 4:
            colorBrush = UIColor.green.cgColor
        case 5:
            colorBrush = UIColor.brown.cgColor
        case 6:
            colorBrush = UIColor.gray.cgColor
        case 7:
            colorBrush = UIColor.orange.cgColor
        case 8:
            colorBrush = UIColor.purple.cgColor
        case 9:
            colorBrush = UIColor.white.cgColor
        case 10:
            colorBrush = UIColor.black.cgColor
        default:
            colorBrush = UIColor.black.cgColor
            
        }
    }
}
