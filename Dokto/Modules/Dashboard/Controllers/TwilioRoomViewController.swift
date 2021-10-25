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
    
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var RoomNameField: UITextField!
    
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
        let urlString = "http://159.203.72.156/twilio/video-token/"
        
        guard let url = URL(string: urlString) else{
            print("bad URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data : [String : Any] = [
            "username" : userName,
            "room_name" : roomName
        ]
        let requestData = try? JSONSerialization.data(withJSONObject: data)
        urlRequest.httpBody = requestData
        URLSession.shared.dataTask(with: urlRequest) { data, fetchedResponse , error in
            guard let data = data, error == nil else{
                
                print("No data found")
                return
            }
            //debugPrint(fetchedResponse)
            do{
                let tokenResponse = try JSONDecoder().decode(TwilioVideoTokenResponse.self, from: data)
                debugPrint(tokenResponse)
            }
            catch{
                print("Error here")
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}

struct TwilioVideoTokenResponseElement : Codable{
    let status_code : Int
    let message : String
    let token : String
}

typealias TwilioVideoTokenResponse = [TwilioVideoTokenResponseElement]
