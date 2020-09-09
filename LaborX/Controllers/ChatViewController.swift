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

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
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
    
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
        
    }()
    
    public let otherUserEmail: String
    private let conversationId: String?
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

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
       
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

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageId = createMessageID() else {
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
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: message, completion: { success in
                if success {
                    print("message sent")
                }
                else {
                    print("failed to send")
                }
            })
        }
    }
    
    private func createMessageID() -> String? {
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
}
