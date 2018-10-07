//
//  NSObject+ThemeKit.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 24/09/2016.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

extension NSObject {

    /// Swizzle instance methods.
    @objc internal class func swizzleInstanceMethod(cls: AnyClass?, selector originalSelector: Selector, withSelector swizzledSelector: Selector) {
        guard cls != nil else {
            print("Unable to swizzle \(originalSelector): dynamic system color override will not be available.")
            return
        }

        // methods
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)

        // add new method
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

        // switch implementations
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }

    /// Returns class method names.
    @objc internal class func classMethodNames(for cls: AnyClass?) -> [String] {
        var results: [String] = []

        // retrieve class method list
        var count: UInt32 = 0
        if let methods: UnsafeMutablePointer<Method> = class_copyMethodList(object_getClass(cls), &count) {

            // iterate class methods
            for i in 0..<count {
                let name = NSStringFromSelector(method_getName(methods[Int(i)]))
                results.append(name)
            }

            // release class methods list
            free(methods)
        }

        return results
    }

    /// Returns class list.
    @objc internal static func classList() -> [AnyClass] {
        var results: [AnyClass] = []

        // class count
        let expectedCount: Int32 = objc_getClassList(nil, 0)

        // retrieve class list
        let buffer = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedCount))
        let realCount: Int32 = objc_getClassList(AutoreleasingUnsafeMutablePointer<AnyClass>(buffer), expectedCount)

        // iterate classes
        for i in 0..<realCount {
            if let cls: AnyClass = buffer[Int(i)] {
                results.append(cls)
            }
        }

        // release buffer
        buffer.deallocate()

        return results
    }

    /// Returns classes implementing specified protocol.
    @objc internal static func classesImplementingProtocol(_ aProtocol: Protocol) -> [AnyClass] {
        let classes = classList()
        var results = [AnyClass]()

        // iterate classes
        for cls in classes {
            if class_conformsToProtocol(cls, aProtocol) {
                results.append(cls)
            }
        }

        return results
    }

}
