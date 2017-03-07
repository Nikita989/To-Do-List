//
//  ToDoViewController.swift
//  TO_DO_List
//
//  Created by Nikita H N on 23/02/17.
//  Copyright © 2017 Next. All rights reserved.
//

import UIKit
import SystemConfiguration

class ToDoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,toDoListViewProtocol,ToDoViewControllerReloadProtocol,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate
{
    
    @IBOutlet weak var mUserName: UILabel!
    @IBOutlet weak var mUserImage: UIImageView!
    @IBOutlet weak var mSideMenuView: UIView!
    @IBOutlet weak var mToDoCollectionView: UICollectionView!
    var mTapGesture:UITapGestureRecognizer?
    @IBOutlet weak var mUserMailId: UILabel!
    @IBOutlet weak var mMenuButton: UIBarButtonItem!
    
    var toDoData:[String:Any]!
    var path:String?
    var toDoListArray:[TODoModel] = []
    var toDoListLocalArray:[TODoModel] = []
    var hasData:Bool = false
    var alertView:UIView?
    var blurEffectView:UIVisualEffectView?
    var mTapGestureforAlertView:UITapGestureRecognizer?
    var titleView:UITextField?
    var mEnteredTitle:String!
    var mNewData:TODoModel?
    var mNewLocalData:TODoModel?
    var mDescription:String?
    var mCompleteToDoModel:TODoModel?
    var mCurrentTime:String?
    var mDate:String?
    var selectedIndex:Int = -1
    var didSelect:Bool = false
    var localData:Bool = false
    var connectedToNet:Bool = false
    var flag:Bool = false
    var prefetch:Bool = false
    var toDoFetchedArray:[TODoModel] = []
    var count:Int = 0
    var mSignedUserName:String?
    var mSignedMailId:String?
//    var mSelectedIndex:Int?
    var append:Bool = false
    var tappedButtonIndex:Int?
    var newData:Bool = false
    
    var toDoCollectionControllerVar:toDoCollectionViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        mToDoCollectionView.dataSource = self
        mToDoCollectionView.delegate = self
        mUserName.text = UserDefaults.standard.value(forKey: "userName") as! String?
        mUserMailId.text = UserDefaults.standard.value(forKey: "mailId") as! String?
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(deleteParticularCell(gesture:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        longPressGesture.delaysTouchesBegan = true
        self.mToDoCollectionView?.addGestureRecognizer(longPressGesture)
        connectedToNet = self.connectedToNetwork()
        print(connectedToNet)
        if connectedToNet == false
        {
            prefetch = true
            self.checkIfFileExists()
            self.fetchFromLocalDatabase()
        }
        mUserImage.layer.cornerRadius = 38
        mUserImage.clipsToBounds = true
        let mCurrentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        mDate = formatter.string(from: mCurrentDate)
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: mCurrentDate as Date)
        let strHour = String(hour)
        let minutes = calendar.component(.minute, from: mCurrentDate as Date)
        let strMinutes = String(minutes)
        mCurrentTime = strHour+"."+strMinutes
        self.navigationController?.navigationItem.titleView?.backgroundColor = UIColor.blue
        
        
        toDoCollectionControllerVar = toDoCollectionViewController(pToDoViewProtocolObj: self)
    }
    
