//
//  Weak.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/01/2024.
//

import Foundation

class Weak<T: AnyObject> {
    weak var value : T?
    
    init (value: T) {
        self.value = value
    }
}
