//
//  TwilioParticipantCollectionViewCell.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 29/11/21.
//

import UIKit
import TwilioVideo

class TwilioParticipantCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "TwilioParticipantCollectionViewCell"
    
    public let participantNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,weight : .thin)
        label.numberOfLines = 0
        return label
    }()
    
    public let participantView : VideoView = {
        let video = VideoView()
        video.contentMode = .scaleAspectFill
        return video
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(participantNameLabel)
        contentView.addSubview(participantView)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        participantView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height-20)
        participantNameLabel.frame = CGRect(x: 0, y: participantView.frame.origin.y+participantView.frame.height+2, width: contentView.frame.width, height: 18)
    }
    
    override func prepareForReuse(){
        participantNameLabel.text = nil
        //
    }
}
