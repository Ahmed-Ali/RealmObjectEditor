//
//  StringExtension.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/15/15.
//  Copyright (c) 2014 Ahmed Ali. Eng.Ahmed.Ali.Awad@gmail.com.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the contributor can not be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
//  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//  OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation

extension String{
    /**
    Very simple method converts the last characters of a string to convert from plural to singular. For example "praties" will be changed to "party" and "stars" will be changed to "star"
    The method does not hanle any special cases, like uncountable name i.e "people" will not be converted to "person"
    */
    func toSingular() -> String
    {
        var singular = self
        let length = self.count
        if length > 3{
            let range = self.index(endIndex, offsetBy: -3) ..< endIndex
            let lastThreeChars = self[range]
            if lastThreeChars == "ies" {
                singular = self.replacingOccurrences(of: lastThreeChars, with: "y", options: [], range: range)
            }
            
        }
        if length > 2{
            let range = self.index(endIndex, offsetBy: -1) ..< endIndex
            let lastChar = self[range]
            if lastChar == "s" {
                singular = self.replacingOccurrences(of: lastChar, with: "", options: [], range: range)
            }
        }
        return singular
    }
    
    /**
    Converts the first character to its lower case version
    
    - returns: the converted version
    */
    func lowercaseFirstChar() -> String{
        let range = startIndex ..< self.index(startIndex, offsetBy: 1)
        let firstLowerChar = self[range].lowercased()
        return self.replacingCharacters(in: range, with: firstLowerChar)
    }
    
    /**
    Converts the first character to its upper case version
    
    - returns: the converted version
    */
    func uppercaseFirstChar() -> String{
        let range = startIndex ..<  self.index(startIndex, offsetBy: 1)

        let firstUpperChar = self[range].uppercased()
        
        return self.replacingCharacters(in: range, with: firstUpperChar)
    }

    
    func getUppercaseOfFirstChar() -> String
    {
        return lastCharacter().uppercased()
    }
    
    func lastCharacter() -> String
    {
        let range = startIndex ..< self.index(startIndex, offsetBy: 1)
        return String(self[range])
    }
    
    
    mutating func replace(_ str: String, by replacement: String)
    {
        self = self.replacingOccurrences(of: str, with: replacement)
    }
}
