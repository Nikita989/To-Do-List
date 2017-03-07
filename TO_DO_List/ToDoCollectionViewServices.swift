//
//  ToDoCollectionViewServices.swift
//  TO_DO_List
//
//  Created by Nikita H N on 23/02/17.
//  Copyright © 2017 Next. All rights reserved.
//

import UIKit

class ToDoCollectionViewServices: NSObject {
    
    var mToDoCollectionProtocolVar:toDoListControllerProtocol?
    
    init(pToDoCollectionProtocolObj:toDoListControllerProtocol) {
        
        mToDoCollectionProtocolVar = pToDoCollectionProtocolObj
        
    }
    
    func fetchToDoListData()
    {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "http://freejsonapis-showin.rhcloud.com/getNote?userid=ram@gmail.com")!
        let task = session.dataTask(with: url, completionHandler:
            {
                (data, response, error) in
                if error != nil
                {
                    print(error!.localizedDescription)
                }
                    
                else
                {
                    do
                    {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                        {
                            let toDoData = json
                            print(toDoData)
                            self.mToDoCollectionProtocolVar?.SendToDoDataToView(data: toDoData)
                        }
                    }
                    catch
                    {
                        print("error in JSONSerialization")
                        
                    }
                }
        })
        task.resume()
        
    }
    
    func postToDoListData(listArray:TODoModel)
    {
        
        let note = listArray.listData!
        let time = listArray.listTime
        let title = listArray.listTitle!
//        let userId = listArray.
        var request = URLRequest(url: URL(string: "http://freejsonapis-showin.rhcloud.com/storeData")!)
        request.httpMethod = "POST"
        let postString = "note=\(note)&time=1233212222&userid=ram@gmail.com&title=\(title)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
        }
        task.resume()
    }
}
