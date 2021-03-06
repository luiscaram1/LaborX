//
//  ChatViewController.swift
//  LaborX
//
//  Created by Luis Caram on 8/29/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView
import SDWebImage
import AVFoundation
import AVKit
import CoreLocation

var remoteInstance = ""


struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
    
    
}
extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "custom"
        case .linkPreview(_):
            return "link_preview"
        }
    }
}

struct Sender: SenderType {
   public var photoURL: String
   public var senderId: String
   public var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var senderPhotoURL: URL?
    private var otherUserPhotoURL: URL?
    
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
        
    }()
    
    public let otherUserEmail: String
    private var conversationId: String?
    public var isNewConversation = false
    
    
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        return Sender(photoURL: "",
               senderId: safeEmail,
               displayName: "Me")
    }
    
    
    init(with email: String, id: String?) {
        self.conversationId = id
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
        if let conversationId = conversationId {
            listenForMessages(id: conversationId)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayFCMToken(notification:)),
        name: Notification.Name("FCMToken"), object: nil)

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
       
    }
    
    @objc func displayFCMToken(notification: NSNotification){
      guard let userInfo = notification.userInfo else {return}
      if let fcmToken = userInfo["token"] as? String {
        print("Received FCM token: \(fcmToken)")
      }
    }
    
    private func setupInputButton() {
        let token = Messaging.messaging().fcmToken
           print("FCM token: \(token ?? "")")
           // [END log_fcm_reg_token]

           // [START log_iid_reg_token]
           InstanceID.instanceID().instanceID { (result, error) in
             if let error = error {
               print("Error fetching remote instance ID from chat: \(error)")
             } else if let result = result {
               print("Remote instance ID token from chat: \(result.token)")
                
                remoteInstance = result.token
              //hi self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
             }
           }
        
        // [START subscribe_topic]
        Messaging.messaging().subscribe(toTopic: "weather") { error in
          print("Subscribed to weather topic")
        }
        // [END subscribe_topic]
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside{ [weak self] _ in
            self?.presentInputActionSheet()
        }
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to Attach?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self] _ in
            self?.presentVideoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Location", style: .default, handler: { [weak self] _ in
            self?.presentLocationPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
        
    }
    
    private func presentLocationPicker() {
        let vc = LocationPickerViewController(coordinates: nil)
        vc.title = "Pick Location"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { [weak self] selectedCoordinates in
            
            guard let strongSelf = self else {
                return
            }
            
            guard let messageId = strongSelf.createMessageId(),
                let conversationId = strongSelf.conversationId,
                let name = strongSelf.title,
                let selfSender = strongSelf.selfSender else {
                           return
                   }
            
            let longitud: Double = selectedCoordinates.longitude
            let latitude: Double = selectedCoordinates.latitude
            
            print("Long: \(longitud) | lat: \(latitude)")
            
            let location = Location(location: CLLocation(latitude: latitude, longitude: longitud), size: .zero)
            
            
            let message = Message(sender: selfSender,
                                  messageId: messageId,
                                  sentDate: Date(),
                                  kind: .location(location))
            
            
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: {success in
                
                if success {
                    print("sent Location message")
                }
                else {
                    print("failed to send location message")
                }
                
            })

            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                                   message: "Where would you lke to attach a photo from?",
                                                   preferredStyle: .actionSheet)
               
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
                
            }))
        
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
                
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(actionSheet, animated: true)
            
        }
    
    private func presentVideoInputActionsheet() {
    let actionSheet = UIAlertController(title: "Attach Video",
                                               message: "Where would you like to attach a video from?",
                                               preferredStyle: .actionSheet)
           
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
    
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
        
    }
    
    private func listenForMessages(id: String) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
            switch result {
            case .success(let messages):
                print("succes in getting messages \(messages)")
                guard !messages.isEmpty else {
                    print("messages are empty")
                    return
                }
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                }
                
                
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let messageId = createMessageId(),
            let conversationId = conversationId,
            let name = self.title,
            let selfSender = selfSender else {
                return
        }
        
        if let image = info[.editedImage] as? UIImage, let imageData = image.pngData() {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
            
            //uplaod image
            
            StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let urlString):
                    //Ready to send Message
                    print("Uploaded Message Photo : \(urlString)")
                    
                    guard let url = URL(string: urlString),
                        let placeholder = UIImage(systemName: "plus") else {
                            return
                    }
                    
                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)
                    
                    
                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
                                          kind: .photo(media))
                    
                    
                    DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: {success in
                        
                        if success {
                            print("sent photo message")
                        }
                        else {
                            print("failed to send photo message")
                        }
                        
                    })
                    
                    
                case.failure(let error):
                    print("Message photo error: \(error)")
                }
            })
        }
        else if let videoUrl = info[ .mediaURL] as? URL {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".mov"
            
            //upload video
            
            StorageManager.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: { [weak self] result in
                           guard let strongSelf = self else {
                               return
                           }
                           
                           switch result {
                           case .success(let urlString):
                               //Ready to send Message
                               print("Uploaded Message Video : \(urlString)")
                               
                               guard let url = URL(string: urlString),
                                   let placeholder = UIImage(systemName: "plus") else {
                                       return
                               }
                               
                               let media = Media(url: url,
                                                 image: nil,
                                                 placeholderImage: placeholder,
                                                 size: .zero)
                               
                               
                               let message = Message(sender: selfSender,
                                                     messageId: messageId,
                                                     sentDate: Date(),
                                                     kind: .video(media))
                               
                               
                               DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
                                   
                                   if success {
                                       print("sent video message")
                                   }
                                   else {
                                       print("failed to send photo message")
                                   }
                                   
                               })
                               
                               
                           case.failure(let error):
                               print("Message photo error: \(error)")
                           }
                       })
        }
        
        
        
        //send message
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageId = createMessageId() else {
                return
        }
        
        print("Sending: \(text)")
        
        let message = Message(sender: selfSender,
                                         messageId: messageId,
                                         sentDate: Date(),
                                         kind: .text(text))
        
        //send message
        if isNewConversation {
            //create convo in databse
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message, completion: {
                [weak self] success in
                if  success {
                    print("message sent")
                    self?.isNewConversation = false
                    let newConversationID = "conversation_\(message.messageId)"
                    self?.conversationId = newConversationID
                    self?.listenForMessages(id: newConversationID)
                    self?.messageInputBar.inputTextView.text = nil
                    
                }
                else{
                     print("failed to send")
                }
            })
        
        }
        else{
            guard let conversationId = conversationId, let name = self.title else {
                return
            }
            //append to existing conversation
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: message, completion: { [weak self ]success in
                if success {
                    self?.messageInputBar.inputTextView.text = nil
                    
                    let sender = PushNotificationSender()
                    sender.sendPushNotification(to: remoteInstance, title: "Chat Notification", body: "Testing Chat Button Tapped")
                    
                    print("message sent")
                }
                else {
                    print("failed to send")
                }
            })
        }
    }
    
    private func createMessageId() -> String? {
        //date, otherUserEmail, senderEmail, randomInt
        let dateString = Self.dateFormatter.string(from: Date())
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        print("Created Message ID: \(newIdentifier)")
        return newIdentifier
    }
    
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is Nil, email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            //our messaage that we've sent
            return .link
        }
        return .secondarySystemBackground
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let sender = message.sender
        
        if sender.senderId == selfSender?.senderId {
            //show our image
            if let currentUserImageURL = self.senderPhotoURL {
                avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
            }
            else {
                
                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                    return
                }
                
                let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
                let path = "images/\(safeEmail)_profile_picture.png"
                
                //fetch url
                
                
                StorageManager.shared.downlaodURL(for: path, completion: { [weak self] result in
                    switch result {
                    case .success(let url):
                        self?.senderPhotoURL = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url, completed: nil)
                        }
                    case .failure(let error):
                        print("error Fetching url: \(error)")
                    }
                })
            }
        }
        else {
            // other user image
        if let otherUserPhotoURL = self.otherUserPhotoURL {
                avatarView.sd_setImage(with: otherUserPhotoURL, completed: nil)
            }
            else {
                //fetch url
            let email = self.otherUserEmail
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            let path = "images/\(safeEmail)_profile_picture.png"
            
            //fetch url
            
            
            StorageManager.shared.downlaodURL(for: path, completion: { [weak self] result in
                switch result {
                case .success(let url):
                    self?.otherUserPhotoURL = url
                    DispatchQueue.main.async {
                        avatarView.sd_setImage(with: url, completed: nil)
                    }
                case .failure(let error):
                    print("error Fetching url: \(error)")
                }
            })
            }
        }
    }
}

extension ChatViewController: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
         guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
                   return
               }
               
               let message = messages[indexPath.section]
        
        switch message.kind {
        case .location(let locationData):
            let coordinates = locationData.location.coordinate
            let vc = LocationPickerViewController(coordinates: coordinates)
            vc.title = "Location"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        let message = messages[indexPath.section]
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewerViewController(with: imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .video(let media):
            guard let videoUrl = media.url else {
                return
            }
            
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: videoUrl)
            present(vc, animated: true)
        default:
            break
        }
    }
}
