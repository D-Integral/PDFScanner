//
//  ScanningPresenter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import VisionKit

class ScanningPresenter: PresenterProtocol {
    
    // MARK: - Public Interface
    
    public var title: String {
        return String(localized: "scan")
    }
    
    public var isDocumentCameraSupported: Bool {
        return interactor.isDocumentCameraSupported
    }
    
    public init(interactor: ScanningInteractor) {
        self.interactor = interactor
    }
    
    public func documentCameraRouter() -> RouterProtocol {
        return interactor.documentCameraRouter()
    }
    
    public func add(dynamicUI: DynamicUIProtocol) {
        interactor.add(dynamicUI: dynamicUI)
    }
    
    public func remove(dynamicUI: DynamicUIProtocol) {
        interactor.remove(dynamicUI: dynamicUI)
    }
    
    // MARK: - Private Properties
    
    private let interactor: ScanningInteractor
    
}
