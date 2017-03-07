//
//  TODoModel.swift
//  TO_DO_List
//
//  Created by Nikita H N on 23/02/17.
//  Copyright © 2017 Next. All rights reserved.
//

import UIKit

class TODoModel: NSObject {
    
    var listData:String!
    var listTitle:String!
    var listTime:String!
    
    
    init(data:String,title:String,time:String)
    
    {
        self.listData = data
        self.listTitle = title
        self.listTime = time
        
    }

}