    func deleteParticularCell(gesture:UILongPressGestureRecognizer)
    {
        if (gesture.state != UIGestureRecognizerState.ended)
        {
            return
        }
        
        let pressedCell = gesture.location(in: self.mToDoCollectionView)
        
        if let indexPath : NSIndexPath = (self.mToDoCollectionView?.indexPathForItem(at: pressedCell))! as NSIndexPath?
        {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertControllerStyle.alert)
            alert.view.layer.masksToBounds = false
            alert.view.layer.shadowRadius = 3.0
            alert.view.layer.shadowColor = UIColor.black.cgColor
            alert.view.layer.shadowOffset = CGSize(width: 3, height: 3)
            alert.view.layer.shadowOpacity = 1.0
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                { action in
                self.selectedIndex = indexPath.row
                self.deleteTheCellAtIndex(index: self.selectedIndex)
                    
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler:
                { action in
                    
                    
                    
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }

    func deleteTheCellAtIndex(index:Int)
    {
        
        toDoListLocalArray.remove(at: index)
        mToDoCollectionView.reloadData()
        self.localDatabaseManipulations(selectedIndex: index)
        
        
    }
    
//    @IBAction func descriptionAddBtnPressed(_ sender: Any)
//    {
//        
//        performSegue(withIdentifier: "descriptionSegue", sender: nil)
//    }
    
    func fetchFromLocalDatabase()
    {
    
        // reading contents of file
        localData = true
        var filedirec = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first!
        path = filedirec.appending("/dataList.json")
        
        let jsondata =  try! Data(contentsOf: URL.init(fileURLWithPath: path!), options: [])
        print(jsondata)
        let string1 = String.init(data: jsondata, encoding: .utf8)
        print(string1!)
        let str1 = try! JSONSerialization.jsonObject(with: jsondata, options: [])
        print(str1)
        
//        let list = str1 as! [String:Any]
        let list = str1 as! [Any]
        print(list)
        if prefetch
        {
            let valueatIndex = list
            print(valueatIndex)
            for i in 0..<valueatIndex.count{
                
                let toDoInfoLocalList = valueatIndex[i] as! [String:Any]
                print(toDoInfoLocalList)
                let toDoDescription = toDoInfoLocalList["data"] as! String
                let toDoTitle = toDoInfoLocalList["title"] as! String
                print(toDoTitle)
                let toDoTime = toDoInfoLocalList ["time"] as! String
                print(toDoTime)
                let userId = toDoInfoLocalList["userid"] as! String
                print(userId)
                self.mUserMailId.text = userId
                let todoInfoObj = TODoModel(data: toDoDescription, title: toDoTitle, time: toDoTime)
                print(todoInfoObj)
                self.toDoListLocalArray.append(todoInfoObj)
                print("------------------",self.toDoListLocalArray)
            }
            print("count is ****************",self.toDoListLocalArray.count)
        }
        else
        {
            let valueInList = list
            print(valueInList)
            toDoFetchedArray = []
            for i in 0..<valueInList.count{
                
                let toDoInfoLocalList = valueInList[i] as! [String:Any]
                print(toDoInfoLocalList)
                let toDoDescription = toDoInfoLocalList["data"] as! String
                let toDoTitle = toDoInfoLocalList["title"] as! String
                print(toDoTitle)
                let toDoTime = toDoInfoLocalList ["time"] as! String
                print(toDoTime)
                let userId = toDoInfoLocalList["userid"] as! String
                print(userId)
                self.mUserMailId.text = userId
                let todoInfoObj = TODoModel(data: toDoDescription, title: toDoTitle, time: toDoTime)
                print(todoInfoObj)
                self.toDoFetchedArray.append(todoInfoObj)
                print("------------------",self.toDoFetchedArray)
            }
            print("count is ****************",self.toDoFetchedArray.count)
            
            
        }
        if flag == false
        {
            self.mToDoCollectionView.reloadData()
            
        }
       
    }
    
    // checking for internet connectivity
    func connectedToNetwork() -> Bool
    {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress,
                {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1)
                {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
        })
            else
            
        {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    func checkIfFileExists()
    {
        var created:Bool
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)
        let jsonFilePath = documentsDirectoryPath?.appendingPathComponent("dataList.json")?.path
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
       let filePresent = fileManager.fileExists(atPath: (jsonFilePath)!, isDirectory: &isDirectory)

        
        if !filePresent
        {
            let array = [Any]()
            let jsonData =  try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)

            
         created = fileManager.createFile(atPath: jsonFilePath!, contents: jsonData, attributes: nil)
        if created
        {
            print("File created ")
        }
            
        }
        
    

    }
    func storeLocally(dictionaryArray:[Any])
    {
        
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)
        let jsonFilePath = documentsDirectoryPath?.appendingPathComponent("dataList.json")?.path
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        let created = fileManager.createFile(atPath: jsonFilePath!, contents: nil, attributes: nil)
            
            
            if created
            {
                print("File created ")
//                let content = self.toDoCollectionControllerVar?.dic
                do
                {
                    // converting json object to data
                    let data = try JSONSerialization.data(withJSONObject: dictionaryArray, options:.prettyPrinted)
                    
                    // converting data to string to print
                    let string1 = String.init(data: data, encoding: .utf8)
                    print(string1!)
                    
                    // writing to the file in the form of data
                    let file = try FileHandle(forWritingAtPath: jsonFilePath!)
                    file?.write(data)
                    print("JSON data was written to the file successfully!")
                    
                }
                catch
                {
                    print("error")
                    
                }
            }
            else
            {
                print("Couldn't create file for some reason")
            }
        }
    
    
    
