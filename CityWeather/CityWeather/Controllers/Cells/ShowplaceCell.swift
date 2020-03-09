//
//  ShowplaceCell.swift
//  CityWeather
//
//  Created by Admin on 26/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit

class ShowplaceCell : UITableViewCell {
    let nameLabel : UILabel = {
    let label = UILabel()
        label.font = UIFont(name: "Arial-BoldMT", size: 22)
        label.textAlignment = .left
    return label
    }()
    
    let descLabel : UILabel = {
    let label = UILabel()
        label.font = UIFont(name: "Arial-MT", size: 18)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.numberOfLines = 3
    return label
    }()
    
    var showplaceImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.loadImage(url: "https://ru.freepik.com/premium-photo/green-grass-texture-with-blang-copyspace-against-blue-sky_5207864.htm#page=1&query=field&position=0")
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let gradient = UIImageView()
        gradient.image = UIImage(imageLiteralResourceName: "gradient")
        showplaceImageView.layer.cornerRadius = 12
        showplaceImageView.layer.masksToBounds = true
        addSubview(showplaceImageView)
        gradient.layer.cornerRadius = 12
        gradient.layer.masksToBounds = true
        addSubview(gradient)
        addSubview(nameLabel)
        addSubview(descLabel)
        
       
       showplaceImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        gradient.anchor(top: showplaceImageView.topAnchor, left: showplaceImageView.leftAnchor, bottom: showplaceImageView.bottomAnchor, right: showplaceImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        descLabel.anchor(top: nil, left: showplaceImageView.leftAnchor, bottom: showplaceImageView.bottomAnchor, right: showplaceImageView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0 , height: 0, enableInsets: false)
        nameLabel.anchor(top: nil, left: showplaceImageView.leftAnchor, bottom: descLabel.topAnchor, right: showplaceImageView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0,  height: 0, enableInsets: false)

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    
}
