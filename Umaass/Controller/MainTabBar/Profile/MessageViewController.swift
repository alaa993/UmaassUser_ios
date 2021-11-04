import UIKit
import Alamofire

class MessageViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var model = [DataNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    
   
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func getData()  {
        
        loading()
        
        ServiceAPI.shared.fetchGenericData(urlString: baseUrl+"notifications",parameters: [:], methodInput: .get, isHeaders: true) {(model:ModelNotificationMessage?, error:Error?,status:Int?) in
            
            self.dismissLoding()
            self.model = model?.data?.filter{$0.app == "Customer"} ?? []
            self.collectionView.reloadData()
            self.readMessage()
            
        }
        
    }
    
    func readMessage()  {
        
        ServiceAPI.shared.fetchGenericData(urlString:baseUrl+"notifications",parameters: [:], methodInput: .patch, isHeaders: true) {(model:MessageModel?, error:Error?,status:Int?) in
            
            UserDefaults.standard.setMessageCount(value: 0)
           
            
        }
        
    }
  
}
extension MessageViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.model = model[indexPath.item]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dec = model[indexPath.item].message
        let height = heightFor(with: collectionView.frame.width, description: dec)
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    
       func heightFor(with availableWidth: CGFloat, description: String?) -> CGFloat {
           guard let text = description, !text.isEmpty else {
               return 100
           }
           
           let attributedString = NSMutableAttributedString(
               string: text,
               attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
           )
           
           let labelWidth = availableWidth
           let height = attributedString.heightForView(withWidth: labelWidth)
           return 100 + (height ?? -1) + 1+5
       }

}

extension NSAttributedString {
    func heightForView(withWidth width: CGFloat) -> CGFloat? {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let rect = self.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        return rect.height
    }
}
