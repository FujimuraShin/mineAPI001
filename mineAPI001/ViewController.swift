//
//  ViewController.swift
//  mineAPI001
//
//  Created by mf-osaka on 2021/05/12.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
   
        
   
    @IBOutlet weak var tableView: UITableView!
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
            cell.titleLabel.text = self.articles?[indexPath.item].title
            cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageUrl!)!)
     
            return cell
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
     
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.articles?.count ?? 0
        }
     
    
    
    var articles: [Article]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        //URLSession　設定
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=1125d5f179304a4abe798dc427faed07")!)
                
                let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    // Article.swift
                    self.articles = [Article]()
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                        if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                            for articleFromJson in articlesFromJson {
                                let article = Article()
                                if let title = articleFromJson["title"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String {
                                    
                                    article.title = title
                                    article.url = url
                                    article.imageUrl = urlToImage
                                }
                                self.articles?.append(article)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch let error {
                        print(error)
                    }
                    
                    
                }
                
                task.resume()
    }
    
    


}

extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

