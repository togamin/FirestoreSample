## 【swift4】Firebaseのデータベース「Firestore」を利用したToDoアプリの作成

* ```
  授業3時間かかった
  ドキュメントのIDを指定して書き込む場合、読み込む場合の説明。
  https://qiita.com/miyae/items/6988c1b61b76b4938ae6
  ```

### Firebaseとは

* ユーザーから見えない処理(バックエンド)をクラウド上で提供してくれるサービス。ユーザー認証、データベース、プッシュ通知、ストレージ、その他様々な機能を提供してくれている。
* 「バックエンド」：フロントエンドの入力データや指示をもとに、処理を行って結果を出力したり、記録媒体に保存したりする処理を行う。
* 個人でわざわざ、サーバーのセットアップやメンテナンスをする必要がない。

* Firestoreとは

  * Firebaseが提供しているデータベースの一つ。「Realtime Database」の成果をさらに向上させたもの。「Realtime Database」の新しいもの。「Realtime Database」は巨大なJSONのストレージに対して、「Firestore」は本格的なデータベース。ドキュメント指向型データベース。
  * RDBとドキュメント指向型データベースの違いを説明する。

* アプリ作成の概要

  * シュミレーターで確認
    * 追加：「ToDo記入」→「追加」→「読み込み」
    * 削除：「削除」→「読み込み」
    * 更新：「編集」→「読み込み」
  * どんな感じでデータが挿入されるかも確認しながら見せる。

