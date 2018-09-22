//
//  ViewController.swift
//  FirestoreSample
//
//  Created by Togami Yuki on 2018/09/22.
//  Copyright © 2018 Togami Yuki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    
    var defaultStore : Firestore!
    
    var id:Int = 0
    var todoList:[String] = []
    var memoList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        defaultStore = Firestore.firestore()
        
        //データベースからデータを取り出す。
        defaultStore.collection("ToDoList").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.id += 1
                    self.todoList.append(document.data()["ToDo"] as! String)
                    self.memoList.append(document.data()["memo"] as! String)
                    print(self.todoList)
                }
                self.myTableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row]
        cell.detailTextLabel?.text = memoList[indexPath.row]
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
        self.id += 1
        defaultStore.collection("ToDoList").document("\(id)").setData([
            "ToDo": todoTextField.text,
            "memo": memoTextField.text
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        //アラートの設定
        let alert = UIAlertController(title: "データを追加しました。", message: nil, preferredStyle: .alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
            //OKを押した後の処理。
        }))
        //その他アラートオプション
        alert.view.layer.cornerRadius = 25 //角丸にする。
        present(alert,animated: true,completion: {()->Void in print("アラート表示")})//completionは動作完了時に発動。
    }
    
    //データベースからデータを取り出す
    @IBAction func getData(_ sender: UIButton) {
        defaultStore.collection("ToDoList").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                self.myTableView.reloadData()
            }
        }
        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

