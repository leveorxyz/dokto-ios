//
//  TwilioRoomViewController.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 25/10/21.
//

import UIKit
import TwilioVideo

class TwilioRoomViewController: UIViewController, RoomDelegate, LocalParticipantDelegate {
    
    var room : Room?
    var audioTrack : LocalAudioTrack?
    var videoTrack : LocalVideoTrack?
    var twilioAccessToken = ""
    
    var localAudioTrack = LocalAudioTrack()
    var localDataTrack = LocalDataTrack()
    var localVideoTrack : LocalVideoTrack?
    
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var RoomNameField: UITextField!
    private let viewModel = TwilioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func joinRoomAction(_ sender: Any) {
        guard let userName = UserNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ,
              let roomName = RoomNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !userName.isEmpty, !roomName.isEmpty else{
                  print("Enter a valid userName and room name")
                  return
              }
        viewModel.getTwilioAccessToken(userName: userName, roomName: roomName) {[weak self] accessToken in
            DispatchQueue.main.async {
                self?.twilioAccessToken = accessToken
                print("Got Access token \(self?.twilioAccessToken)")
                self?.joinRoom(accessToken: self?.twilioAccessToken ?? "nil")
            }
        }
        
    }
    
    //joining an already created room
    
    public func joinRoom(accessToken : String){
        let connectOptions = ConnectOptions(token: accessToken){(builder) in
            
            builder.roomName = "random"
            
        }
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        print(room?.name)
    }
    
    //Room delegate function
    func roomDidConnect(room: Room) {
        print("Did connect to room")

        if let localParticipant = room.localParticipant {
            print("Local identity \(localParticipant.identity)")

            // Set the delegate of the local particiant to receive callbacks
            localParticipant.delegate = self
        }
    }
}

