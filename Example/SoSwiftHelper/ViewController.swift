//
//  ViewController.swift
//  SoSwiftHelper
//
//  Created by wangteng6680 on 07/03/2020.
//  Copyright (c) 2020 wangteng6680. All rights reserved.
//

import UIKit
import SoSwiftHelper

class ViewController: UIViewController {

    let capture = SwiftCapture.init(style: .all)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var button = UIButton()
        button.so.addTargetEvent { (_) in
            
        }
        
        capture.setPerViewLayerSize(CGSize(width: UIScreen.so.mainScreenWidth,
                                           height: UIScreen.so.mainScreenHeight))
        view.layer.addSublayer(capture.perViewLayer)
        capture.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

