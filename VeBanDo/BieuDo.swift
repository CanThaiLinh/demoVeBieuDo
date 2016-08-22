//
//  BieuDo.swift
//  VeBanDo
//
//  Created by thailinh on 8/8/16.
//  Copyright © 2016 thailinh. All rights reserved.
//

import UIKit

class BanDo: UIView {
    var title: String = "Giá Trị"
    var graphPoints: Array<Int> = []
    var graphTitles: Array<String> = []
    var graphMargin = UIEdgeInsetsMake(30, 40, 34, 30)
    let graphTopPadding: CGFloat = 5
    var maxValue: Int = 0
    
    func clear() {
        if self.layer.sublayers != nil {
            for subLayer in self.layer.sublayers! {
                subLayer.removeFromSuperlayer()
            }
        }
    }
    
    func draw(dataList: Array<CellObject>) {
        self.layer.masksToBounds = true
        self.clear()
        self.graphPoints.removeAll()
        self.graphTitles.removeAll()
        
        for obj in dataList{
            graphPoints.append(obj.positionValue!)
            graphTitles.append(obj.titlePos!)
        }
        
        self.maxValue = 0
        for graphPoint in self.graphPoints {
            self.maxValue = max(self.maxValue, graphPoint)
        }
        self.maxValue = max(100, self.maxValue)
        
        let step = 50
        if(self.maxValue % step != 0) {
            self.maxValue = Int(ceil(CGFloat(self.maxValue) / CGFloat(step))) * step
        }
        
        self.veKhungBieuDo()
        self.veMuiTen()
        self.veTitle()
        self.veTextCotGiaTri()
        
        if(self.graphPoints.count > 0){
            self.veTitleChoPoint()
            self.veDuongThangBieuDo()
            self.doMauNen()
            self.veDiemHinhTron()
            
        }
        

    }
    
    func veKhungBieuDo(){
        
        let topLeftPoint : CGPoint =  CGPoint(x: self.graphMargin.left, y: self.graphMargin.top)
        
        let khungBieuDoPath = UIBezierPath()
        
        khungBieuDoPath.moveToPoint(topLeftPoint)
        
        khungBieuDoPath.addLineToPoint(CGPoint(x: topLeftPoint.x ,
                                        y: self.frame.size.height  - graphMargin.bottom))
        
        khungBieuDoPath.addLineToPoint(CGPoint(x: self.frame.size.width - graphMargin.right ,
                                        y: self.frame.size.height - graphMargin.bottom))
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = khungBieuDoPath.CGPath
        self.layer.addSublayer(shapeLayer)

        
    }
    func veMuiTen(){
        let topLeftPoint : CGPoint =  CGPoint(x: self.graphMargin.left, y: self.graphMargin.top)
        let muiTenSize = CGSize(width: 7, height: 3)
        let muiTenPath = UIBezierPath()
        
        muiTenPath.moveToPoint(topLeftPoint)
        muiTenPath.addLineToPoint(CGPoint(x: topLeftPoint.x - muiTenSize.width / 2.0 , y: topLeftPoint.y + muiTenSize.height))
        muiTenPath.addLineToPoint(CGPoint(x: topLeftPoint.x + muiTenSize.width / 2.0 , y: topLeftPoint.y + muiTenSize.height))
        
        let shapeLayer = CAShapeLayer()
        
//        shapeLayer.fillColor = UIColor.redColor().CGColor
        shapeLayer.strokeColor = UIColor.clearColor().CGColor
        shapeLayer.path = muiTenPath.CGPath
        self.layer.addSublayer(shapeLayer)

    }
    
    func veTitle() {
        let font = UIFont.systemFontOfSize(11.0)
        let titleSize = self.measureTextSize(self.title, font: font)
        let titlePoint = CGPointMake(self.graphMargin.left - titleSize.width/2.0, self.graphMargin.top/2.0 - titleSize.height/2.0)
        
        self.veTextString(self.title, font: font, color: UIColor.blueColor(), frame: CGRectMake(titlePoint.x, titlePoint.y, titleSize.width, titleSize.height))
    }
    
    func veTextCotGiaTri() {
        let stringMarginRight: CGFloat = 5.0
        for i in 1...5 {
            let grapPoint = maxValue / 5 * i
            let pointString = "\(grapPoint)"
            let point = self.calculatePosition(frame, grahpValue: grapPoint, maxValue: self.maxValue, index: 0)
            
            let font = UIFont.systemFontOfSize(11.0)
            let stringSize = self.measureTextSize(pointString, font: font)
            let x = self.graphMargin.left - stringMarginRight - stringSize.width
            let y = point.y - stringSize.height/2.0
            
            self.veTextString(pointString, font: font, color: UIColor.blueColor(), frame: CGRectMake(x, y, stringSize.width, stringSize.height))
        }
    }

    func veTitleChoPoint() {
        let stringMarginTop: CGFloat = 5.0
        for i in 0..<self.graphPoints.count {
            let grapPoint = self.graphPoints[i]
            let pointTitle = self.graphTitles[i]
            let point = self.calculatePosition(frame, grahpValue: grapPoint, maxValue: self.maxValue, index: i)
            
            let font = UIFont.systemFontOfSize(12.0)
            let stringSize = self.measureTextSize(pointTitle, font: font)
            let x = point.x - stringSize.width/2.0
            let y = frame.height - self.graphMargin.bottom + stringMarginTop
            
            self.veTextString(pointTitle, font: font, color: UIColor.blueColor(), frame: CGRectMake(x, y, stringSize.width, stringSize.height))
        }
    }