    @IBAction func menuButtonPressed(_ sender: Any)
    {
        count = count + 1
        print(count)
        if ((count % 2 ) == 0)
        {
            // to hide side menu
            mSideMenuView.isHidden = true
        }
        
        else
        {
           
            // to show side menu
            mSideMenuView.isHidden = false
            self.addGestureRecogniser()

            
        }
        
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
//        blurEffectView?.alpha = 0.5
        view.addSubview(blurEffectView!)
        
        alertView =  UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        alertView?.center = self.view.center
        alertView?.backgroundColor = UIColor(hexString: "#267E85")
        
        alertView?.layer.borderColor = UIColor(hexString: "#6EBBC1").cgColor
        alertView?.layer.borderWidth = 1
        alertView?.layer.shadowColor = UIColor.black.cgColor
        alertView?.layer.shadowRadius = 5
        alertView?.layer.shadowOpacity = 0.4
        alertView?.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        alertView?.layer.cornerRadius = 7
        alertView?.layer.masksToBounds = false
        
        
        self.view.addSubview(alertView!)
        
        let titleLabel = UILabel(frame: CGRect(x: ((alertView?.frame.width)!/2)-35 , y: 25, width: 100, height: 20))
        titleLabel.text = "Add Title"
        titleLabel.textColor = UIColor(hexString: "#072D30")
        titleLabel.font = UIFont(name: "AppleGothic", size: 20)
        alertView?.addSubview(titleLabel)
        
        titleView = UITextField(frame: CGRect(x: 55, y: 70, width: 150, height: 50))
        titleView?.backgroundColor = UIColor(hexString: "#063235")
        //        titleView?.layer.borderColor = UIColor.gray.cgColor
        //        titleView?.placeholder = "Title"
        let placeHolder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName:UIColor.gray])
        
        titleView?.attributedPlaceholder = placeHolder
        //        titleView?.layer.borderWidth = 1
        titleView?.textColor = UIColor.white
        titleView?.font = UIFont(name: "AppleGothic", size: 15)
        titleView?.isUserInteractionEnabled = true
        titleView?.layer.shadowRadius = 4
        titleView?.layer.shadowOpacity = 0.4
        titleView?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        titleView?.layer.cornerRadius = 5
        titleView?.layer.masksToBounds = false
        titleView?.layer.shadowColor = UIColor.gray.cgColor
        alertView?.addSubview(titleView!)
        
        let okButton = UIButton(frame: CGRect(x: 85, y: 150, width: 80, height: 20))
        //        okButton.backgroundColor = UIColor(hexString: "#063235")
        
        okButton.titleLabel?.font = UIFont(name: "AppleGothic-Bold", size: 20)
        okButton.setTitle("OK", for: UIControlState.normal)
        okButton.setTitleColor(UIColor(hexString: "#072D30"), for: UIControlState.normal)
        alertView?.addSubview(okButton)
        
        
        okButton.addTarget(self, action: #selector(self.titleOkButtonPresed(sender:)), for: .touchUpInside)
        self.addGestureRecogniserToBlurView()
//        mView.isHidden = false
    }
    
    func addGestureRecogniserToBlurView()
    {
        
        mTapGestureforAlertView = UITapGestureRecognizer(target: self, action: #selector(self.hideAlertView(sender:)))
        self.blurEffectView?.addGestureRecognizer(mTapGestureforAlertView!)
        
        
    }
    
    func hideAlertView(sender:UITapGestureRecognizer)
    {
        self.alertView?.isHidden = true
        self.blurEffectView?.isHidden = true
//        mView.isHidden = true
        
    }
    
    func titleOkButtonPresed(sender:UIButton)
    {
        mEnteredTitle = titleView?.text
        print("****************",mEnteredTitle)
        alertView?.isHidden = true
        blurEffectView?.isHidden = true
        if connectedToNet == false
        {
            print(toDoListLocalArray)
            mNewLocalData = TODoModel(data: "", title: mEnteredTitle, time: "")
            self.toDoListLocalArray.insert(mNewLocalData!, at: 0)
            print(toDoListLocalArray)
            
            
        }
            
        else
        {
            newData = true
            mNewData = TODoModel(data: "", title: mEnteredTitle!, time: "")
            self.toDoListArray.insert(mNewData!, at: 0)
            
            
        }
        //        let mCurrentDate = Date()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "dd.MM.yyyy"
        //        let mDate = formatter.string(from: mCurrentDate)
        //        let calendar = NSCalendar.current
        //        let hour = calendar.component(.hour, from: mCurrentDate as Date)
        //        let strHour = String(hour)
        //        let minutes = calendar.component(.minute, from: mCurrentDate as Date)
        //        let strMinutes = String(minutes)
        //        let mTime = strHour+"."+strMinutes
        
        mToDoCollectionView.reloadData()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let descriptionView = segue.destination as! ToDoDescriptionViewController
        let presentTitle = toDoListLocalArray[tappedButtonIndex!].listTitle!
        print(presentTitle)
        let presentDescription = toDoListLocalArray[tappedButtonIndex!].listData!
        print(presentDescription)
        descriptionView.createConstructor(object: self,internetCheckValue: connectedToNet)
        if connectedToNet {
            descriptionView.mNewToDoModel = mNewData
            descriptionView.mToDoTitle = mEnteredTitle
        }
        else
        {
            if newData
            {
                descriptionView.mNewLocalToDoModel = mNewLocalData
                descriptionView.mToDoTitle = mEnteredTitle
            }
            else
            {
                print(tappedButtonIndex)
                print(toDoListLocalArray.count)
                
                descriptionView.mNewLocalToDoModel = toDoListLocalArray[tappedButtonIndex!]
                descriptionView.mEnteredDescription = presentDescription
                descriptionView.mToDoTitle = presentTitle

            }
            
        }
        

    }
    
    func reloadAfterEnteringDescription()
    {
        
        mToDoCollectionView.reloadData()
        toDoCollectionControllerVar?.sendUpdatedListToServices(listModel: mNewData!)
//        self.storeLocally()
        
    }
    
    func reloadAfterEnteringDescriptionWhenNoNet()
    {
        DispatchQueue.main.async
        {
            self.mToDoCollectionView.reloadData()

        }
        append = true
        if newData
        {
        self.localDatabaseManipulations(selectedIndex: 0)
        }
        
        else
        {
            print(tappedButtonIndex)
            self.localDatabaseManipulations(selectedIndex: tappedButtonIndex!)

        }
        
    }
    
    
    func localDatabaseManipulations(selectedIndex:Int)
    {
        flag = true
        prefetch = false
        self.fetchFromLocalDatabase()
        if append
        {
            if newData
            {
            toDoFetchedArray.insert(mNewLocalData!, at: 0)
            }
            else
            {
                toDoFetchedArray = toDoListLocalArray
                print(selectedIndex)
//                print(mNewLocalData)
//                toDoFetchedArray[selectedIndex] = mNewLocalData!
//            toDoFetchedArray.insert(mNewLocalData!, at: selectedIndex)
                
            }

        }
        else
        {
            toDoFetchedArray.remove(at: selectedIndex)
            
        }
        var dictArray:[Any] = []
        for i in 0..<toDoFetchedArray.count
        {
            
            let dictionary = [
                "data":toDoFetchedArray[i].listData!,
                "time":toDoFetchedArray[i].listTime!,
                "title":toDoFetchedArray[i].listTitle!,
                "userid":"ram@gmail.com"
            ]
            
            dictArray.append(dictionary)
            
        }
        
//        let dictionaryObj = ["list":dictArray]
//        print(dictionaryObj)
        print("dictArray************",dictArray)
    
        self.storeLocally(dictionaryArray: dictArray)
//        let jsonData = try! JSONSerialization.data(withJSONObject: dictArray, options: .prettyPrinted)
//        print("jsondata",String.init(data: jsonData, encoding: .utf8)!)
//        
//        let file = try FileHandle(forWritingAtPath: path!)
//        file?.write(jsonData)
    }
    
    
    
    func addGestureRecogniser()
    {
        mTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideSideMenu(sender:)))
        self.mToDoCollectionView.addGestureRecognizer(mTapGesture!)
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: Any)
    {
        GIDSignIn.sharedInstance().signOut()
        let view = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any)
    {
        self.mSideMenuView.isHidden = true
    }
    
    // ACTION TO BE PERFORMED ON TAP
    func hideSideMenu(sender:UITapGestureRecognizer)
    {
        self.mSideMenuView.isHidden = true
        mToDoCollectionView.removeGestureRecognizer(sender)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if localData
        {
            
            return (toDoListLocalArray.count)
        }
            
        else
        {
            if hasData == false {
                toDoCollectionControllerVar?.fetchtoDoDataFromServices()
                hasData = true
            }
            print(toDoCollectionControllerVar?.count)
            return (toDoCollectionControllerVar?.count)!
            
        }
        
    }
    
    func reloadData()
    {
        DispatchQueue.main.async
            {
                self.hasData = true
                self.toDoData = self.toDoCollectionControllerVar?.fetchedData
                let valueatIndex = self.toDoData["list"] as! [Any]
                for i in 0..<valueatIndex.count{
                    
                    let toDoInfoList = valueatIndex[i] as! [String: Any]
                    let toDoDescription = toDoInfoList["data"] as! String
                    let toDoTitle = toDoInfoList["title"] as! String
                    let toDoTime = toDoInfoList ["time"] as! String
                    let userId = toDoInfoList["userid"] as! String
                    self.mUserMailId.text = userId
                    let infoObj = TODoModel(data: toDoDescription, title: toDoTitle, time: toDoTime)
                    self.toDoListArray.append(infoObj)
                    print("------------------",self.toDoListArray)
                }
                print("count is ****************",self.toDoListArray.count)
                self.mToDoCollectionView.reloadData()
//                self.storeLocally()
                
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toDoCell", for: indexPath) as! ToDoCollectionViewCell
        
        cell.layer.backgroundColor = UIColor(hexString: "#0C555B").cgColor
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.mDescriptionAddButton.tag = indexPath.row
        //let gesture = UITapGestureRecognizer.init(target: self, action: #selector())
        cell.mDescriptionAddButton.addTarget(self, action: #selector(self.buttonPress(button:)), for: .touchUpInside)
       
        if localData {
            
            cell.mTimeLabel.text = mCurrentTime
            cell.mDateLabel.text = mDate
            cell.mTitleLabel.text = toDoListLocalArray[indexPath.row].listTitle
            cell.mDescriptionLabel.text = toDoListLocalArray[indexPath.row].listData
            
        }
            
        else
        {
            
            cell.mTimeLabel.text = mCurrentTime
            cell.mDateLabel.text = mDate
            cell.mTitleLabel.text = toDoListArray[indexPath.row].listTitle
            cell.mDescriptionLabel.text = toDoListArray[indexPath.row].listData
            
        }
        
        return cell
        
    }
    
    @objc private func buttonPress(button:UIButton)
    {
        tappedButtonIndex = (button.tag)
        print("pressed button is",tappedButtonIndex)
        performSegue(withIdentifier: "descriptionSegue", sender: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if(selectedIndex == indexPath.row)
        {
            return CGSize(width: collectionView.frame.size.width - 10, height: 150)
        }
            
        else
        {
            return CGSize(width: collectionView.frame.size.width - 15, height: 70)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect = false
        if(selectedIndex == indexPath.row)
        {
            didSelect = true
            selectedIndex = -1
            mToDoCollectionView.reloadItems(at: [indexPath])
        }
        
        if(selectedIndex != -1)
        {
            didSelect = false
            let prevPath = IndexPath.init(row: selectedIndex, section: 0)
            selectedIndex = indexPath.row
            mToDoCollectionView.reloadItems(at: [prevPath])
        }
        
        if didSelect == false {
            selectedIndex = indexPath.row
            mToDoCollectionView.reloadItems(at: [indexPath])
        }
        
    }
    
}




extension UIColor
{
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}




