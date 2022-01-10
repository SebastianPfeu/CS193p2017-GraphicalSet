//
//  CardView.swift
//  GraphicalSet
//
//  Created by Sebastian Pfeufer on 02/05/2021.
//

import UIKit

class CardView: UIView {

//MARK: - Declaration of supporting data structures and variables
    enum CardSymbolAmount: Int {
        case one = 1, two = 2, three = 3
    }
    
    enum CardSymbolShape {
        case oval, diamond, squiggle
    }
    
    enum CardSymbolColor {
        case red, green, blue
    }
    
    enum CardSymbolShading {
        case solid, striped, outlined
    }
    
    var cardSymbolAmount: CardSymbolAmount = CardSymbolAmount.one
    var cardSymbolShape: CardSymbolShape = CardSymbolShape.oval
    var cardSymbolColor: CardSymbolColor = CardSymbolColor.red
    var cardSymbolShading: CardSymbolShading = CardSymbolShading.solid
    
//MARK: - Draw function
    override func draw(_ rect: CGRect) {
        switch cardSymbolShape {
            case .oval: drawOvals(amount: cardSymbolAmount, color: cardSymbolColor, shading: cardSymbolShading)
            case .diamond: drawDiamonds(amount: cardSymbolAmount, color: cardSymbolColor, shading: cardSymbolShading)
            case .squiggle: drawSquiggles(amount: cardSymbolAmount, color: cardSymbolColor, shading: cardSymbolShading)
        }
    }
    
//MARK: - Drawing the symbols oval, diamond and squiggle
    private func drawOvals(amount: CardSymbolAmount, color: CardSymbolColor, shading: CardSymbolShading) {
        var symbolOffset: CGFloat = 0
        if amount.rawValue == 2 {
            symbolOffset = -bounds.width/8
        }
        
        let path = UIBezierPath()
        
        for i in 1...amount.rawValue {
            path.move(to: CGPoint(x: bounds.midX + symbolOffset, y: bounds.midY - bounds.height/8))
            path.addArc(withCenter: CGPoint(x: bounds.midX + symbolOffset, y: bounds.midY - bounds.height/8), radius: bounds.width/12, startAngle: CGFloat.pi, endAngle: CGFloat.pi*2, clockwise: true)
            path.addArc(withCenter: CGPoint(x: bounds.midX + symbolOffset, y: bounds.midY + bounds.height/8), radius: bounds.width/12, startAngle: CGFloat.pi*2, endAngle: CGFloat.pi, clockwise: true)
            path.addLine(to: CGPoint(x: bounds.midX - bounds.width/12 + symbolOffset, y: bounds.midY - bounds.height/8))
            
            if i == 1 && amount.rawValue == 2 {
                symbolOffset = bounds.width/8
            }
            if i == 1 && amount.rawValue == 3 {
                symbolOffset = -bounds.width/4
            }
            if i == 2 {
                symbolOffset = bounds.width/4
            }
        }
        defineSymbolLook(amount: amount, color: color, shading: shading, path: path)
    }
    
    private func drawDiamonds(amount: CardSymbolAmount, color: CardSymbolColor, shading: CardSymbolShading) {
        var symbolOffset = CGFloat(0)
        if amount.rawValue == 2 {
            symbolOffset = -bounds.width/8
        }
        
        let widthIndention = CGFloat(bounds.width/3)
        let heightIndention = CGFloat(bounds.height/4)
        
        let path = UIBezierPath()
        
        for i in 1...amount.rawValue {
            path.move(to: CGPoint(x: bounds.minX + (bounds.maxX*0.07) + widthIndention + symbolOffset, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.midX + symbolOffset, y: bounds.minY + heightIndention))
            path.addLine(to: CGPoint(x: bounds.maxX - (bounds.maxX*0.07) - widthIndention + symbolOffset, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.midX + symbolOffset, y: bounds.maxY - heightIndention))
            path.close()

            if i == 1 && amount.rawValue == 2 {
                symbolOffset = bounds.width/8
            }
            if i == 1 && amount.rawValue == 3 {
                symbolOffset = -bounds.width/4
            }
            if i == 2 {
                symbolOffset = bounds.width/4
            }
        }
        defineSymbolLook(amount: amount, color: color, shading: shading, path: path)
    }
    
