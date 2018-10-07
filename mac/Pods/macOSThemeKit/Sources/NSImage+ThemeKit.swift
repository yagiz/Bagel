//
//  NSImage+ThemeKit.swift
//  ThemeKit
//
//  Converted to Swift 3 by Nuno Grilo on 02/10/2016.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

/*
 Based on original work from Mircea "Bobby" Georgescu from:
 http://www.bobbygeorgescu.com/2011/08/finding-average-color-of-uiimage/
 
 UIImage+AverageColor.m
 
 Copyright (c) 2010, Mircea "Bobby" Georgescu
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Mircea "Bobby" Georgescu nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL Mircea "Bobby" Georgescu BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Cocoa

extension NSImage {

    /// Find the average color in image.
    /// Not the most accurate algorithm, but probably got enough for the purpose.
    @objc internal func averageColor() -> NSColor {
        // setup a single-pixel image
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        guard let bitmapData = malloc(4),
            let context = CGContext(data: bitmapData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue),
            let cgImage = self.cgImage(forProposedRect: nil, context: NSGraphicsContext(cgContext: context, flipped: false), hints: nil) else {
            return NSColor.white
        }

        // draw the image into a 1x1 image
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))

        // extract byte colors from single-pixel image
        let red = bitmapData.load(fromByteOffset: 0, as: UInt8.self)
        let green = bitmapData.load(fromByteOffset: 1, as: UInt8.self)
        let blue = bitmapData.load(fromByteOffset: 2, as: UInt8.self)
        let alpha = bitmapData.load(fromByteOffset: 3, as: UInt8.self)

        // build "average color"
        let modifier = alpha > 0 ? CGFloat(alpha) / 255.0 : 1.0
        let redFloat: CGFloat = CGFloat(red) * modifier / 255.0
        let greenFloat: CGFloat = CGFloat(green) * modifier / 255.0
        let blueFloat: CGFloat = CGFloat(blue) * modifier / 255.0
        let alphaFloat: CGFloat = CGFloat(alpha) / 255.0

        return NSColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
    }

}
