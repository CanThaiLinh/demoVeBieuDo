//
//  CellObject.swift
//  VeBanDo
//
//  Created by thailinh on 8/8/16.
//  Copyright © 2016 thailinh. All rights reserved.
//

import UIKit

class CellObject: NSObject {
    var positionValue           : Int?
    var titlePos                : String?
    
    init(value :Int, title :String){
        self.positionValue = value
        self.titlePos = title
    }

    
}
