//
//  Date+Ex.swift
//  BaseProject
//
//  Created by MTQ on 8/14/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation
import SwiftDate

private struct Constant {
    struct Format {
        // http://nsdateformatter.com
        static let format1 = "hh:mm a" // 5:10 AM, 10:54 PM
        static let format2 = "MMM dd, h:mm a" // Aug 16, 10:30 AM
        static let format3 = "MMM dd yyyy, h:mm a" // Aug 02 2018, 10:30 AM
        static let format4 = "dd MMM yyyy, h:mm a" // 02 Aug 2018, 10:30 AM
        static let format5 = ""
        static let format6 = ""
        static let format7 = ""
        static let format8 = ""
    }
}

extension Date {    
    /**
     - Nếu trong ngày, hiển thị thời gian AM/PM
     9:03 AM, 11:20 PM
     - Nếu cách đó 1 tuần, hiển thị ngày và thời gian AM/PM
     Thu 9:10 PM
     - Trên 1 tuần, hiển thị ngày, tháng, năm và thời gian AM/PM
     Aug 10, 2017 10:48 AM
     */
    func timeAgo() -> String {
        var dateString = ""
        if self.isToday {
            dateString = self.toFormat(Constant.Format.format1)
        } else if self.compareCloseTo(Date(), precision: 1.weeks.timeInterval) {
            dateString = self.toFormat(Constant.Format.format2)
        } else {
            dateString = self.toFormat(Constant.Format.format4)
        }
        return dateString
    }
    
    /**
     1m ago
     1h ago
     1d ago
     1w ago
     1M ago
     1 year ago
     */
    public func displayTime() -> String {
        let timeInterval = self.timeIntervalSince1970
        var delta = abs(Date().timeIntervalSince1970 - timeInterval)
        if delta < 60 {
            delta = 60
        }
        let oneHour = Double(60 * 60)
        
        if delta < oneHour {
            let minutes = Int(delta / 60)
            return String(minutes) + " m"
        } else if delta < 24 * oneHour {
            let hours = Int(delta / 3600)
            return String(hours) + " h"
        } else if delta < 7 * 24 * oneHour {
            let day = Int(delta / 3600 / 24)
            return String(day) + " d"
        } else if delta < 4 * 7 * 24 * oneHour {
            let week = Int(delta / 86400 / 7)
            return String(week) + " w"
        } else if delta < 12 * 28 * 24 * oneHour {
            let month = Int(delta / 86400 / 7 / 4)
            return String(month) + " M"
        } else {
            let year = Int(delta / 86400 / 7 / 4 / 12)
            return String(year) + " y"
        }
    }
}
