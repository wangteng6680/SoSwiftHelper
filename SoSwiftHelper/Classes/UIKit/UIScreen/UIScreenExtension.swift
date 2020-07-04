//
//  SoSwiftSizeHelper.swift
//  Pods-SoSwiftHelper_Example
//
//  Created by mac on 2020/7/4.
//

import UIKit

public extension SoSwiftHelperWrapper where Core == UIScreen {
    
    /// UIScreen.main.bounds.width
    static var mainScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// UIScreen.main.bounds.height
    static var mainScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    /// 下方的安全区域位置
    ///
    /// - Returns:
    static var safeBottomInset: CGFloat {
        if UIScreen.so.statusBarHeight > 20 {
            return 34.0
        } else {
            return 0.0
        }
    }

    /// 状态栏高度+导航栏高度
    ///
    /// - Returns: 状态栏+导航栏 总高度
    static var statusBarNavigationBarHeight: CGFloat {
        return UIScreen.so.statusBarHeight + 44
    }

    /// 状态栏高度
    ///
    /// - Returns: 状态栏高度
    static var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = UIApplication.shared.windows.last?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 20
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height;
        }
        return statusBarHeight
    }

    /// 导航栏高度
    ///
    /// - Returns: 导航栏高度
    static var navigationBarHeight: CGFloat {
        return 44
    }
    
    static var keyWindow: UIWindow? {
        guard let appDelegate = UIApplication.shared.delegate else {
            return nil
        }
        return appDelegate.window ?? nil
    }

}