* アプリ開発

  * Firestoreを使う準備まで

    * [Firebaseのホームページ](https://firebase.google.com/?hl=ja)に行く。

    * Firebaseでプロジェクトを作成。
    * iOSを選択。バンドルIDなどを記入。「GoogleService-Info」を追加。

    * NewFile作成[Firestore]

    * ```swift
      //ターミナル
      pod init
      
      //Podfileに記入
      //iOS アプリで Firebase を稼働させるために必要なライブラリ
      pod 'Firebase/Core'
      //Firestoreを使うためのライブラリ
      pod 'Firebase/Firestore'
      ```

    * 「AppDelegate.swift」に以下を記入

    * ```swift
      import Firebase
      import FirebaseFirestore
      
      //didFinishLaunchingWithOptionsの中
      FirebaseApp.configure()
      ```

    * Firestoreのインスタンス化。UIViewController.swiftへ

    * ```swift
      import Firebase
      import FirebaseFirestore
      
      var defaultStore : Firestore!
      
      defaultStore = Firestore.firestore()
      ```

  * UIの配置

    * TextField × 2、追加ボタン、読み込みボタン、TableView、TableViewCell

    * コードに紐ずけ。

    * addDataにFirestoreへのデータの追加のコードを書く

      ```swift
      //Firestoreへの書き込み。意味のあるドキュメントIDを指定する必要がない場合、「addDocument」を使用しても、データの書き込みを行うことが可能。addDocumentを使用した場合は、ドキュメントIDが自動で生成。
      
      //「addDocument(data:[」が「document("ToDo").setData([」だと上書きされてしまう。
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
      ```

      * アラートの追加

      * ```swift
        //アラートの設定
        let alert = UIAlertController(title: "データを追加しました。", message: nil, preferredStyle: .alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
        	//OKを押した後の処理。
        }))
        //その他アラートオプション
        alert.view.layer.cornerRadius = 25 //角丸にする。
        present(alert,animated: true,completion: {()->Void in print("アラート表示")})//completionは動作完了時に発動。
        ```

    * Firestoreデータベースからデータを読み出す。

    * ```swift
      //読み出したデータを代入するための変数を定義
      var todoList:[String] = []
      var memoList:[String] = []
      var idList:[String] = []
      
      //データベースからデータを取り出す
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
      ```

    * テーブルViewの設定

    * ```swift
      //デリゲート追加
      UITableViewDelegate
      UITableViewDataSource
      
      //ViewDidLoad内に追加
      myTableView.delegate = self
      myTableView.dataSource = self
      
      //セルの数
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return idList.count
      }
      
      
      //セルのインスタンス化
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      	let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      	return cell
      }
      
      //セルを横にスライドさせた時に呼ばれる
      func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      
      	//データの削除用ボタン
      	let deleteCell: UITableViewRowAction = 	UITableViewRowAction(style: .normal, title: "削除"){ (action, index) -> Void in
                  
                  
      	}
      	//データの編集ボタン
      	let editCell: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "編集"){ (action, index) -> Void in
                  
      	}
      	deleteCell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.6)
      	editCell.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.6)
          return [deleteCell,editCell]
      }
      ```

    * tableViewCellに代入。

    * ```swift
      //セルにテキストを代入
      cell.textLabel?.text = todoList[indexPath.row]
      cell.detailTextLabel?.text = memoList[indexPath.row]
      ```

    * Firestoreからの削除

    * ```swift
      self.defaultStore.collection("ToDoList").document(self.idList[indexPath.row]).delete() { err in
      	if let err = err {
         		print("Error removing document: \(err)")
      	} else {
         		print("Document successfully removed!")
          }
      }
      ```

    * Firestoreへの上書き。編集が押されたらアラートを表示し、変更内容を記入。

    * ```swift
      //アラートの設定
      let alert = UIAlertController(title: "データを編集します", message: nil, preferredStyle: .alert)
      //OKボタン
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
            //OKを押した後の処理。
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
      ```

    * ```swift
      //idのドキュメンのを更新
      self.defaultStore.collection("ToDoList").document(self.idList[indexPath.row]).setData([
           "ToDo": alert.textFields![0].text!,
           "memo": alert.textFields![1].text!
      ]) { err in
            if let err = err {
               print("Error writing document: \(err)")
            } else {
               print("Document successfully written!")
      }
      ```

    * KeyBordの「Done」ボタン追加

    * ```swift
      //ViewDidLoad内に追加
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
      
      //ViewDidLoad外に作成
      @objc func closeKeybord(_ sender:Any){
            self.view.endEditing(true)
      }
      ```



* Firestoreを詳しく
  * Firestoreとは、NoSQLドキュメント指向データベース。SQLデータベースとは違って、「テーブル」や「行」というものがそもそもない。その代わりに、データは「ドキュメント」に格納し、それが「コレクション」にまとめられる。<font color = "blue"> 「Collection」と「Document」という単語はデータベースを読み出す時等に出てくるので、覚えておくように伝える。</font>
  * フォルダ(コレクション)、ファイル(ドキュメント)、データ(ファイルに書かれた情報)
  * 全ての「ドキュメント」は「コレクション」に保存する必要がある。
  * RDBとNoSQLデータベースとの違い
    * RDB
      * トランザクションを保証
      * データの信頼性を重視
      * データの一貫性が厳密に問われるシステムに用いられる。
    * NoSQL
      * トランザクション処理を妥協する代わりに、大量のデータ処理の高速化。
      * スケールアウトすることを重視
      * 膨大に増え続ける大量なデータを追加記録し、検索、参照、分析、解析するシステムに使われる。
  * ドキュメント指向データベースとは
    * RDBはデータを表形式で保存する。表にしやすいデータであれば、効率良く管理することができる。
    * しかし、世の中の全て表形式で保存できるデータとは限らない。柔軟な構造でデータを扱えるようなデータベースとして「ドキュメント指向型データベース」と呼ばれるデータベースが出てきた。
    * 1件分のデータを「ドキュメント」と呼ぶ。個々のドキュメントのデータ構造は自由。
    * ![Screen Shot 2018-09-28 at 10.07.32](/Users/togamiyuki/Desktop/IOSTeach/img/Screen Shot 2018-09-28 at 10.07.32.png)

### 発生したエラーについて

```swift
//Could not build Objective-C module 'Firebase'
Xcodeを再起動。ビルドした時に消えることがあるので、無視しても大丈夫。
//「GoogleService-Info」が「GoogleService-Info (1)」のように数字がついていると実行時にエラーが出る。数字を消す必要がある。
```



* 参考文献

  * [データベースを選択: Cloud Firestore または Realtime Database](https://firebase.google.com/docs/database/rtdb-vs-firestore?hl=ja)
  * [Firebase Realtime DBを実践投入するにあたって考えたこと](https://qiita.com/1amageek/items/64bf85ec2cf1613cf507)
  * [Cloud FirestoreのSubCollectionとQueryっていつ使うの問題](https://qiita.com/1amageek/items/d2ef7a49bccf5b4ea78e)
  * [Cloud Firestore データモデル](https://firebase.google.com/docs/firestore/data-model?hl=ja)
  * [ドキュメント指向データベースと列指向データベース](https://thinkit.co.jp/story/2010/10/15/1798)

