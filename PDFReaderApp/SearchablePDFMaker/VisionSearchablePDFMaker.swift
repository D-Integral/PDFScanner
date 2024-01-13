//
//  SearchablePDFMaker.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 13/01/2024.
//

import Foundation
import UIKit
import Vision

class VisionSearchablePDFMaker: PDFMakerProtocol {
    public func generatePdfDocumentFile(from documentImages: [UIImage],
                                        completionHandler: @escaping ((any FileProtocol)?, Error?) -> ()) -> ()? {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let dispatchGroup = DispatchGroup()
            var allRecognizedTexts = [RecognizedTextProtocol]()
            
            for (index, documentImage) in documentImages.enumerated() {
                dispatchGroup.enter()
                let sourcePage = PDFMakerSourcePage(image: documentImage,
                                                    pageNumber: index)
                
                self?.recognizeText(from: sourcePage) { currentRecognizedTexts, error  in
                    if let error = error {
                        print(error)
                        dispatchGroup.leave()
                        return
                    }
                    
                    guard let currentRecognizedTexts = currentRecognizedTexts else {
                        dispatchGroup.leave()
                        return
                    }
                    
                    allRecognizedTexts.append(contentsOf: currentRecognizedTexts)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completionHandler(nil, nil)
            }
        }
    }
    
    private func recognizeText(from sourcePage: PDFMakerSourcePageProtocol,
                               completionHandler: @escaping ([RecognizedTextProtocol]?, Error?) -> ()) {
        guard let cgImage = sourcePage.image.cgImage else {
            completionHandler(nil,
                              PDFMakerError.canNotTransformUIImageIntoCGImage)
            return
        }
        
        var recognizedTexts: [RecognizedTextProtocol] = []
        
        let recognizeTextRequest = recognizeTextRequest(for: sourcePage.pageNumber) { recognizedText, error in
            guard let recognizedText = recognizedText else { return }
            
            if let error = error {
                print(error)
                return
            }
            
            recognizedTexts.append(recognizedText)
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                   options: [:])
        
        do {
            try requestHandler.perform([recognizeTextRequest])
        } catch {
            completionHandler(nil, error)
            return
        }
         
        completionHandler(recognizedTexts, nil)
    }
    
    private func recognizeTextRequest(for pageNumber: Int,
                                      completionHandler: @escaping (RecognizedTextProtocol?, Error?) -> ()) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                completionHandler(nil, error)
                
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let maximumRecognitionCandidates = 1
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }
                
                let recognizedText = VisionRecognizedText(pageNumber: pageNumber,
                                                          recognizedText: topCandidate)
                
                completionHandler(recognizedText, nil)
            }
        }
        
        request.recognitionLevel = .accurate
        
        return request
    }
}
