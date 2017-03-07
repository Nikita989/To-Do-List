//
//  CustomView.swift
//  TO_DO_List
//
//  Created by Nikita H N on 28/02/17.
//  Copyright © 2017 Next. All rights reserved.
//

import UIKit

class CustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
        }
    */
    
    override func draw(_ rect: CGRect) {
        
        var aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x:0, y:0))
        aPath.addLine(to: CGPoint(x:0, y:200))
        aPath.addLine(to: CGPoint(x:200, y:0))
        aPath.addLine(to: CGPoint(x:0, y:0))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        
        //If you want to stroke it with a red color
        UIColor.gray.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
    }


}
