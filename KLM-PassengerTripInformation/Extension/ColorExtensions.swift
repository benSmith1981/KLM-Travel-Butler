//
//  ColorExtensions.swift
//  KLM-PassengerTripInformation
//
//  Created by Michiel Everts on 28-11-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    //--------------------------------------------------------------------------
    // MARK: - Initializers
    //--------------------------------------------------------------------------
    
    convenience public init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
    
    convenience public init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff,
                  green:(netHex >> 8) & 0xff,
                  blue:netHex & 0xff)
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Public functions
    //--------------------------------------------------------------------------
    
    public func lighter(_ amount : CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 + amount)
    }
    
    public func darker(_ amount : CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 - amount)
    }
    
    public class func randomColor(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255))/255,
                       green: CGFloat(arc4random_uniform(255))/255,
                       blue: CGFloat(arc4random_uniform(255))/255,
                       alpha: alpha)
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Private functions
    //--------------------------------------------------------------------------
    
    fileprivate func hueColorWithBrightnessAmount(_ amount: CGFloat) -> UIColor {
        var hue = CGFloat(0.0)
        var saturation = CGFloat(0.0)
        var brightness = CGFloat(0.0)
        var alpha = CGFloat(0.0)
        
        if getHue(&hue,
                  saturation: &saturation,
                  brightness: &brightness,
                  alpha: &alpha) {
            return UIColor(hue: hue,
                           saturation: saturation,
                           brightness: brightness * amount,
                           alpha: alpha)
        }
        else {
            return self
        }
    }
    
    //--------------------------------------------------------------------------
    // MARK: - KLM Colors
    //--------------------------------------------------------------------------
    
    /// Black is only used as a transparant overlay with images. Never used for text.
    public class var klmBlack: UIColor {
        get {
            return UIColor(netHex:0x000000)
        }
    }
    
    /// Main brand color (especially when used with white) used for the logo, clickable headers, text links and small graphics (icons and such)
    public class var klmBlue: UIColor {
        get {
            return UIColor(netHex:0x00a1de)
        }
    }
    
    /// Used for non clickable headers
    public class var klmDarkBlue1: UIColor {
        get {
            return UIColor(netHex:0x005b82)
        }
    }
    
    /// Used for body text
    public class var klmDarkBlue2: UIColor {
        get {
            return UIColor(netHex:0x003145)
        }
    }
    
    /// Signal color, reserved for confirmation text, border and checkmark
    public class var klmGreen: UIColor {
        get {
            return UIColor(netHex:0x58a618)
        }
    }
    
    /// Used for low emphasis text, e.g. placeholders in forms, inactive links, etc.
    public class var klmGrey1: UIColor {
        get {
            return UIColor(netHex:0xb2b2b2)
        }
    }
    
    /// Used as default placeholder color for background images
    public class var klmGrey2: UIColor {
        get {
            return UIColor(netHex:0xdfdfdf)
        }
    }
    
    /// Used as background color neutral alternative to KLM Grey 3
    public class var klmGrey3: UIColor {
        get {
            return UIColor(netHex:0xeeeeee)
        }
    }
    
    /// Default low-contrast color, mostly used in borders and lines
    public class var klmLightBlue2: UIColor {
        get {
            return UIColor(netHex:0xc2deea)
        }
    }
    
    /// Default background color to emphasise content from white, e.g. expands, tables, bars, etc.
    public class var klmLightBlue3: UIColor {
        get {
            return UIColor(netHex:0xf3f8fb)
        }
    }
    
    /// Only used to further emphasise content on KLM Light Blue 3, e.g. bars in expands, hovers etc.
    public class var klmLightBlue4: UIColor {
        get {
            return UIColor(netHex:0xe7f2f7)
        }
    }
    
    /// Background color, only used in confirmation
    public class var klmLightGreen: UIColor {
        get {
            return UIColor(netHex:0xeefbe7)
        }
    }
    
    /// Background color, only used as active state in the calendar and in basic notification
    public class var klmLightYellow: UIColor {
        get {
            return UIColor(netHex:0xfff7d9)
        }
    }
    
    /// Signal color, reserved for discount prices, sctive states, most important call to actions and warnings.
    public class var klmOrange: UIColor {
        get {
            return UIColor(netHex:0xe37222)
        }
    }
    
    public class var klmDarkOrange: UIColor {
        return UIColor(netHex: 0xEF8B01)
    }
    
    /// Important signal color, reserved for errors and disruptions.
    public class var klmRed: UIColor {
        get {
            return UIColor(netHex:0xe00034)
        }
    }
    
    /// Important signal background color, reserved for errors and disruptions.
    public class var klmLightRed: UIColor {
        get {
            return UIColor(netHex:0xfbe5ea)
        }
    }
    
    /// Magenta color
    public class var klmMagenta: UIColor {
        get {
            return UIColor(netHex:0xC03086)
        }
    }
    
    /// White is used as the default background color. it provides space and readability.
    public class var klmWhite: UIColor {
        get {
            return UIColor(netHex:0xffffff)
        }
    }
    
    /// Signal color, reserved for active items one level below where orange is used. Not depricated, butvery rare ever since the introduction of the Calendar in Search 3.0. Please consider other options before using this color.
    public class var klmYellow: UIColor {
        get {
            return UIColor(netHex:0xfecb00)
        }
    }
    
    /// Notification color, reserved for information messages.
    public class var klmNotificationBlue: UIColor {
        get {
            return UIColor(netHex:0xe5f5fb)
        }
    }
    
    /// Gold color
    public class var klmGold: UIColor {
        get {
            return UIColor(netHex:0xbd852e)
        }
    }
    
    public class var klmCerulean: UIColor {
        return UIColor(red: 0,
                       green: 161,
                       blue: 222)
    }
    
    public class var klmSwitchGray: UIColor {
        return UIColor(red: 189,
                       green: 191,
                       blue: 191)
    }
    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }

    public class var marineBlue: UIColor {
        return UIColor(red: 0.0,
                       green: 69.0 / 255.0,
                       blue: 103.0 / 255.0,
                       alpha: 1.0)
    }
    
    public class var akBrownishOrange: UIColor {
        return UIColor(red: 227.0 / 255.0,
                       green: 114.0 / 255.0,
                       blue: 34.0 / 255.0,
                       alpha: 1.0)
    }
    
    public class var akSilver: UIColor {
        return UIColor(red: 189.0 / 255.0,
                       green: 191.0 / 255.0,
                       blue: 191.0 / 255.0,
                       alpha: 1.0)
        }
}
