//
//  toDoCollectionViewController.swift
//  TO_DO_List
//
//  Created by Nikita H N on 23/02/17.
//  Copyright © 2017 Next. All rights reserved.
//

import UIKit

class toDoCollectionViewController: NSObject,toDoListControllerProtocol {
    
    var fetchedData:[String:Any]?
    var count = 0
    var jsonArray:[Any] = []
    var toDoViewProtocolVar:toDoListViewProtocol?
    var toDoCollectionViewServicesVar:ToDoCollectionViewServices?
    
    init(pToDoViewProtocolObj:toDoListViewProtocol) {
        
        toDoViewProtocolVar = pToDoViewProtocolObj
    }
    
    func fetchtoDoDataFromServices()
    {
        if count == 0
        {
         toDoCollectionViewServicesVar = ToDoCollectionViewServices(pToDoCollectionProtocolObj: self)
            toDoCollectionViewServicesVar?.fetchToDoListData()
            
        }
    }
    
    func SendToDoDataToView(data:[String:Any])
    {
        fetchedData = data
        jsonArray = fetchedData?["list"] as! [Any]
        count = (jsonArray.count)
        print("controller count is&&&&&&&&&&&",count)
        toDoViewProtocolVar?.reloadData()
//        toDoViewProtocolVar?.storeLocally()
        
        
    }
    
    func sendUpdatedListToServices(listModel:TODoModel)
    {
        let array = listModel
        toDoCollectionViewServicesVar?.postToDoListData(listArray: array)
    }

}
