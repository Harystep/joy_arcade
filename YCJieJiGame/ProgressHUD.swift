//
//  ViewExt.swift
//  JQProgressHUD
//
//  Created by dusmit on 2021/5/26.
//  Copyright © 2021 巨擎网络科技(济南)有限公司. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

public extension UIView {
    
    /// 显示加载动画
    func showWait(_ title: String) {
        
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
    }
    
    func showWaitDelay(_ delay:TimeInterval = 1.5) {
        
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.label.text = ""
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: delay)
    }

    /// 隐藏加载动画
    func hide() { MBProgressHUD.hide(for: self, animated: true) }
    
    /// KeyWindow 上显示消息
    func showCustomInfoWindow(_ title: String, delay: TimeInterval = 1.5) {
        
        self.showHUD(title: title, mode: .customView, delay: delay, superView: UIApplication.shared.keyWindow)
    }

    /// 显示成功消息
    func showSuccess(_ title: String, delay: TimeInterval = 1) {
        
        self.showHUD(title: title, mode: .customView, delay: delay)
    }

    /// 显示失败消息
    func showError(_ title: String, delay: TimeInterval = 2) {

        self.showHUD(title: title, mode: .text, delay: delay)
    }
    
    /// 自定义显示消息
    func showHUD(title: String, mode: MBProgressHUDMode = .customView, delay: TimeInterval = 2.5, icon: String = "", superView: UIView? = nil) {
        
        let hud = MBProgressHUD.showAdded(to: superView ?? self, animated: true)
        hud.label.text = title
        hud.mode = mode
        if !icon.isEmpty { hud.customView = UIImageView(image: UIImage(named: icon)) }
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: delay)
    }
    
    /// 连接AppStore
    func showAppStoreHUD(title: String, superView: UIView? = nil) {
        
        let hud = MBProgressHUD.showAdded(to: superView ?? self, animated: true)
        hud.label.text = title
        hud.label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        hud.mode = .indeterminate
        hud.removeFromSuperViewOnHide = true
        hud.animationType = .fade
        hud.margin = 35
    }
}
