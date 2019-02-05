//
//  TopVideoVC.swift
//  SOYoutube
//
//  Created by Hitesh on 11/7/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit
import Gloss
import Kingfisher
//import SDWebImage

class TopVideoVC: UIViewController {

    @IBOutlet weak var tblTopvideos: UITableView!
    var arrVideos = [youtube]()
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        // Do any additional setup after loading the view.
        self.getTopVideosFromYoutube(sender: self)
    }
    
    
    func getTopVideosFromYoutube(sender:AnyObject) {
        SOYoutubeAPI().getTopVideos(nextPageToken: "", showLoader : false) { (videosArray, succses, nextpageToken) in
            
            
            if succses == true {
//                print(videosArray)
                self.arrVideos = videosArray
                self.tblTopvideos.reloadData()
            }
        }
    }
    @IBOutlet weak var actionBack: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TopVideoVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VideoListCell = tableView.dequeueReusableCell(withIdentifier: "VideoListTopCell", for: indexPath as IndexPath) as! VideoListCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lblVideoName.text = arrVideos[indexPath.row].snippet.channelTitle
        cell.lblSubTitle.text = arrVideos[indexPath.row].snippet.description
        
        let url = URL(string: arrVideos[indexPath.row].thumbnail.url)
//        imageView.kf.setImage(with: url)
        cell.imgVideoThumb.kf.setImage(with: url)
  
        return cell
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrVideos.count
//    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell:VideoListCell = tableView.dequeueReusableCell(withIdentifier: "VideoListTopCell", for: indexPath as IndexPath) as! VideoListCell
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
//        //        let videoDetails = arrVideos[indexPath.row]
//
//        cell.lblVideoName.text = arrVideos[indexPath.row].snippet.channelTitle
//        cell.lblSubTitle.text = arrVideos[indexPath.row].snippet.description
//
//        let url = URL(string: arrVideos[indexPath.row].thumbnail.url)
//        //        imageView.kf.setImage(with: url)
//        cell.imgVideoThumb.kf.setImage(with: url)
//
//        //        imgVideoThumb.sd_setImageWithURL(NSURL(string: (videoDetails["imageUrl"] as? String)!))
//        return cell
//    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.id = arrVideos[indexPath.row].id
        performSegue(withIdentifier: "youtubeSegue", sender: self)
//        self.navigationController?.pushViewController(dvc, animated: true)
    
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "youtubeSegue" {
            let dvc = segue.destination as! YoutubePlayViewController
            dvc.id = id
            
        }
    }
}

struct snippet: JSONDecodable {
    
    let categoryId: String
    let channelId: String
    let channelTitle: String
    let description: String
    
  
    init?(json: JSON) {
        
        guard let categoryId: String = "categoryId" <~~ json,
            let channelId: String = "channelId" <~~ json,
            let channelTitle: String = "channelTitle" <~~ json,
            let description: String = "description" <~~ json else { return nil }
        
        self.categoryId = categoryId
        self.channelId = channelId
        self.channelTitle = channelTitle
        self.description = description
        
    }
    
    
    func toJSON() -> JSON? {
        
        return jsonify([
            
        "categoryId" ~~> self.categoryId,
        "channelId" ~~> self.channelId,
        "channelTitle" ~~> self.channelTitle,
        "description" ~~> self.description
            
        ])
    }
    
}


struct thumbnails: JSONDecodable {
    
    let url: String
    init?(json: JSON) {
        
        guard let url: String = "default.url" <~~ json else { return nil }
        self.url = url
    }
    
    func toJSON() -> JSON? {
        
        return jsonify([
            "default.url" ~~> self.url
            ])
    }
}

struct youtube: JSONDecodable {
    
    let id: String
    let kind: String
    let snippet: snippet
    let thumbnail: thumbnails

    init?(json: JSON) {
        
        guard let id: String = "id" <~~ json,
        let kind: String = "kind" <~~ json,
        let snippet: snippet = "snippet" <~~ json,
        let thumbnail: thumbnails = "snippet.thumbnails" <~~ json else { return nil }
        
        self.id = id
        self.kind = kind
        self.snippet = snippet
        self.thumbnail = thumbnail
        
    }
    
    func toJSON() -> JSON? {
        
        return jsonify([
            
        "id" ~~> self.id,
        "type" ~~> self.kind,
        "snippet" ~~> self.snippet,
        "thumbnails" ~~> self.thumbnail
            
        ])
    }
}


struct youtubeResponse: JSONDecodable {
    
    let items: [youtube]
    init?(json: JSON) {
        
        guard let items: [youtube] = "items" <~~ json else { return nil }
        self.items = items
    }
    
    func toJSON() -> JSON? {
        
        return jsonify([
            "items" ~~> self.items
            ])
    }
}
