
//
//  NIOString.swift
//  NIOFD
//
//  Created by Teng Wang 王腾 on 2019/11/12.
//  Copyright © 2019 Teng Wang 王腾. All rights reserved.
//
import Foundation

// MARK: - Convert
public extension SoSwiftHelperWrapper where Core == String {
    
    /// NIOBase: String Convert Float, if convert fail, defaultValue is return value
    ///
    ///     "1.23".so.toFloat(3.0) // 1.23
    ///     "1.2a".so.toFloat(3.0) // 3.0
    ///
    /// - Parameter defaultValue: if convert float fail, defaultValue is return value
	func toFloat(_ defaultValue: Float = 0.0) -> Float {
        return Float(base) ?? defaultValue
    }
    
    /// NIOBase: String Convert Optional(Float)
    ///
    ///     "1.23".so.toFloat // Optional(1.23)
    ///     "1.2a".so.toFloat // nil
    var toFloat: Float? {
        return Float(base)
    }
    
    /// NIOBase: String Convert Int, if convert fail, defaultValue is return value
    ///
    ///     "1".so.toInt(3) // 1
    ///     "1.2a".so.toInt(3) // 3
    ///     "1.20".so.toInt(3) // 3
    ///
    /// - Parameter defaultValue: if convert fail, defaultValue is return value
    func toInt(_ defaultValue: Int = 0) -> Int {
        return Int(base) ?? defaultValue
    }
    
    /// NIOBase: String Convert Optional(Int)
    ///
    ///     "1".so.toInt // Optional(1)
    ///     "1.2a".so.toInt // nil
    ///     "1.2".so.toInt // nil
    ///
    var toInt: Int? {
        return Int(base)
    }
    
    /// NIOBase: String Convert Double, if convert fail, defaultValue is return value
    ///
    ///     "1".so.toDouble(3) // 1.0
    ///     "1.2a".so.toDouble(3) // 3.0
    ///     "1.2".so.toDouble(3) // 1.2
    ///
    /// - Parameter defaultValue: if convert fail, defaultValue is return value
	func toDouble(_ defaultValue: Double = 0.0) -> Double {
        return Double(base) ?? defaultValue
    }
    
    /// NIOBase: String Convert Optional(Double)
    ///
    ///     "1".so.toDouble // Double(1.0)
    ///     "1.2a".so.toDouble // nil
    ///     "1.2".so.toDouble // Double(1.2)
    ///
    var toDouble: Double? {
        return Double(base)
    }
    
    /// NIOBase: Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
    ///
    ///     "2007-06-29 14:23:09".so.dateTime -> Optional(Date)
    ///
    /// - Parameter dateFormat: yyyy-MM-dd HH:mm:ss
    func toDate(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let selfLowercased = trim.lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = dateFormat
        return formatter.date(from: selfLowercased)
    }

	/// yyyy-MM-dd HH:mm:ss
    var nowDateFormat: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    /// NIOBase: String Convert Bool
    ///
    ///     "1".so.toBool // Optional(true)
    ///     "true".so.toBool // Optional(true)
    ///     "flase".so.toBool // Optional(false)
    ///     "1a".so.toBool // nil
    ///
    func toBool() -> Bool? {
        let lower = trim.lowercased()
        if ["true", "1"].contains(lower) {
            return true
        } else if ["false", "0"].contains(lower) {
            return false
        } else {
            return nil
        }
    }
    
    /// NIOBase: String Convert Optional(URL)
    ///
    ///     "http://www.google.com".nioBase.toUrl // Optional("http://www.google.com")
    ///     "1.2a".so.toUrl // nil
    ///
    var toUrl: URL? {
        return URL(string: base)
    }
    
    /// NIOBase: String Convert URL, if convert fail, defaultValue is return value
    ///
    ///     "http://www.google.com".nioBase.toUrl("http://www.baidu.com") // "http://www.google.com"
    ///     "xz13".so.toUrl("http://www.baidu.com") // "http://www.baidu.com"
    ///
    /// - Parameter defaultValue: if convert fail, defaultValue is return value
    func toUrl(_ defaultValue: URL) -> URL {
        return URL(string: base) ?? defaultValue
    }
    
    /// NIOBase: Removes spaces and new lines in beginning and end of string.
    ///
    ///     var str = "  \n Hello World \n\n\n"
    ///     str = str.nio.trim
    ///     print(str) // prints "Hello World"
    ///
    var trim: String {
        return base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// NIOBase: Check if string is valid email format.
    ///
    ///     "john@doe.com".so.isEmail -> true
    ///
    var isEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return matches(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }
    
    /// Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    func matches(pattern: String) -> Bool {
        return base.range(of: pattern,
                             options: String.CompareOptions.regularExpression,
                             range: nil, locale: nil) != nil
    }

	/// 转换成拼音
	func phonetic() -> String {
		let mutableString = NSMutableString(string: base)
		CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
		CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
		let string = String(mutableString)
		return string.replacingOccurrences(of: " ", with: "")
	}

	/// 替换手机号中间四位
	///
	/// - Returns: 替换后的值
	func replacePhone() -> String {
		/// 字符串为空
		if base.startIndex == base.endIndex { return base }
		if base.count < 3 || base.count < 7 { return base }
		let start = base.index(base.startIndex, offsetBy: 3)
		let end = base.index(base.startIndex, offsetBy: 7)
		let range = Range(uncheckedBounds: (lower: start, upper: end))
		return base.replacingCharacters(in: range, with: "****")
	}
}


