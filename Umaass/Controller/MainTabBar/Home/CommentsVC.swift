//
//  CommentsVC.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit



class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var commentsTableView    : UITableView!
    @IBOutlet weak var noItemLabel          : UILabel!

    
    
    
    var commentsList         = [commentsData]()
    var moreCommentsList     = [commentsData]()
    var passedProviderId     = Int()
    
    var starArr : [Int:String] = [1:"★", 2:"★★", 3:"★★★", 4:"★★★★", 5:"★★★★★"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelLanguageData(label: noItemLabel, key: "No item")
        setMessageLanguageData(&commentsPageTitle, key: "comments")
        self.navigationItem.title = commentsPageTitle
        
//        let button = UIButton.init(type: .custom)
//        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 50)
//        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//        cornerButton(button: button, cornerValue: 4.0, maskToBounds: true)
//        button.setImage(UIImage.init(named: ""), for: UIControl.State.normal)
//        let logoImg = UIBarButtonItem.init(customView: button)
//        self.navigationItem.rightBarButtonItem = logoImg



        commentsTableView.estimatedRowHeight = 100.0
        commentsTableView.rowHeight = UITableView.automaticDimension
        
        getAllComments()
        commentsTableView.isHidden = true
        noItemLabel.isHidden = true
    }
    
    
    
    func getAllComments(){
        loading()
        let commentsUrl = baseCustomerUrl + "providers/" + "\(passedProviderId)" + "/comments"
        print(commentsUrl)
        ServiceAPI.shared.fetchGenericData(urlString: commentsUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: commentsModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            print(status)
            if status == 200 {
                self.commentsList = model?.data ?? []
                print(self.commentsList)

                if self.commentsList.count > 0 {
                    self.commentsTableView.isHidden = false
                    self.noItemLabel.isHidden = true
                    self.commentsTableView.reloadData()
                }else{
                    self.commentsTableView.isHidden = true
                    self.noItemLabel.isHidden = false
                }

            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }


    var i : Int = 2
    func loadMoreComments(){
        loading()
        let commentsUrl = baseCustomerUrl + "providers/" + "\(passedProviderId)" + "/comments?page=" + "\(i)"
        print(commentsUrl)
        ServiceAPI.shared.fetchGenericData(urlString: commentsUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: commentsModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            //            print(status)
            if status == 200 {
                self.moreCommentsList = model?.data ?? []
                print(self.moreCommentsList)

                if self.moreCommentsList.count > 0 {
                    for j in 0..<self.moreCommentsList.count {
                        self.commentsList.append(self.moreCommentsList[j])

                    }
                    self.i = self.i + 1
                    self.commentsTableView.reloadData()
                }
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
// ****************************** Comments *******************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentsCell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableCell", for: indexPath) as! CommentsTableViewCell
        
        commentsCell.userNameLabel.text = self.commentsList[indexPath.row].name ?? ""
        commentsCell.commentLabel.text = self.commentsList[indexPath.row].content ?? ""


        let imageUrl = self.commentsList[indexPath.row].avatar?.url_sm ?? ""
        let url = NSURL(string: imageUrl)
        if url != nil {
            commentsCell.userImage.af_setImage(withURL: url! as URL, placeholderImage: UIImage(named: "user.png"), filter: nil, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
        }


        let rateNum = self.commentsList[indexPath.row].rate ?? 1
        print(rateNum)
        commentsCell.starRateView.rating = Double(rateNum)


        commentsCell.layer.masksToBounds = false
        commentsCell.layer.cornerRadius = 10.0
        commentsCell.layer.shadowOpacity = 1.0
        commentsCell.layer.shadowRadius = 2.0
        commentsCell.layer.shadowOffset = CGSize(width: 0, height: 0.8)
        commentsCell.layer.shadowColor = UIColor(red: 160/255 , green: 160/255, blue: 160/255, alpha: 1.0).cgColor

        if indexPath.row == self.commentsList.count - 1{
            self.loadMoreComments()
        }
        
        return commentsCell
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    
    
    
    func displayAlertMsg(userMsg: String){
        setMessageLanguageData(&msgAlert, key: "Warrning")
        setMessageLanguageData(&msgOk, key: "Ok")
        
        let myAlert = UIAlertController(title: msgAlert ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: msgOk,style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
}

