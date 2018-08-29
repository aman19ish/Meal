//
//  CommonClass.swift
//  NaviyaLifeCareTest
//
//  Created by Aman gupta on 29/08/18.
//  Copyright © 2018 Aman Gupta. All rights reserved.
//

import UIKit

class CommonClass {
    class func getFormattedDateFromDate(toFormat: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = toFormat
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func getDate(from: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: from)
    }
    
}
