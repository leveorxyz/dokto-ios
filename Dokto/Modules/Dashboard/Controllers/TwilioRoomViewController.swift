//
//  TwilioRoomViewController.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 25/10/21.
//

import UIKit
import TwilioVideo

class TwilioRoomViewController: UIViewController {
    
    var room : Room?
    var audioTrack : LocalAudioTrack?
    var videoTrack : LocalVideoTrack?
    var twilioAccessToken = ""
    
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
            }
        }
        
    }
    
}

