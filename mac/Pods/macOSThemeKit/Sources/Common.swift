//
//  Common.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 14/10/2016.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

func CacheKey(selector: Selector) -> NSNumber {
    return CacheKey(selector: selector, colorSpace: nil, theme: nil)
}

func CacheKey(selector: Selector, colorSpace: NSColorSpace?) -> NSNumber {
    return CacheKey(selector: selector, colorSpace: colorSpace, theme: nil)
}

func CacheKey(selector: Selector, theme: Theme?) -> NSNumber {
    return CacheKey(selector: selector, colorSpace: nil, theme: theme)
}

func CacheKey(selector: Selector, colorSpace: NSColorSpace?, theme: Theme?) -> NSNumber {
    let hashValue = selector.hashValue + (colorSpace == nil ? 0 : (colorSpace!.hashValue << 4)) + (theme == nil ? 0 : (theme!.hash << 8))
    return NSNumber(value: hashValue)
}
