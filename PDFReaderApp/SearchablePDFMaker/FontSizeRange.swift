//
//  FontSizeRange.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 13/01/2024.
//

import Foundation

struct FontSizeRange: FontSizeRangeProtocol {
    
    // MARK: - Public Interface
    
    public private(set) var minFontSize: CGFloat
    public private(set) var maxFontSize: CGFloat
    
    public var diff: CGFloat {
        return maxFontSize - minFontSize
    }
    
    init(minFontSize: CGFloat? = nil,
         maxFontSize: CGFloat,
         minFontScale: CGFloat = Constants.defaultMinFontScale) {
        self.maxFontSize = maxFontSize.isNaN ? Constants.defaultMaxFontSize : maxFontSize
        
        let reliableMinFontScale = minFontScale.isNaN ? Constants.defaultMinFontScale : minFontScale
        let defaultMinFontSize = maxFontSize * reliableMinFontScale
        
        if let minFontSize = minFontSize {
            self.minFontSize = minFontSize.isNaN ? defaultMinFontSize : minFontSize
        } else {
            self.minFontSize = defaultMinFontSize
        }
    }
    
    // MARK: - Private Definitions
    
    private struct Constants {
        static let defaultMaxFontSize = 100.0
        static let defaultMinFontScale = 0.1
        static let minFontSizeNotProvided = -1.0
    }
}
