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

let backgroundColors: [UIButton] = [
    customColorButtonss(colorsButton: .red, tag: 1),
    customColorButtonss(colorsButton: .blue, tag: 2),
    customColorButtonss(colorsButton: .yellow, tag: 3),
    customColorButtonss(colorsButton: .green, tag: 4),
    customColorButtonss(colorsButton: .brown, tag: 5),
    secondCustomColorButtons(colorsButton: .gray, tag: 6),
    secondCustomColorButtons(colorsButton: .orange, tag: 7),
    secondCustomColorButtons(colorsButton: .purple, tag: 8),
    secondCustomColorButtons(colorsButton: .white, tag: 9),
    secondCustomColorButtons(colorsButton: .black, tag: 10)
]

func backgroundColors(iconForButton: UIImage, tag: Int) -> UIButton {
    let button = UIButton()
    button.tag = tag
    button.setBackgroundImage(iconForButton, for: .normal)
    return button
}

//MARK: undo and clear buttons
func undoAndClearButtons(iconForButton: UIImage, tag: Int) -> UIButton {
    let button = UIButton()
    button.tag = tag
    button.setBackgroundImage(iconForButton, for: .normal)
    return button
}

let undoAndClearButton: [UIButton] = [
    undoAndClearButtons(iconForButton: UIImage(systemName: "arrow.uturn.backward.circle")!, tag: 1),
    undoAndClearButtons(iconForButton: UIImage(systemName: "xmark.circle")!, tag: 2),
]



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
            print(line.points)
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
    let imageView = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuoBackgroundColor()
        view.addSubview(drawLine)
        drawLine.frame = view.frame
        drawLine.backgroundColor = .clear
        setupButtons()
        setupImagePicker()
    }
    
    private func setuoBackgroundColor(){
        view.layer.addSublayer(imageView)
        imageView.frame = view.bounds
        imageView.backgroundColor = UIColor.white.cgColor
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
        
        
        //MARK: first horizontal color buttons for choose color brush
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
        
        //MARK: second horizontal color buttons for choose color brush
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
        
        //MARK: Undo and Clear Buttons
        let uacButtonsStack = UIStackView()
        view.addSubview(uacButtonsStack)
        uacButtonsStack.frame = CGRect(x: 18,
                                       y: Int(view.frame.height) - 150,
                                       width: 105,
                                       height: 50)
        uacButtonsStack.axis = .horizontal
        uacButtonsStack.spacing = 5.0
        uacButtonsStack.distribution = .fillEqually
        
        undoAndClearButton.forEach { button in
            uacButtonsStack.addArrangedSubview(button)
        }
        
        for tags in undoAndClearButton {
            tags.addTarget(self, action: #selector(didTapUac(sender: )), for: .touchUpInside)
        }
        
        //MARK: choose background color
        let cBCStack = UIStackView()
        view.addSubview(cBCStack)
        cBCStack.frame = CGRect(x: 18,
                                y: 50,
                                width: 340,
                                height: 30)
        cBCStack.axis = .horizontal
        cBCStack.spacing = 5.0
        cBCStack.distribution = .fillEqually
        
        backgroundColors.forEach { button in
            cBCStack.addArrangedSubview(button)
        }
        
        for tags in backgroundColors {
            tags.addTarget(self, action: #selector(didTapBackgroundColor(sender: )), for: .touchUpInside)
        }
        
        
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
    
    @objc func didTapUac(sender: UIButton){
        switch sender.tag {
        case 1:
            if !drawLine.lines.isEmpty {
                drawLine.lines.removeLast()
                drawLine.setNeedsDisplay()
                print("undo")
            } else {
                print("lines are empty")
            }
            
        case 2:
            print("clear")
            drawLine.lines.removeAll()
            drawLine.setNeedsDisplay()
        default:
            print("default")
        }
    }
    
    @objc func didTapBackgroundColor(sender: UIButton){
        switch sender.tag {
        case 1:
            imageView.backgroundColor = UIColor.red.cgColor
        case 2:
            imageView.backgroundColor = UIColor.blue.cgColor
        case 3:
            imageView.backgroundColor = UIColor.yellow.cgColor
        case 4:
            imageView.backgroundColor = UIColor.green.cgColor
        case 5:
            imageView.backgroundColor = UIColor.brown.cgColor
        case 6:
            imageView.backgroundColor = UIColor.gray.cgColor
        case 7:
            imageView.backgroundColor = UIColor.orange.cgColor
        case 8:
            imageView.backgroundColor = UIColor.purple.cgColor
        case 9:
            imageView.backgroundColor = UIColor.white.cgColor
        case 10:
            imageView.backgroundColor = UIColor.black.cgColor
        default:
            print("default")
        }
    }
}
