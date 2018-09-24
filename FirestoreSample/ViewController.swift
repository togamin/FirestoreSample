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
    
    var todoList:[String] = []
    var memoList:[String] = []
    var idList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        defaultStore = Firestore.firestore()
        
        //仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action:#selector(self.closeKeybord(_:)))
        kbToolBar.items = [spacer, commitButton]
        todoTextField.inputAccessoryView = kbToolBar
        memoTextField.inputAccessoryView = kbToolBar
    }
    @objc func closeKeybord(_ sender:Any){
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idList.count
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
            
            self.defaultStore.collection("ToDoList").document(self.idList[indexPath.row]).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
        let editCell: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "編集"){ (action, index) -> Void in
            
            //アラートの設定
            let alert = UIAlertController(title: "データを編集します", message: nil, preferredStyle: .alert)
            //OKボタン
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
                //OKを押した後の処理。
                self.defaultStore.collection("ToDoList").document(self.idList[indexPath.row]).setData([
                    "ToDo": alert.textFields![0].text!,
                    "memo": alert.textFields![1].text!
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                
            }))
            //キャンセルボタン
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: {(action:UIAlertAction!) -> Void in
                //キャンセルを押した後の処理。
            }))
            // テキストフィールドを追加。取り出し方は右「alert.textFields![0].text!」
            alert.addTextField(configurationHandler: {(addTitleField: UITextField!) -> Void in
                addTitleField.text = self.todoList[indexPath.row]
                addTitleField.placeholder = "タイトルを入力してください。"//プレースホルダー
            })
            // テキストフィールドを追加。取り出し方は右「alert.textFields![1].text!」
            alert.addTextField(configurationHandler: {(addTitleField: UITextField!) -> Void in
                addTitleField.text = self.memoList[indexPath.row]
                addTitleField.placeholder = "タイトルを入力してください。"//プレースホルダー
            })
            //その他アラートオプション
            alert.view.layer.cornerRadius = 25 //角丸にする。
            self.present(alert,animated: true,completion: {()->Void in print("アラート表示")})//completionは動作完了時に発動。
            
        }
        deleteCell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.8)
        editCell.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.8)
        return [deleteCell,editCell]
    }
    
    //データベースにデータを追加する
    @IBAction func addData(_ sender: UIButton) {
        defaultStore.collection("ToDoList").addDocument(data:[
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
        self.present(alert,animated: true,completion: {()->Void in print("アラート表示")})//completionは動作完了時に発動。
    }
    
    //データベースからデータを取り出す
    @IBAction func getData(_ sender: UIButton) {
        todoList = []
        memoList = []
        idList = []
        defaultStore.collection("ToDoList").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.idList.append(document.documentID)
                    self.todoList.append(document.data()["ToDo"] as! String)
                    self.memoList.append(document.data()["memo"] as! String)
                }
                self.myTableView.reloadData()
            }
        }
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

