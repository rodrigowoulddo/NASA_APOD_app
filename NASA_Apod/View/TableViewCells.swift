//
//  TableViewCells.swift
//  NASA_Apod
//
//  Created by Rodrigo Giglio on 14/04/19.
//  Copyright © 2019 Rodrigo Giglio. All rights reserved.
//

import Foundation
import UIKit

public class ApodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