    private func drawSquiggles(amount: CardSymbolAmount, color: CardSymbolColor, shading: CardSymbolShading) {
        let distanceX = bounds.midX/3.5
        let offsetX = bounds.maxX/5
        let boundsOffsetY = bounds.maxY/4
        let offsetY = boundsOffsetY/4
        
        var symbolOffset = -distanceX/2
        if amount.rawValue == 2 {
            symbolOffset = (-distanceX/2) + (-bounds.width/8)
        }
        
        let path = UIBezierPath()
        
        for i in 1...amount.rawValue {
            let controlPointHighLeft = CGPoint(x: bounds.midX + offsetX + symbolOffset, y: bounds.midY + offsetY)
            let controlPointLowLeft = CGPoint(x: bounds.midX - offsetX + symbolOffset, y: bounds.midY - offsetY)
            let controlPointHighRight = CGPoint(x: bounds.midX + offsetX + distanceX + symbolOffset, y: bounds.midY + offsetY)
            let controlPointLowRight = CGPoint(x: bounds.midX - offsetX + distanceX + symbolOffset, y: bounds.midY - offsetY)
            
            path.move(to: CGPoint(x: bounds.midX + symbolOffset, y: bounds.maxY - boundsOffsetY))
            path.addCurve(to: CGPoint(x: bounds.midX + symbolOffset, y: bounds.minY + boundsOffsetY), controlPoint1: controlPointLowLeft, controlPoint2: controlPointHighLeft)
            path.addLine(to: CGPoint(x: bounds.midX + distanceX + symbolOffset, y: bounds.minY + boundsOffsetY))
            path.addCurve(to: CGPoint(x: bounds.midX + distanceX + symbolOffset, y: bounds.maxY - boundsOffsetY), controlPoint1: controlPointHighRight, controlPoint2: controlPointLowRight)
            path.close()

            if i == 1 && amount.rawValue == 2 {
                symbolOffset = (-distanceX/2) + (bounds.width/8)
            }
            if i == 1 && amount.rawValue == 3 {
                symbolOffset = (-distanceX/2) + (-bounds.width/4)
            }
            if i == 2 {
                symbolOffset = (-distanceX/2) + (bounds.width/4)
            }
        }
        defineSymbolLook(amount: amount, color: color, shading: shading, path: path)
    }
    
//MARK: - Supporting functions
    private func defineSymbolLook(amount: CardSymbolAmount, color: CardSymbolColor, shading: CardSymbolShading, path: UIBezierPath) {
        switch shading {
            case .solid:
                switch color {
                    case .red: UIColor.red.setFill(); UIColor.red.setStroke()
                    case .green: UIColor.green.setFill(); UIColor.green.setStroke()
                    case .blue: UIColor.blue.setFill(); UIColor.blue.setStroke()
                }
                path.lineWidth = 4
                path.stroke()
                path.fill()
                path.addClip()
            case .outlined:
                switch color {
                    case .red: UIColor.white.setFill(); UIColor.red.setStroke()
                    case .green: UIColor.white.setFill(); UIColor.green.setStroke()
                    case .blue: UIColor.white.setFill(); UIColor.blue.setStroke()
                }
                path.lineWidth = 4
                path.stroke()
                path.fill()
                path.addClip()
            case .striped:
                switch color {
                    case .red: UIColor.white.setFill(); UIColor.red.setStroke()
                    case .green: UIColor.white.setFill(); UIColor.green.setStroke()
                    case .blue: UIColor.white.setFill(); UIColor.blue.setStroke()
                }
                path.lineWidth = 4
                path.stroke()
                path.fill()
                path.addClip()
                var currentY: CGFloat = 0
                let stripedPath = UIBezierPath()
                stripedPath.lineWidth = 1
                while currentY < bounds.size.height {
                    stripedPath.move(to: CGPoint(x: 0, y: currentY))
                    stripedPath.addLine(to: CGPoint(x: bounds.size.width, y: currentY))
                    currentY += 0.05 * bounds.size.height
                }
                stripedPath.stroke()
        }
    }
}
