//
//  String+Substring.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 06/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

extension String {

    /// Convenience subscript with Int to get character as Character.
    internal subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }

    /// Convenience subscript with Int to get character as String.
    internal subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    /// Convenience function to get substring Range<Int> instead of Range<Index>.
    internal subscript (r: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(self.startIndex, offsetBy: r.upperBound)

        return String(self[start...end])
    }

    /// Convenience function to get substring with NSRange.
    internal func substring(withNSRange: NSRange) -> String {
        guard withNSRange.location < self.count else { return "" }
        let start = self.index(self.startIndex, offsetBy: withNSRange.location)
        let end = self.index(start, offsetBy: withNSRange.length)
        let range = Range<String.Index>(uncheckedBounds: (lower: start, upper: end))
        return String(self[range])
    }

    /// Convenience function to replace characters with NSRange.
    internal func replacingCharacters(inNSRange: NSRange, with: String) -> String {
        guard inNSRange.location < self.count else { return "" }
        let start = self.index(self.startIndex, offsetBy: inNSRange.location)
        let end = self.index(start, offsetBy: inNSRange.length)
        let range = Range<String.Index>(uncheckedBounds: (lower: start, upper: end))
        return self.replacingCharacters(in: range, with: with)
    }

}
