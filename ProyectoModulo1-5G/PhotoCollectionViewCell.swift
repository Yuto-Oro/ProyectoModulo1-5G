//
//  PhotoCollectionViewCell.swift
//  ProyectoModulo1-5G
//
//  Created by Berenice Medel on 11/04/21.
//

import UIKit
import FirebaseStorage
import FirebaseUI

class PhotoCollectionViewCell: UICollectionViewCell {
    var photoView: UIImageView = {
        let pv = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
        return pv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("pintanto")
        addSubview(photoView)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }}
