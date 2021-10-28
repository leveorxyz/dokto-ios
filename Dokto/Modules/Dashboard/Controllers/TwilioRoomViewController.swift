//
//  TwilioRoomViewController.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 25/10/21.
//

import UIKit
import TwilioVideo

class TwilioRoomViewController: UIViewController, RoomDelegate, LocalParticipantDelegate, CameraSourceDelegate, RemoteParticipantDelegate, VideoViewDelegate {
    
    var room : Room?
    var twilioAccessToken = ""
    
    var localAudioTrack = LocalAudioTrack()
    var localDataTrack = LocalDataTrack()
    var localVideoTrack : LocalVideoTrack?
    var remoteView : VideoView?
    
    
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var RoomNameField: UITextField!
    private let viewModel = TwilioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let camera = CameraSource(delegate: self) {
            localVideoTrack = LocalVideoTrack(source: camera)
        }
        
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
                self?.joinRoom(accessToken: self?.twilioAccessToken ?? "nil", roomName : roomName)
            }
        }
        
    }
    
    
    
   
}

extension TwilioRoomViewController{
    public func joinRoom(accessToken : String,roomName : String){
        let connectOptions = ConnectOptions(token: accessToken){(builder) in
            
            builder.roomName = roomName
            
            if let audioTrack = self.localAudioTrack {
                builder.audioTracks = [ audioTrack ]
            }
            
        }
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
    }
    
    //Room delegate function
    func roomDidConnect(room: Room) {
        print("Did connect to room")
        
        if let localParticipant = room.localParticipant {
            print("Local identity \(localParticipant.identity)")
            localParticipant.delegate = self
        }
        print("Number of connected Participants \(room.remoteParticipants.count)")
        
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        print ("Participant \(participant.identity) has joined Room \(room.name)")
        participant.delegate = self
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        print ("Participant \(participant.identity) has left Room \(room.name)")
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack,
                                  publication: RemoteVideoTrackPublication,
                                  participant: RemoteParticipant) {

        print("Participant \(participant.identity) added a video track.")

        if let remoteView = VideoView.init(frame: self.view.bounds,
                                           delegate:self) {

            videoTrack.addRenderer(remoteView)
            self.view.addSubview(remoteView)
            self.remoteView = remoteView
        }
    }
    
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        print("The dimensions of the video track changed to: \(dimensions.width)x\(dimensions.height)")
        self.view.setNeedsLayout()
    }
}

