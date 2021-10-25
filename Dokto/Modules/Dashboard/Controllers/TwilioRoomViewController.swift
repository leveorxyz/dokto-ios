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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

}
