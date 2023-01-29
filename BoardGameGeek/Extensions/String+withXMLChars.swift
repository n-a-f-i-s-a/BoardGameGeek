//
//  String+withXMLChars.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 28/1/2023.
//

import Foundation

extension String {

    func removeXML() -> String {
        return self.replacingOccurrences(of: "&lt;br/&gt;", with: "\n")
            .replacingOccurrences(of: "&amp;mdash;", with: "-")
            .replacingOccurrences(of: "&#10;", with: "\n")
            .replacingOccurrences(of: "&mdash;", with: " - ")
            .replacingOccurrences(of: "&amp;ndash;", with: " - ")
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;quot;", with: "'")
            .replacingOccurrences(of: "&ldquo;", with: "'")
            .replacingOccurrences(of: "&rdquo", with: "'")
            .replacingOccurrences(of: "&amp;rdquo", with: "'")
            .replacingOccurrences(of: "&rsquo", with: "'")
            .replacingOccurrences(of: "&amp;rsquo", with: "'")
            .replacingOccurrences(of: "&#239;", with: "a")
            .replacingOccurrences(of: "&#130;", with: "f")
            .replacingOccurrences(of: "&#128;", with: "€")
            .replacingOccurrences(of: "&#172", with: "u")
            .replacingOccurrences(of: "&ugrave;", with: "u")
            .replacingOccurrences(of: "&#197;", with: "o")
            .replacingOccurrences(of: "&#141;", with: "n")
            .replacingOccurrences(of: "&ntilde;", with: "n")
            .replacingOccurrences(of: "à", with: "a")
            .replacingOccurrences(of: "&amp;auml;", with: "a")
            .replacingOccurrences(of: "&amp;ouml", with: "o")
            .replacingOccurrences(of: "º", with: "#")
            .replacingOccurrences(of: "&amp;amp;", with: "and")
            .replacingOccurrences(of: "–", with: "-")
            .replacingOccurrences(of: "<br/>", with: "")
            .replacingOccurrences(of: "&quot;", with: "")
            .replacingOccurrences(of: "1&quot;", with: "")
    }
    
}
