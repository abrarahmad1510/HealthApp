//
//  Util.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import Foundation
import UIKit
import HealthKit

extension UIImage {
    static func sfSymbol(_ symbolName: String, color: UIColor) -> UIImage {
        guard let symbolImage = UIImage(systemName: symbolName) else { return UIImage() }
        let coloredImage = symbolImage.withTintColor(color, renderingMode: .alwaysOriginal)
        return coloredImage
    }
}

extension UIStoryboard {
    static func getViewControllerWith(identifier: String) -> UIViewController? {
        UIStoryboard().instantiateViewController(withIdentifier: identifier)
    }
}

extension UINavigationItem {
    func setCircularImage(image: UIImage, rigthItem: Bool) {
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 40, 40)
        
        UIGraphicsBeginImageContextWithOptions(button.frame.size, false, image.scale)
        let rect  = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)
        UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2).addClip()
        image.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        let color = UIColor(patternImage: newImage)
        button.backgroundColor = color
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        let barButton = UIBarButtonItem()
        barButton.customView = button
        self.rightBarButtonItem = barButton
    }
}

extension UIImageView {
    func setCircularImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

extension UINavigationController {
    func cleanNavigation() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = .clear
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func defaultNavigation() {
        self.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationBar.shadowImage = nil
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = nil
    }
    
    func setMinimalBackButton() {
        self.navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}

extension UIEdgeInsets {
    mutating func removeSeparator() {
        self = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    
    mutating func addSeparator() {
        self = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}

extension Date {
    static var today: Date? {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self.init())
    }
    
    func differenceBetween(date: Date) -> (hours: Int, minutes: Int)? {
        let firstDate = self
        let seconDate = date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: firstDate, to: seconDate)
        guard let hours = components.hour,
              let minutes = components.minute else { return nil }
        
        return (hours, minutes)
    }
    
    func isOnSameDayThan(date: Date) -> Bool {
        let calendar = Calendar.current

        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date)

        return components1.year == components2.year &&
               components1.month == components2.month &&
               components1.day == components2.day
    }
    
    func onPast(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: -days, to: self)
    }
    
    var longDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
    
    var twelveHoursFormmatedHour: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from: self)
    }
    
    var abbreviatedMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    var shortDateWithYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
    
    var ISO8601WithwithFractionalSeconds: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return isoFormatter.string(from: self)
    }
}

extension String {
    static var empty: String{
        return String()
    }
}

extension UIFont {
    enum FontVariation: String {
        case light = "Light"
        case medium = "Medium"
        case bold = "Bold"
    }
}

extension UIViewController {
    var safeAreaHeight: CGFloat {
        let safeAreaTopInset = view.safeAreaInsets.top
        let safeAreaBottomInset = view.safeAreaInsets.bottom
        return view.bounds.height - safeAreaTopInset - safeAreaBottomInset
    }
    
    func showFloatingAlert(text: String, alertType: AlertType = . defaultAlert) {
        let alertView = FloatingAlertView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        alertView.configure(text: text, alertType: alertType)
        switch alertType {
        case .defaultAlert:
            alertView.backgroundColor = .systemBackground
        case .success:
            alertView.backgroundColor = .green
        case .warning:
            alertView.backgroundColor = .yellow
        case .error:
            alertView.backgroundColor = .red
        }
        
        self.view.addSubview(alertView)
        self.view.bringSubviewToFront(alertView)
        alertView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            alertView.widthAnchor.constraint(equalToConstant: 300),
            alertView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    static func topMostViewController() -> UIViewController? {
        guard let activeScene = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).first as? UIWindowScene,
              let keyWindow = activeScene.windows.first(where: { $0.isKeyWindow }),
              let rootViewController = keyWindow.rootViewController else { return nil }
        return topMostViewController(from: rootViewController)
    }
    
    private static func topMostViewController(from viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController {
            return topMostViewController(from: presentedViewController)
        } else if let navigationController = viewController as? UINavigationController,
                    let visibleViewController = navigationController.visibleViewController {
            return topMostViewController(from: visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController,
                    let selectedViewController = tabBarController.selectedViewController {
            return topMostViewController(from: selectedViewController)
        } else {
            return viewController
        }
    }
}

extension Int {
    static var aDay: Int { return 1 }
    static var week: Int { return 7 }
    static var year: Int { return 365 }
    func toRomanNumeral() -> String? {
        guard self > 0 && self < 4000 else {
            return nil
        }
        
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        
        let romanNumeral = arabicValues.enumerated().reduce(("", self)) { (result, pair) in
            var (roman, remaining) = result
            let (index, arabicValue) = pair
            while remaining >= arabicValue {
                roman += romanValues[index]
                remaining -= arabicValue
            }
            return (roman, remaining)
        }.0
        
        return romanNumeral
    }
}

extension Data {
    init(from integer: Int) {
        var int = integer
        self = Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
    
    static func toInteger(data: Data) -> Int {
        return data.withUnsafeBytes { $0.load(as: Int.self) }
    }
}

extension UIButton {
    private struct AssociatedKeys {
        static var activityIndicator: UInt8 = 0
        static var originalTitle: UInt8 = 0
    }

    private var activityIndicator: UIActivityIndicatorView? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func showLoading() {
        activityIndicator?.removeFromSuperview()
        let newActivityIndicator = UIActivityIndicatorView(style: .medium)
        newActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newActivityIndicator)

        let indicatorHeight = 20.0
        let indicatorWidth = 20.0

        NSLayoutConstraint.activate([
            newActivityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            newActivityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            newActivityIndicator.heightAnchor.constraint(equalToConstant: CGFloat(indicatorHeight)),
            newActivityIndicator.widthAnchor.constraint(equalToConstant: CGFloat(indicatorWidth))
        ])

        newActivityIndicator.startAnimating()
        self.setTitle("", for: .normal)
    }

    func hideLoading(title: String) {
        activityIndicator?.stopAnimating()
        self.setTitle(title, for: .normal)
    }
}

extension DateFormatter {
    static let appointmentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let container = try $0.singleValueContainer()
        let dateString = try container.decode(String.self)
        if let date = DateFormatter.appointmentDateFormatter.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        }
    }
}

extension UIColor {
    static func colorFrom(skinType: HKFitzpatrickSkinType) -> UIColor {
        switch skinType {
        case .notSet:
            return .clear
        case .I:
            return UIColor(red: 1.00, green: 0.90, blue: 0.80, alpha: 1.0)
        case .II:
            return UIColor(red: 0.98, green: 0.82, blue: 0.70, alpha: 1.0)
        case .III:
            return UIColor(red: 0.80, green: 0.67, blue: 0.54, alpha: 1.0)
        case .IV:
            return UIColor(red: 0.60, green: 0.48, blue: 0.39, alpha: 1.0)
        case .V:
            return UIColor(red: 0.45, green: 0.34, blue: 0.28, alpha: 1.0)
        case .VI:
            return UIColor(red: 0.29, green: 0.24, blue: 0.20, alpha: 1.0)
        @unknown default:
            return UIColor.clear
        }
    }
}
