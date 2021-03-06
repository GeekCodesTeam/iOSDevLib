//
//  AppDelegate.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2020/12/18.
//

import UIKit
import IQKeyboardManagerSwift
import SLEmptyPage
import GDPerformanceView_Swift
import SLIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        whetherLoged()
        config(launchOptions)
        return true
    }
}

extension AppDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SLJGServicer.shared.registDeviceToken(deviceToken)
        SLUMServicer.shared.registDeviceToken(deviceToken)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if SLJGServicer.shared.handleOpenURL(url: url, options: options) == false {
            // 其他SDK的回调
        }
        if SLUMServicer.shared.handleOpenURL(url: url, options: options) == false {
            // 其他SDK的回调
        }
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if SLJGServicer.shared.handleUniversalLink(url: userActivity.webpageURL) == false {
            // 其他SDK的回调
        }
        if SLUMServicer.shared.handleUniversalLink(activity: userActivity) == false {
            // 其他SDK的回调
        }
        return true
    }
}

extension AppDelegate {

    private func whetherLoged() {
        window = UIWindow(frame: UIScreen.main.bounds)
        AccountServicer.service.isLogin ? goMainPage() : goLoginPage()
    }
    private func goMainPage() {
        window?.rootViewController = SLTabBar.customStyle()
        window?.makeKeyAndVisible()
        whetherGuide()
    }
    private func goLoginPage() {
        window?.rootViewController = BaseNavigationController(rootViewController: SLLoginViewController())
        window?.makeKeyAndVisible()
        whetherGuide()
    }
    private func whetherGuide() {
        GuideManager.showGuide()
    }

    private func config(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        SLDisplayModeManager.shared.setup()
        SLNetworkListenManager.shared.listen()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        SLHUD.loadingColor(R.color.prime())
        SLEmptyPageManager.enable = true
        SLEmptyPageManager.defaultEmptyViewBgColor = .clear
        
        SLUMServicer.shared.regist(AppKey_UM)
            .registAnalytics()
            .registPush(launchOptions)
            .registShare(wechatAppId: AppID_wechat, wechatAppSecret: AppSecret_wechat, universalLink: universalLink)
        
        SLJGServicer.shared
            .registAnalytics(AppKey_JG)
            .registShare(appKey: AppKey_JG, universalLink: universalLink, wechatAppId: AppID_wechat, wechatAppSecret: AppSecret_wechat)
            .registPush(appKey: AppKey_JG, launchOptions: launchOptions)
        
        SLBuglyServicer.shared.config(AppID_bugly)
        
        SLGaodeServicer.shared.regist(AppKey_gaode)
        
        AppPurchaseManager.shared.completeTransactions()
        
        #if DEBUG
        PerformanceMonitor.shared().start()
        PerformanceMonitor.shared().performanceViewConfigurator.options = [.performance, .memory]
        #endif
    }
}
