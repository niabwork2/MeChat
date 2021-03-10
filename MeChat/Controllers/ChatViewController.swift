import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
//        Message(sender: "1@5.com", body: "Hey!"),
//        Message(sender: "1@4.com", body: "Hello!"),
//        Message(sender: "1@3.com", body: "Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!Hola!")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .black
        let userEmail = Auth.auth().currentUser?.email
        
        tableView.dataSource = self
        title = userEmail
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier )
        
        loadMessages()
        
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
                
                self.messages = []
                
                
                if let e = error {
                    print("Error loading data from Firestore, \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        }
                    }
                    print("Successfully loaded data.")
                }
                
            }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName)
                .addDocument(data: [K.FStore.senderField : messageSender,
                                    K.FStore.bodyField : messageBody,
                                    K.FStore.dateField : Date().timeIntervalSince1970
                ]) {
                    (error) in
                    if let e = error {
                        print("Error saving data to Firestore, \(e)")
                    } else {
                        print("Successfully saved data.")
                        
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                    }
                }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label?.text = message.body
        
        // Message from current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(white: 0, alpha: 0)
            cell.messageBubble.layer.borderColor = CGColor(red: 1.000, green: 0.137, blue: 0.459, alpha: 1.000)
            cell.messageBubble.layer.borderWidth = 1.5
            cell.label.textColor = UIColor(named: K.BrandColors.SuperLightPink)
        }
        // This is a message from another sender
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.SuperLightPink)
            cell.messageBubble.layer.borderColor = CGColor(red: 1.000, green: 0.137, blue: 0.459, alpha: 1.000)
            cell.messageBubble.layer.borderWidth = 1.5
            cell.label.textColor = UIColor(named: K.BrandColors.DarkPink)
            
        }
        
        return cell
    }
    
}
