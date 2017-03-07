//
//  toDoListProtocol.swift
//  TO_DO_List
//
//  Created by Nikita H N on 23/02/17.
//  Copyright © 2017 Next. All rights reserved.
//

import Foundation

protocol toDoListControllerProtocol {
    
     func SendToDoDataToView(data:[String:Any])
     
}


protocol toDoListViewProtocol {
    
    func reloadData()
//    func storeLocally()


}

protocol ToDoViewControllerReloadProtocol {
    
    func reloadAfterEnteringDescription()
    func reloadAfterEnteringDescriptionWhenNoNet()



}