    func veDuongThangBieuDo() {
        let graphPath = UIBezierPath()
        
        graphPath.moveToPoint(self.calculatePosition(frame, grahpValue: self.graphPoints[0], maxValue: maxValue, index: 0))
        
        // graph points
        for i in 1..<self.graphPoints.count {
            let grapPoint = self.graphPoints[i]
            let point = self.calculatePosition(frame, grahpValue: grapPoint, maxValue: maxValue, index: i)
            graphPath.addLineToPoint(point)
            
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = graphPath.CGPath
        self.layer.addSublayer(shapeLayer)
        
        // them hieu ung animation
        
        let drawAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration            = 5.0
        drawAnimation.repeatCount         = 1.0
        drawAnimation.fromValue = NSNumber(float: 0.5)
        drawAnimation.toValue   = NSNumber(float: 1)
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        shapeLayer.addAnimation(drawAnimation, forKey: "tenGiChaDuoc")
        
        
    }
    func veDiemHinhTron(){
        let circlePath = UIBezierPath()
        
        for i in 1..<self.graphPoints.count {
            let grapPoint = self.graphPoints[i]
            let point = self.calculatePosition(frame, grahpValue: grapPoint, maxValue: maxValue, index: i)
            circlePath.moveToPoint(point)
            circlePath.addArcWithCenter(point, radius: 2, startAngle: 0, endAngle:CGFloat( 2 * M_PI), clockwise: true)
            
        }
       
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.orangeColor().CGColor
        shapeLayer.strokeColor = UIColor.orangeColor().CGColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = circlePath.CGPath
        self.layer.addSublayer(shapeLayer)
        
    }
    func doMauNen() {
        let graphPath = UIBezierPath()
        graphPath.moveToPoint(
            CGPointMake(self.graphMargin.left + 0.5,
                        frame.height - self.graphMargin.bottom)
        )
        
        for i in 0..<self.graphPoints.count {
            let grapPoint = self.graphPoints[i]
            var point = self.calculatePosition(frame, grahpValue: grapPoint, maxValue: maxValue, index: i)
            if(i == 0) {
                point.x += 0.5
            }
            graphPath.addLineToPoint(point)
        }
        
        graphPath.addLineToPoint(CGPointMake(frame.width - self.graphMargin.right, frame.height -  self.graphMargin.bottom))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.lightGrayColor().CGColor
        shapeLayer.strokeColor = UIColor.clearColor().CGColor
        shapeLayer.path = graphPath.CGPath
        self.layer.addSublayer(shapeLayer)
        
        
        let drawAnimation: CABasicAnimation = CABasicAnimation(keyPath: "fillcolor")
        drawAnimation.duration            = 2.0
        drawAnimation.repeatCount         = 1
        drawAnimation.fillMode = kCAFillModeForwards
        drawAnimation.fromValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: 0, height: 0))
        drawAnimation.toValue   = NSValue(CGRect: CGRect(x: 0, y: 0, width: 120, height: 50))
        drawAnimation.autoreverses = true
        shapeLayer.addAnimation(drawAnimation, forKey: "tenGiChaDuoc2")
        
        

        
        
    }
    func measureTextSize(text: String, font: UIFont) -> CGSize {
        let attributes = [NSFontAttributeName : font]
        
        return text.boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
    func veTextString(aString: String, font: UIFont, color: UIColor, frame: CGRect) {
        let label = CATextLayer()
        label.font = font.fontName
        label.fontSize = font.pointSize
        label.foregroundColor = color.CGColor
        label.string = aString
        label.frame = frame
        label.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(label)
    }
    
    func calculatePosition(frame: CGRect, grahpValue: Int, maxValue: Int, index: Int) -> CGPoint {
        var point = CGPointMake(0, 0)
        
        let space: CGFloat = (frame.width - self.graphMargin.left - self.graphMargin.right) / CGFloat(max(0, self.graphPoints.count - 1))
        
        point.x = self.graphMargin.left + (CGFloat(index) * space)
        let y = (CGFloat(grahpValue) * (frame.height - self.graphMargin.top -  self.graphTopPadding - self.graphMargin.bottom)) / CGFloat(maxValue)
        point.y = frame.height - self.graphMargin.bottom - y
        
        return point
    }
    
    //MARK: 3D transition
    func translateView(){
        // tinh tien
        let tranformAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
        tranformAnimation.duration            = 2.0
        tranformAnimation.repeatCount         = 0
        tranformAnimation.removedOnCompletion = false
        tranformAnimation.fillMode = kCAFillModeForwards
        
        tranformAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeTranslation(80, 130, 3))
        
        self.layer.addAnimation(tranformAnimation, forKey: "transform")

    }
    func scaleVIew(){
        // co dan
        let tranformAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
        tranformAnimation.duration            = 2.0
        tranformAnimation.repeatCount         = 0
//        tranformAnimation.removedOnCompletion = false
//        tranformAnimation.fillMode = kCAFillModeForwards
        
        tranformAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(0.5, 2.5, 1))
        
        self.layer.addAnimation(tranformAnimation, forKey: "transform")
    }
    func rotateView(){
        // co dan
        
        let tranformAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
        tranformAnimation.duration            = 2.0
        tranformAnimation.repeatCount         = 0
        tranformAnimation.removedOnCompletion = false
        tranformAnimation.fillMode = kCAFillModeForwards
        
        tranformAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat( M_PI  ), 0, 0, 2))
        
        self.layer.addAnimation(tranformAnimation, forKey: "transform")
        
    }
}
