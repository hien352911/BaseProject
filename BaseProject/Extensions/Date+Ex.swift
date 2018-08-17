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
        static let format1 = "hh:mm a" // 5:10 AM, 10:54 PM
        static let format2 = "MMM dd, h:mm a" // Aug 16, 10:30 AM
        static let format3 = "MMM dd yyyy, h:mm a" // Aug 02 2018, 10:30 AM
        static let format4 = ""
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
            dateString = self.toFormat(Constant.Format.format3)
        }
        return dateString
    }
}
