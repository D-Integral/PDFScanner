//
//  PDFFileStorageTests.swift
//  PDFReaderAppTests
//
//  Created by Dmytro Skorokhod on 30/12/2023.
//

import XCTest
@testable import PDF_Scanner
import PDFKit
import NefertitiFile

final class DiskFileStorageTests: XCTestCase {
    
    let testFileName = "CV Dmytro Skorokhod 2024 PDF"
    var testFileId: UUID? = nil
    var initialFileCount = 0
    var diskFileStorage: DiskFileStorage?

    override func setUpWithError() throws {
        diskFileStorage = DiskFileStorage()
    }

    override func tearDownWithError() throws {
        diskFileStorage = nil
        testFileId = nil
    }

    func testFileSavingAndDeleting() throws {
        defer {
            if let testFileId = testFileId {
                diskFileStorage?.delete(testFileId)
            }
            
            XCTAssertTrue(diskFileStorage?.filesCount == initialFileCount)
        }
        
        guard let fileUrl = Bundle.main.url(forResource: testFileName, withExtension: "pdf") else {
            XCTFail("The test PDF file URL is broken.")
            return
        }
        
        guard let testPdfDocument = PDFDocument(url: fileUrl) else {
            XCTFail("An attempt to initialize a test PDF document using the provided file URL has been unsuccessful.")
            return
        }
        
        let documentAttributes = testPdfDocument.documentAttributes
        let defaultDate = Date()
        let createdDate = documentAttributes?["CreationDate"] as? Date ?? defaultDate
        let modifiedDate = documentAttributes?["ModDate"] as? Date ?? defaultDate
        
        XCTAssertNotNil(testPdfDocument)
        
        guard let diskFileData = testPdfDocument.dataRepresentation() else {
            XCTFail("An attempt to convert the test PDF document into data has failed.")
            return
        }
        
        let diskFile = NefertitiFile(title: testFileName,
                                     documentData: diskFileData,
                                     createdDate: createdDate,
                                     modifiedDate: modifiedDate)
        XCTAssertNotNil(diskFile)
        
        testFileId = diskFile.id
        
        initialFileCount = diskFileStorage?.filesCount ?? -1
        
        do {
            try diskFileStorage?.save(diskFile)
        } catch {
            XCTFail("An attempt to save the PDF file to the storage has failed with error: \(error.localizedDescription)")
            return
        }
        
        XCTAssertTrue(diskFileStorage?.filesCount == initialFileCount + 1)
        
        let retrievedFile = diskFileStorage?.file(withId: diskFile.id)
        XCTAssertNotNil(retrievedFile)
        XCTAssertTrue(retrievedFile?.title == testFileName)
        XCTAssertNotNil(retrievedFile?.documentData)
        XCTAssertTrue(retrievedFile?.createdDate == createdDate)
        XCTAssertTrue(retrievedFile?.modifiedDate == modifiedDate)
        XCTAssertTrue(retrievedFile?.fileType == .pdfDocument)
        
        guard let data = retrievedFile?.documentData else {
            XCTFail("Data from saved file is nil")
            return
        }
        
        let pdfDocument = PDFDocument(data: data)
        XCTAssertNotNil(pdfDocument)
        XCTAssertTrue(pdfDocument?.pageCount == 5)
    }
    
}
