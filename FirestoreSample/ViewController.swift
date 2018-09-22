//
//  ViewController.swift
//  FirestoreSample
//
//  Created by Togami Yuki on 2018/09/22.
//  Copyright © 2018 Togami Yuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    
    var defaultStore : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        defaultStore = Firestore.firestore()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    //セルを横にスライドさせた時に呼ばれる
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //データの削除
        let deleteCell: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除"){ (action, index) -> Void in
            
            
        }
        let editCell: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "編集"){ (action, index) -> Void in
            
        
            
        }
        deleteCell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.6)
        editCell.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.6)
        return [deleteCell,editCell]
    }
    
    //データベースにデータを追加する
    @IBAction func addData(_ sender: UIButton) {
    }
    
    //データベースからデータを取り出す
    @IBAction func getData(_ sender: UIButton) {
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

