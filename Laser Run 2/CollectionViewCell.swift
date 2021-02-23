//
//  CollectionViewCell.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 02/07/2020.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
 
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var des: UILabel!
    var name: String!
    
    
}

