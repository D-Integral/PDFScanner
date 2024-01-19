//
//  DiskFile.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation

struct DiskFile: FileProtocol {
    
    // MARK: - Constants
    
    struct Constants {
        static let filesFolderTitle = "Files"
        static let thumbnailsFolderTitle = "Thumbnails"
    }
    
    // MARK: - Initializers
    
    init(title: String,
         documentData: Data? = nil,
         thumbnailData: Data? = nil,
         createdDate: Date,
         modifiedDate: Date,
         openedDate: Date? = nil,
         importedDate: Date? = nil,
         fileType: FileType = .pdfDocument) {
        self.title = title
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.openedDate = openedDate
        self.importedDate = importedDate
        self.fileType = fileType
        
        if let uniqueTitle = chooseUniqueTitleIfFileExists() {
            self.title = uniqueTitle
        }
        
        self.documentData = documentData
        self.thumbnailData = thumbnailData
    }
    
    // MARK: - Public Properties
    
    var id = UUID()
    
    var title: String
    
    var documentData: Data? {
        get {
            guard let url = documentDataUrl else { return nil }
            
            return try? Data(contentsOf: url)
        }
        
        set {
            guard let url = documentDataUrl else { return }
            guard let newValue = newValue else { return }
            
            do {
                try newValue.write(to: url)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    var documentDataUrl: URL? {
        return documentDataUrl(for: title)?.appendingPathExtension("pdf")
    }
    
    var thumbnailData: Data? {
        get {
            guard let url = thumbnailDataUrl else { return nil }
            
            return try? Data(contentsOf: url)
        }
        
        set {
            guard let url = thumbnailDataUrl else { return }
            guard let newValue = newValue else { return }
            
            do {
                try newValue.write(to: url)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    var thumbnailDataUrl: URL? {
        return thumbnailDataUrl(for: title)
    }
    
    var createdDate: Date
    var modifiedDate: Date
    var openedDate: Date?
    var importedDate: Date?
    var fileType: FileType
    
    // MARK: - Public Methods
    
    public func clearData() {
        if let documentDataUrl = documentDataUrl {
            try? FileManager.default.removeItem(at: documentDataUrl)
        }
        
        if let thumbnailDataUrl = thumbnailDataUrl {
            try? FileManager.default.removeItem(at: thumbnailDataUrl)
        }
    }
    
    func info() -> String? {
        return "\(modifiedDateInfo()) • \(documentDataSizeInfo())"
    }
    
    mutating func rename(to newName: String) {
        if newName == title {
            return
        }
        
        var newNameOrUniqueAlternative = newName
        
        if let originalTitle = chooseUniqueTitleIfFileExists(proposedTitle: newName) {
            newNameOrUniqueAlternative = originalTitle
        }
        
        guard let oldDocumentDataUrl = documentDataUrl(for: title)?.appendingPathExtension("pdf"),
              let newDocumentDataUrl = documentDataUrl(for: newNameOrUniqueAlternative)?.appendingPathExtension("pdf"),
              let oldThumbnailDataUrl = thumbnailDataUrl(for: title),
              let newThumbnailDataUrl = thumbnailDataUrl(for: newNameOrUniqueAlternative) else { return }
        
        moveItem(at: oldDocumentDataUrl, to: newDocumentDataUrl)
        moveItem(at: oldThumbnailDataUrl, to: newThumbnailDataUrl)
        
        title = newNameOrUniqueAlternative
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DiskFile, rhs: DiskFile) -> Bool {
        (lhs.id == rhs.id) && (lhs.title == rhs.title)
    }
    
    // MARK: - Comparable
    
    static func < (lhs: DiskFile, rhs: DiskFile) -> Bool {
        return lhs.comparableDate() < rhs.comparableDate()
    }
    
    // MARK: - Private Properties
    
    private var documentDirectoryUrl: NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        return urls.last as? NSURL
    }
    
    private func moveItem(at currentUrl: URL,
                          to newUrl: URL) {
        do {
            try FileManager.default.moveItem(at: currentUrl,
                                             to: newUrl)
        } catch {
            debugPrint(error)
        }
    }
    
    private func directoryUrl(forFolder folderTitle: String) -> NSURL? {
        guard let folderUrl = documentDirectoryUrl?.appendingPathComponent(folderTitle) as? NSURL,
              let path = folderUrl.path else { return nil }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        return folderUrl
    }
    
    private func documentDataUrl(for fileTitle: String) -> URL? {
        return directoryUrl(forFolder: Constants.filesFolderTitle)?.appendingPathComponent("\(fileTitle)") as? URL
    }
    
    private func thumbnailDataUrl(for fileTitle: String) -> URL? {
        return directoryUrl(forFolder: Constants.thumbnailsFolderTitle)?.appendingPathComponent("\(fileTitle)") as? URL
    }
    
    // MARK: - Private Functions
    
    private mutating func chooseUniqueTitleIfFileExists(proposedTitle: String? = nil,
                                                        addingIndex index: Int = 1) -> String? {
        var proposed = proposedTitle
        
        if nil == proposed {
            proposed = title
        }
        
        if let proposed = proposed,
           let baseUrl = documentDataUrl(for: proposed) {
            let pathEnd = (index > 1) ? " \(index)" : ""
            
            if FileManager.default.fileExists(atPath: baseUrl.path + pathEnd + ".pdf") {
                return chooseUniqueTitleIfFileExists(proposedTitle: proposedTitle,
                                                     addingIndex: index + 1)
            } else if (index > 1) {
                return baseUrl.lastPathComponent + pathEnd
            }
        }
        
        return nil
    }
    
    private func documentDataSizeInfo() -> String {
        guard let path = documentDataUrl?.path else {
            return ""
        }
        
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: path)
        let fileSize = fileAttributes?[FileAttributeKey.size] as? NSNumber ?? NSNumber(value: 0)
        let byteCountFormatter = ByteCountFormatter()
        
        byteCountFormatter.countStyle = .file
        
        return byteCountFormatter.string(fromByteCount: Int64(truncating: fileSize))
    }
    
    private func modifiedDateInfo() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: modifiedDate)
    }
    
    private func comparableDate() -> Date {
        if let openedDate = openedDate {
            return openedDate
        } else if let importedDate = importedDate {
            return importedDate
        }
        
        return modifiedDate
    }
}
