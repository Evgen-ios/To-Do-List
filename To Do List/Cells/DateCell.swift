//
//  DateCell.swift
//  To Do List
//
//  Created by Evgeniy Goncharov on 04.10.2021.
//

import UIKit

class DateCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    
    func setDate(_ date: Date) {
        label.text = date.formattedDate
    }

}
