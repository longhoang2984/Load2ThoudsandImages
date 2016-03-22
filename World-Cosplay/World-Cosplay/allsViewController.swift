//
//  allsViewController.swift
//  World-Cosplay
//
//  Created by Long Hoang on 3/21/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class allsViewController: UIViewController {
    
    @IBOutlet weak var myTable:UITableView!
    var items:[[[String]]] = []
    var photoRecords = [[PhotoRecord]]()
    let pendingOperations = PendingOperations()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://hoangcuulong.com/alls.php"
        if Reachability.isConnectedToNetwork(url) {
            fetchPhotoDetails(NSURL(string: url)!)
        }else{
            print("false")
        }
        
    }
    
    func fetchPhotoDetails(dataSourceURL: NSURL) {
        let request = NSURLRequest(URL:dataSourceURL)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {response,data,error in
            if data != nil {
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithURL(dataSourceURL, completionHandler: { (data, response, error) -> Void in
                    let result = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                    let total = result.count
                    for i in 0..<(total/3 + 1) {
                        let position = i * 3
                        var item:[[String]] = []
                        var photos = [PhotoRecord]()
                        
                        if position < total {
                            var subPhoto = [PhotoRecord]()
                            let sub = result[position]
                            let id = sub["id"] as! String
                            let name = sub["name"] as! String
                            let album_id = sub["album_id"] as! String
                            let album_name = sub["album_name"] as! String
                            item.append([id,name,album_id,album_name])
                            let urlImg = NSURL(string: "http://hoangcuulong.com/cosplay/\(name)")
                            let phoRe = PhotoRecord(name: album_name, url: urlImg!)
                            subPhoto.append(phoRe)
                            photos.append(phoRe)
                        }
                        
                        let position_2 = position + 1
                        if position_2 < total {
                            var subPhoto = [PhotoRecord]()
                            let sub = result[position_2]
                            let id = sub["id"] as! String
                            let name = sub["name"] as! String
                            let album_id = sub["album_id"] as! String
                            let album_name = sub["album_name"] as! String
                            item.append([id,name,album_id,album_name])
                            let urlImg = NSURL(string: "http://hoangcuulong.com/cosplay/\(name)")
                            let phoRe = PhotoRecord(name: album_name, url: urlImg!)
                            subPhoto.append(phoRe)
                            photos.append(phoRe)
                        }
                        
                        let position_3 = position + 2
                        if position_3 < total {
                            var subPhoto = [PhotoRecord]()
                            let sub = result[position_3]
                            let id = sub["id"] as! String
                            let name = sub["name"] as! String
                            let album_id = sub["album_id"] as! String
                            let album_name = sub["album_name"] as! String
                            item.append([id,name,album_id,album_name])
                            let urlImg = NSURL(string: "http://hoangcuulong.com/cosplay/\(name)")
                            let phoRe = PhotoRecord(name: album_name, url: urlImg!)
                            subPhoto.append(phoRe)
                            photos.append(phoRe)
                        }
                        
                        
                        let queueSerial:dispatch_queue_t = dispatch_queue_create("Serial", DISPATCH_QUEUE_SERIAL)
                        dispatch_async(queueSerial, {
                            self.photoRecords.append(photos)
                            self.items.append(item)
                            self.myTable.reloadData()
                        })
                        
                        
                        
                    }
                    
                    print(self.photoRecords)
                    
                })
                
                task.resume()
                
                print(data)
                print(response)
            }
            
            if error != nil {
                let alert = UIAlertView(title:"Oops!",message:error!.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        let alert = UIAlertView(title:"Oops!",message: "Memory Fullfill", delegate:nil, cancelButtonTitle:"OK")
        alert.show()
    }
    
    
}

extension allsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoRecords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sub = photoRecords[indexPath.row]
        var item1:PhotoRecord?
        var item2:PhotoRecord?
        var item3:PhotoRecord?
        if sub.count == 1 {
            item1 = sub[0]
        }else if sub.count == 2 {
            item1 = sub[0]
            item2 = sub[1]
        }else if sub.count == 3 {
            item1 = sub[0]
            item2 = sub[1]
            item3 = sub[2]
        }
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("even", forIndexPath: indexPath) as! evenTableViewCell
            
            if item1 != nil {
                cell.firstImageView.image = item1!.image
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                cell.firstImageView.addSubview(indicator)
                switch (item1!.state){
                case .Filtered:
                    indicator.stopAnimating()
                case .Failed:
                    indicator.stopAnimating()
                    cell.textLabel?.text = "Failed to load"
                case .New, .Downloaded:
                    indicator.startAnimating()
                    self.startOperationsForPhotoRecord(item1!,indexPath:indexPath)
                }
            }
            
            if item2 != nil {
                cell.secondImageView.image = item2!.image
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                cell.secondImageView.addSubview(indicator)
                switch (item2!.state){
                case .Filtered:
                    indicator.stopAnimating()
                case .Failed:
                    indicator.stopAnimating()
                    cell.textLabel?.text = "Failed to load"
                case .New, .Downloaded:
                    indicator.startAnimating()
                    self.startOperationsForPhotoRecord(item2!,indexPath:indexPath)
                }
            }
            
            if item3 != nil {
                cell.thirdImageView.image = item3!.image
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                cell.thirdImageView.addSubview(indicator)
                switch (item3!.state){
                case .Filtered:
                    indicator.stopAnimating()
                case .Failed:
                    indicator.stopAnimating()
                    cell.textLabel?.text = "Failed to load"
                case .New, .Downloaded:
                    indicator.startAnimating()
                    self.startOperationsForPhotoRecord(item3!,indexPath:indexPath)
                }
            }
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("odd", forIndexPath: indexPath) as! oddTableViewCell
            
            if item1 != nil {
                cell.firstImageView.image = item1!.image
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                cell.firstImageView.addSubview(indicator)
                switch (item1!.state){
                case .Filtered:
                    indicator.stopAnimating()
                case .Failed:
                    indicator.stopAnimating()
                    cell.textLabel?.text = "Failed to load"
                case .New, .Downloaded:
                    indicator.startAnimating()
                    self.startOperationsForPhotoRecord(item1!,indexPath:indexPath)
                }
            }
            
            if item2 != nil {
                cell.secondImageView.image = item2!.image
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                cell.secondImageView.addSubview(indicator)
                switch (item2!.state){
                case .Filtered:
                    indicator.stopAnimating()
                case .Failed:
                    indicator.stopAnimating()
                    cell.textLabel?.text = "Failed to load"
                case .New, .Downloaded:
                    indicator.startAnimating()
                    self.startOperationsForPhotoRecord(item2!,indexPath:indexPath)
                }
            }
            
            if item3 != nil {
                cell.thirdImageView.image = item3!.image
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                cell.thirdImageView.addSubview(indicator)
                switch (item3!.state){
                case .Filtered:
                    indicator.stopAnimating()
                case .Failed:
                    indicator.stopAnimating()
                    cell.textLabel?.text = "Failed to load"
                case .New, .Downloaded:
                    indicator.startAnimating()
                    self.startOperationsForPhotoRecord(item3!,indexPath:indexPath)
                }
            }
            return cell
        }
        
        
    }
    
    func startOperationsForPhotoRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        switch (photoDetails.state) {
        case .New:
            startDownloadForRecord(photoDetails, indexPath: indexPath)
        case .Downloaded:
            startFiltrationForRecord(photoDetails, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    func startDownloadForRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        //1
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        //2
        let downloader = ImageDownloader(photoRecord: photoDetails)
        //3
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            let queueSerial:dispatch_queue_t = dispatch_queue_create("Serial", DISPATCH_QUEUE_SERIAL)
            dispatch_async(queueSerial, {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.myTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        //4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startFiltrationForRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        if let filterOperation = pendingOperations.filtrationsInProgress[indexPath]{
            return
        }
        
        let filterer = ImageFiltration(photoRecord: photoDetails)
        filterer.completionBlock = {
            if filterer.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.filtrationsInProgress.removeValueForKey(indexPath)
                self.myTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        pendingOperations.filtrationsInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }
}