//
//  SearchVC.swift
//  SOYoutube
//
//  Created by Hitesh on 11/7/16.
//  Copyright © 2016 myCompany. All rights reserved.
//


import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var tblSearchVideos: UITableView!
    @IBOutlet weak var searchBarvideo: UISearchBar!
    
    var arrSearch = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var actionBack: UIButton!
    
    
    //MARK: - UITableViewDelegate
    
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell? {
//        let cell:VideoListCell = tableView.dequeueReusableCell(withIdentifier: "VideoListSearchCell", for: indexPath as IndexPath) as! VideoListCell
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
//        let videoDetails = arrSearch[indexPath.row]
//
////        cell.lblVideoName.text = videoDetails["videoTitle"] as? String
////        cell.lblSubTitle.text = videoDetails["videoSubTitle"] as? String
//
////        cell.imgVideoThumb.sd_setImageWithURL(NSURL(string: (videoDetails["imageUrl"] as? String)!))
//        return cell
//
//    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//
//    }
//
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//
//    }

    // MARK: - Searchbar Delegate -
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        tblSearchVideos.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        tblSearchVideos.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.arrSearch.removeAllObjects()
            self.tblSearchVideos.reloadData()
            return
        }else if searchText.characters.count > 1 {
            self.arrSearch.removeAllObjects()
            self.searchYouttubeVideoData(searchText: searchText)
        }else{
            self.arrSearch.removeAllObjects()
            self.tblSearchVideos.reloadData()
        }
    }
    
    //MARK: Search Videos
    func searchYouttubeVideoData(searchText:String) -> Void {
        SOYoutubeAPI().getVideoWithTextSearch(searchText: searchText, nextPageToken: "", completion: { (videosArray, succses, nextpageToken) in
            if(succses == true){
                self.arrSearch.addObjects(from: videosArray)
                if(self.arrSearch.count ==  0){
                    self.tblSearchVideos.isHidden = true
                }else{
                    self.tblSearchVideos.isHidden = false
                }
            }
            self.tblSearchVideos.reloadData()
        })
        
    }
    

    
    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VideoListCell = tableView.dequeueReusableCell(withIdentifier: "VideoListTopCell", for: indexPath as IndexPath) as! VideoListCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        cell.lblVideoName.text = arrVideos[indexPath.row].snippet.channelTitle
//        cell.lblSubTitle.text = arrVideos[indexPath.row].snippet.description
//
//        let url = URL(string: arrVideos[indexPath.row].thumbnail.url)
//        //        imageView.kf.setImage(with: url)
//        cell.imgVideoThumb.kf.setImage(with: url)
        
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
        //       self.id = arrVideos[indexPath.row].id
        performSegue(withIdentifier: "youtubeSegue", sender: self)
        //        self.navigationController?.pushViewController(dvc, animated: true)
        
        
        
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "youtubeSegue" {
//            let dvc = segue.destination as! YoutubePlayViewController
//            dvc.id = id
            
        }
    }
}
