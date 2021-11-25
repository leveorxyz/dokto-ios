//
//  TwilioRoomViewController.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 25/10/21.
//

import UIKit
import TwilioVideo

class TwilioRoomViewController: UIViewController, LocalParticipantDelegate{
    
    var twilioAccessToken = ""
    
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var remoteView: VideoView?
    
    @IBOutlet weak var RoomNameField: UITextField!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var previewView: VideoView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var cameraConnectButton: UIButton!
    @IBOutlet weak var cameraRotateButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    private let viewModel = TwilioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Connect to a room"
        self.disconnectButton.setTitle("", for: .normal)
        self.micButton.setTitle("", for: .normal)
        self.cameraConnectButton.setTitle("", for: .normal)
        self.cameraRotateButton.setTitle("", for: .normal)
        self.settingsButton.setTitle("", for: .normal)
        
//        self.micButton.cornerRadius = micButton.frame.width/2.0
//        self.settingsButton.cornerRadius = settingsButton.frame.width/2.0
//        self.cameraConnectButton.cornerRadius = cameraConnectButton.frame.width/2.0
//        self.disconnectButton.cornerRadius = disconnectButton.frame.width/2.0
//        self.cameraRotateButton.cornerRadius = cameraRotateButton.frame.width/2.0
        
        self.cameraRotateButton.isEnabled = false
        if PlatformUtils.isSimulator {
            self.previewView.backgroundColor = .black
        } else {
            // Preview our local camera track in the local video preview view.
            self.startPreview()
        }
        prepareLocalMedia()
        self.disconnectButton.isHidden = true
        self.micButton.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(TwilioRoomViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
            return self.room != nil
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupRemoteVideoView() {
        self.remoteView = VideoView(frame: CGRect.zero, delegate: self)
        
        self.view.insertSubview(self.remoteView!, at: 0)
        
        self.remoteView!.contentMode = .scaleAspectFill;
        remoteView?.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height)
        
    }
    
    
    @IBAction func joinRoomAction(_ sender: Any) {
        guard let roomName = RoomNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !roomName.isEmpty else{
                  print("Enter a valid userName and room name")
                  return
              }
        //a309fd116b99463eb52402988d5a35d7
        //3fa85f64-5717-4562-b3fc-2c963f66afa6
        //3fa85f64-5717-4562-b3fc-2c963f66afa8
        
        viewModel.getTwilioAccessToken(id: "a309fd116b99463eb52402988d5a35d8", roomName: roomName) {[weak self] accessToken in
            DispatchQueue.main.async {
                self?.twilioAccessToken = accessToken
                self?.joinRoom(accessToken: self?.twilioAccessToken ?? "nil", roomName : roomName)
            }
        }
        
    }
    
    @IBAction func disconnect(_ sender: Any) {
        self.room!.disconnect()
        print("Attempting to disconnect from room \(room!.name)")
    }
    
    
    
    @IBAction func toggleMic(_ sender: Any) {
        if (self.localAudioTrack != nil) {
            self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
            
            // Update the button title
            if (self.localAudioTrack?.isEnabled == true) {
                self.micButton.setImage(UIImage(named: "mic.fill"), for: .normal)
            } else {
                self.micButton.setImage(UIImage(named: "mic.slash"), for: .normal)
            }
        }
    }
    
    
    @IBAction func toggleCameraOnOff(_ sender: Any) {
        if (self.localVideoTrack != nil){
            self.localVideoTrack?.isEnabled = !(self.localVideoTrack?.isEnabled)!
        }
        if (self.localVideoTrack?.isEnabled == true){
            self.cameraConnectButton.setImage(UIImage(named: "video"), for: .normal)
        }
        else{
            self.cameraConnectButton.setImage(UIImage(named: "video.slash"), for: .normal)
        }
    }
    
    @IBAction func rotateCamera(_ sender: Any) {
        self.flipCamera()
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        print("Settings Tapped")
        
    }
    
    func prepareLocalMedia() {
     
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")
            if (localAudioTrack == nil) {
                print("Failed to create audio track")
            }
        }
        
        if (localVideoTrack == nil) {
            self.startPreview()
        }
    }
    func showRoomUI(inRoom: Bool) {
        self.connectButton.isHidden = inRoom
        self.RoomNameField.isHidden = inRoom
        self.remoteView?.isHidden = !inRoom
        self.disconnectButton.isHidden = !inRoom
        //self.navigationController?.setNavigationBarHidden(inRoom, animated: true)
        UIApplication.shared.isIdleTimerDisabled = inRoom
        
        if inRoom{
            title = RoomNameField.text ?? "Default"
        }
        else{
            title = "Connect to a room"
        }
        //self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    @objc func dismissKeyboard() {
        if (self.RoomNameField.isFirstResponder) {
            self.RoomNameField.resignFirstResponder()
        }
    }
    
   
}

extension TwilioRoomViewController{
    public func joinRoom(accessToken : String,roomName : String){
        self.connectButton.isEnabled = true;
        self.prepareLocalMedia()
        
        let connectOptions = ConnectOptions(token: accessToken){(builder) in
            
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            if let preferredVideoCodec = Settings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            
            builder.roomName = roomName
            
        }
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        self.showRoomUI(inRoom: true)
        self.dismissKeyboard()
    }
    
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }
        
        print("Setting up camera")
        
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {

            self.cameraRotateButton.isEnabled = true
            camera = CameraSource(delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)
            print("Video track created")
            
            if (frontCamera != nil && backCamera != nil) {
                // We will flip camera on tap.
                let tap = UITapGestureRecognizer(target: self, action: #selector(TwilioRoomViewController.flipCamera))
                self.previewView.addGestureRecognizer(tap)
            }
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    print("Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.previewView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            print("No front or back capture device found!")
        }
    }
    
    @objc func flipCamera() {
        var newDevice: AVCaptureDevice?
        
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        print("Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.previewView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        //print(videoPublications.count)
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
               publication.isTrackSubscribed {
                setupRemoteVideoView()
                subscribedVideoTrack.addRenderer(self.remoteView!)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }
    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
               renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }
    func cleanupRemoteParticipant() {
        
        
        if self.remoteParticipant != nil {
            print("removing from super view")
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    func cleanRemoteView(){
        print("Cleaning remote video")
        if self.remoteParticipant != nil {
            print("removing from super view")
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
        }
    }
    
}

extension TwilioRoomViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.joinRoomAction(textField)
        return true
    }
}

extension TwilioRoomViewController : RoomDelegate{
    func roomDidConnect(room: Room) {
        print("Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        print("Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        
        self.showRoomUI(inRoom: false)
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        print("Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        
        self.showRoomUI(inRoom: false)
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        print("Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        print("Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self
        
        print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
        print(participant)
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        print("Room \(room.name), Participant \(participant.identity) disconnected")
        
        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}

extension TwilioRoomViewController : RemoteParticipantDelegate{
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        print("Participant \(participant.identity) published \(publication.trackName) video track")
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        print("Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }
    
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        print("Participant \(participant.identity) published \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.
        print("Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        
        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        print("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()
            
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        
        print("Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        
        print("Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("Participant \(participant.identity) enabled \(publication.trackName) video track")
        if (self.remoteParticipant != nil) {
            print("rendering video again")
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("Participant \(participant.identity) disabled \(publication.trackName) video track")
        cleanRemoteView()
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        print("Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        print("Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}


// MARK:- VideoViewDelegate
extension TwilioRoomViewController : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

// MARK:- CameraSourceDelegate
extension TwilioRoomViewController : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        print("Camera source failed with error: \(error.localizedDescription)")
    }
}

