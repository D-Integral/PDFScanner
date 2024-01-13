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
    var fontSizeCalculator: FontSizeCalculatorProtocol
    
    init(fontSizeCalculator: FontSizeCalculatorProtocol = FontSizeCalculator()) {
        self.fontSizeCalculator = fontSizeCalculator
    }
    
    public func generatePdfDocumentFile(from documentImages: [UIImage],
                                        completionHandler: @escaping ((any FileProtocol)?, Error?) -> ()) -> ()? {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let dispatchGroup = DispatchGroup()
            let file: DiskFile? = nil
            var scanResults = [PDFMakerScanResult]()
            
            for (index, documentImage) in documentImages.enumerated() {
                dispatchGroup.enter()
                let sourcePage = PDFMakerSourcePage(image: documentImage,
                                                    pageNumber: index)
                
                self?.recognizeText(from: sourcePage) { [weak self] recognizedTexts, error  in
                    if let error = error {
                        print(error)
                        dispatchGroup.leave()
                        return
                    }
                    
                    guard let recognizedTexts = recognizedTexts else {
                        dispatchGroup.leave()
                        return
                    }
                    
                    let data = UIGraphicsPDFRenderer().pdfData { [weak self] context in
                        guard let pageRect = self?.pdfPageSize(for: sourcePage) else { return }
                        
                        let drawContext = context.cgContext
                        
                        context.beginPage(withBounds: pageRect,
                                          pageInfo: [:])
                        
                        recognizedTexts.forEach { recognizedText in
//                            guard let recognizedText = recognizedText as? VisionRecognizedText else { continue }
//                            self.writeTextOnTextBoxLevel(recognizedText: recognizedText.recognizedText,
//                                                         on: drawContext,
//                                                         bounds: pageRect)
                        }
                        
//                        self?.draw(image: sourcePage.image.cgImage,
//                                   on: drawContext,
//                                   withSize: pageRect)
                    }
                    
                    let scanResult = PDFMakerScanResult(data: data, pageNumber: sourcePage.pageNumber)
                    
                    scanResults.append(scanResult)
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.wait()
            
            let sortedScanResults = scanResults.sorted { left, right in
                left.pageNumber < right.pageNumber
            }
            
            DispatchQueue.main.async {
                completionHandler(file, nil)
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
    
    func pdfPageSize(for sourcePage: PDFMakerSourcePageProtocol) -> CGRect {
        let pageWidth = sourcePage.image.size.width
        let pageHeight = sourcePage.image.size.height
        
        return CGRect(x: 0,
                      y: 0,
                      width: pageWidth,
                      height: pageHeight)
    }
    
    func pdfDocumentData(from images: [UIImage]) -> Data {
        let data = UIGraphicsPDFRenderer().pdfData { context in
            let drawContext = context.cgContext
        }
        
        return data
    }
}
