//
//  DateUtils.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/11/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

extension NSDate {
    
    class func getRangeOfWeek(date:NSDate) -> (NSDate, NSDate) {
        
        let cal = NSCalendar.currentCalendar()
        
        var beginningOfWeek: NSDate?
        var weekDuration = NSTimeInterval()
        cal.rangeOfUnit(.CalendarUnitWeekOfYear, startDate: &beginningOfWeek, interval: &weekDuration, forDate: date)
        let endOfWeek = beginningOfWeek?.dateByAddingTimeInterval(weekDuration)
        return (beginningOfWeek!, endOfWeek!)
    }
    
    class func getFirstDateOfWeek(date:NSDate) -> NSDate {
        
        let cal = NSCalendar.currentCalendar()
        var beginningOfWeek: NSDate?
        var weekDuration = NSTimeInterval()
        cal.rangeOfUnit(.CalendarUnitWeekOfYear, startDate: &beginningOfWeek, interval: &weekDuration, forDate: date)
        let endOfWeek = beginningOfWeek?.dateByAddingTimeInterval(weekDuration)
        return beginningOfWeek!
    }
    
    func dateBySubtractingWeeksFromDate(numOfWeeks:Int) -> NSDate? {
        let cal = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.weekOfYear = -1 * numOfWeeks
        
        return cal.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions(0))
    }
    
    func getCalendarComponent(unit:NSCalendarUnit) -> Int {
        let cal = NSCalendar.currentCalendar()
        return cal.component(unit, fromDate: self)
    }
    
    class func getFirstDateOfWeekFromWeekNumber(weekOfYear:Int, inYear:Int) -> NSDate {
        
        let cal = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.weekOfYear = weekOfYear
        components.yearForWeekOfYear = inYear
        
        return cal.dateFromComponents(components)!
    }
}