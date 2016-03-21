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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://hoangcuulong.com/alls.php"
        if Reachability.isConnectedToNetwork(url) {
            let urlRequest:NSURL = NSURL(string: url)!
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(urlRequest, completionHandler: { (data, response, error) -> Void in
                let result = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let total = result.count
                for i in 0..<(total/3 + 1) {
                    let position = i * 3
                    var item:[[String]] = []
                    if position < total {
                        let sub = result[position]
                        let id = sub["id"] as! String
                        let name = sub["name"] as! String
                        let album_id = sub["album_id"] as! String
                        let album_name = sub["album_name"] as! String
                        item.append([id,name,album_id,album_name])
                    }
                    
                    let position_2 = position + 1
                    if position_2 < total {
                        let sub = result[position_2]
                        let id = sub["id"] as! String
                        let name = sub["name"] as! String
                        let album_id = sub["album_id"] as! String
                        let album_name = sub["album_name"] as! String
                        item.append([id,name,album_id,album_name])
                    }
                    
                    let position_3 = position + 2
                    if position_3 < total {
                        let sub = result[position_3]
                        let id = sub["id"] as! String
                        let name = sub["name"] as! String
                        let album_id = sub["album_id"] as! String
                        let album_name = sub["album_name"] as! String
                        item.append([id,name,album_id,album_name])
                    }
                    
                    
                    self.items.append(item)
                    
                    
                }
                self.myTable.reloadData()
                
                
            })
            
            task.resume()
            
        }else{
            print("false")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension allsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sub = items[indexPath.row]
        let item1 = sub[0]
        let item2 = sub[1]
        let item3 = sub[2]
        let first = "http://hoangcuulong.com/cosplay/\(item1[1])"
        let second = "http://hoangcuulong.com/cosplay/\(item2[1])"
        let third = "http://hoangcuulong.com/cosplay/\(item3[1])"
        //        print(first)
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("even", forIndexPath: indexPath) as! evenTableViewCell
            
            let url1 = NSURL(string: first)
            let url2 = NSURL(string: second)
            let url3 = NSURL(string: third)
            let img1 = NSData(contentsOfURL: url1!)
            
            let img2 = NSData(contentsOfURL: url2!)
            let img3 = NSData(contentsOfURL: url3!)
            
            LazyImage.showForImageView(cell.firstImageView, url: first, defaultImage: "1.jpg", completion: { () -> Void in
                
            })
            LazyImage.showForImageView(cell.secondImageView, url: second, defaultImage: "1.jpg", completion: { () -> Void in
                
            })
            LazyImage.showForImageView(cell.thirdImageView, url: third, defaultImage: "1.jpg", completion: { () -> Void in
                
            })
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("odd", forIndexPath: indexPath) as! oddTableViewCell
            let url1 = NSURL(string: first)
            let url2 = NSURL(string: second)
            let url3 = NSURL(string: third)
            let img1 = NSData(contentsOfURL: url1!)
            let img2 = NSData(contentsOfURL: url2!)
            let img3 = NSData(contentsOfURL: url3!)
            LazyImage.showForImageView(cell.firstImageView, url: first, defaultImage: "1.jpg", completion: { () -> Void in
                
            })
            LazyImage.showForImageView(cell.secondImageView, url: second, defaultImage: "1.jpg", completion: { () -> Void in
                
            })
            LazyImage.showForImageView(cell.thirdImageView, url: third, defaultImage: "1.jpg", completion: { () -> Void in
                
            })
            return cell
        }
        
    }
}