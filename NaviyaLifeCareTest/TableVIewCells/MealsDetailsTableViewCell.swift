//
//  MealsDetailsTableViewCell.swift
//  NaviyaLifeCareTest
//
//  Created by Aman gupta on 28/08/18.
//  Copyright © 2018 Aman Gupta. All rights reserved.
//

import UIKit

class MealsDetailsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var mealTimeLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    // MARK: - Cell life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Configure cell
    func configureMealDetailCell(withModel model: MealDetail) {
        self.mealNameLabel.text = model.food ?? "No food"
        self.mealTimeLabel.text = model.mealTime ?? "00:00"
    }
    
}
