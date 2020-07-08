//
//  NIOBase.swift
//  NIOFD
//
//  Created by Teng Wang 王腾 on 2019/11/12.
//  Copyright © 2019 Teng Wang 王腾. All rights reserved.
//
import UIKit

public class SoSwiftHelperWrapper<Core> {
    var base: Core
    init(_ core: Core) {
        self.base = core
    }
}

public protocol SoSwiftHelperWrapperProperty {
    
}

public extension SoSwiftHelperWrapperProperty {
    
    var so: SoSwiftHelperWrapper<Self> {
        set { }
        get {SoSwiftHelperWrapper(self)}
    }
    
    static var so: SoSwiftHelperWrapper<Self>.Type {
        set { }
        get {SoSwiftHelperWrapper<Self>.self}
    }
}

/// Foundation
extension String: SoSwiftHelperWrapperProperty {
    
}

extension Array: SoSwiftHelperWrapperProperty {
    
}

extension Date: SoSwiftHelperWrapperProperty {
    
}

extension DispatchQueue: SoSwiftHelperWrapperProperty {
    
}

/// UIKit
extension UIDevice: SoSwiftHelperWrapperProperty {
    
}

extension UIImage: SoSwiftHelperWrapperProperty {
    
}


extension UIColor: SoSwiftHelperWrapperProperty {
    
}

extension UIScreen: SoSwiftHelperWrapperProperty {
    
}

extension UIView: SoSwiftHelperWrapperProperty {
    
}

extension UIApplication: SoSwiftHelperWrapperProperty {
    
}
