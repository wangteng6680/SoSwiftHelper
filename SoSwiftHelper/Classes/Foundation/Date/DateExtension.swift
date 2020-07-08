//
//  DateExtension.swift
//  Pods-SoSwiftHelper_Example
//
//  Created by mac on 2020/7/4.
//
import Foundation

public extension SoSwiftHelperWrapper where Core == Date {
    
    /// Era.
    ///
    ///        Date().so.era -> 1
    ///
    var era: Int {
        return Calendar.current.component(.era, from: base)
    }
    
    /// User’s current calendar.
    var calendar: Calendar {
        return Calendar.current
    }
    
    /// Week of year.
    ///
    ///        Date().so.weekOfYear -> 2 // second week in the year.
    ///
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: base)
    }
    
    /// Week of month.
    ///
    ///        Date().so.weekOfMonth -> 3 // date is in third week of the month.
    ///
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: base)
    }
    
    /// Year.
    ///
    ///        Date().so.year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.sk.year = 2000 // sets someDate's year to 2000
    ///
    var year: Int {
        get {
            return Calendar.current.component(.year, from: base)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = Calendar.current.component(.year, from: base)
            let yearsToAdd = newValue - currentYear
            if let date = Calendar.current.date(byAdding: .year, value: yearsToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// Month.
    ///
    ///     Date().so.month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.sk.month = 10 // sets someDate's month to 10.
    ///
    var month: Int {
        get {
            return Calendar.current.component(.month, from: base)
        }
        set {
            let allowedRange = Calendar.current.range(of: .month, in: .year, for: base)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMonth = Calendar.current.component(.month, from: base)
            let monthsToAdd = newValue - currentMonth
            if let date = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// Day.
    ///
    ///     Date().so.day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.sk.day = 1 // sets someDate's day of month to 1.
    ///
    var day: Int {
        get {
            return Calendar.current.component(.day, from: base)
        }
        set {
            let allowedRange = Calendar.current.range(of: .day, in: .month, for: base)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentDay = Calendar.current.component(.day, from: base)
            let daysToAdd = newValue - currentDay
            if let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// Weekday.
    ///
    ///     Date().so.weekday -> 5 // fifth day in the current week.
    ///
    var weekday: Int {
        return Calendar.current.component(.weekday, from: base)
    }
    
    /// Hour.
    ///
    ///     Date().fd_hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.sk.hour = 13 // sets someDate's hour to 1 pm.
    ///
    var hour: Int {
        get {
            return Calendar.current.component(.hour, from: base)
        }
        set {
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: base)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentHour = Calendar.current.component(.hour, from: base)
            let hoursToAdd = newValue - currentHour
            if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// Minutes.
    ///
    ///     Date().so.minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.sk.minute = 10 // sets someDate's minutes to 10.
    ///
    var minute: Int {
        get {
            return Calendar.current.component(.minute, from: base)
        }
        set {
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: base)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMinutes = Calendar.current.component(.minute, from: base)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// Seconds.
    ///
    ///     Date().so.second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.sk.second = 15 // sets someDate's seconds to 15.
    ///
    var second: Int {
        get {
            return Calendar.current.component(.second, from: base)
        }
        set {
            let allowedRange = Calendar.current.range(of: .second, in: .minute, for: base)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentSeconds = Calendar.current.component(.second, from: base)
            let secondsToAdd = newValue - currentSeconds
            if let date = Calendar.current.date(byAdding: .second, value: secondsToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// Nanoseconds.
    ///
    ///     Date().so.nanosecond -> 981379985
    ///
    ///     var someDate = Date()
    ///     someDate.so.nanosecond = 981379985 // sets someDate's seconds to 981379985.
    ///
    var nanosecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: base)
        }
        set {
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: base)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentNanoseconds = Calendar.current.component(.nanosecond, from: base)
            let nanosecondsToAdd = newValue - currentNanoseconds
            
            if let date = Calendar.current.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// Milliseconds.
    ///
    ///     Date().so.millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.so.millisecond = 68 // sets someDate's nanosecond to 68000000.
    ///
    var millisecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: base) / 1000000
        }
        set {
            let ns = newValue * 1000000
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: base)!
            guard allowedRange.contains(ns) else { return }
            
            if let date = Calendar.current.date(bySetting: .nanosecond, value: ns, of: base) {
                base = date
            }
        }
    }
    
    /// Check if date is in future.
    ///
    ///     Date(timeInterval: 100, since: Date()).fd_isInFuture -> true
    ///
    var isInFuture: Bool {
        return base > Date()
    }
    
    /// Check if date is in past.
    ///
    ///     Date(timeInterval: -100, since: Date().so.isInPast -> true
    ///
    var isInPast: Bool {
        return base < Date()
    }
    
    /// Check if date is within today.
    ///
    ///     Date().so.isInToday -> true
    ///
    var isInToday: Bool {
        return Calendar.current.isDateInToday(base)
    }
    
    /// Check if date is within yesterday.
    ///
    ///     Date().so.isInYesterday -> false
    ///
    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(base)
    }
    
    /// Check if date is within tomorrow.
    ///
    ///     Date().so.isInTomorrow -> false
    ///
    var isInTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(base)
    }
    
    /// Check if date is within a weekend period.
    var isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(base)
    }
    
    /// Check if date is within a weekday period.
    var isWorkday: Bool {
        return !Calendar.current.isDateInWeekend(base)
    }
    
    /// Check if date is within the current week.
    var isInCurrentWeek: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// Check if date is within the current month.
    var isInCurrentMonth: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .month)
    }
    
    /// Check if date is within the current year.
    var isInCurrentYear: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .year)
    }
    
    /// - Parameters:
    ///   - timeInterval: 1551323716
    /// - Returns: 周四
    func weekDayForTimeInterval(timeInterval: TimeInterval) -> String {
        let dayArray = ["周日","周一","周二","周三","周四","周五","周六"]
        let date = Date(timeIntervalSince1970: timeInterval)
        let calendar: Calendar = Calendar.init(identifier: .gregorian)
        let components = calendar.component(.weekday, from: date)
        return dayArray[components - 1]
    }
}
