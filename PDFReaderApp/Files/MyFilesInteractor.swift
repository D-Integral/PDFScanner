//
//  MyFilesInteractor.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 30/12/2023.
//

import Foundation

class MyFilesInteractor: InteractorProtocol {
    
    // MARK: - Properties
    
    var files: [any FileProtocol]? {
        return fileStorage.files()
    }
    
    var userLogged: Bool {
        return accountManager.userLogged
    }
    
    private let fileStorage: FileStorageProtocol
    private let accountManager: AccountManagerProtocol
    
    // MARK: - Life Cycle
    
    init(fileStorage: FileStorageProtocol,
         accountManager: AccountManagerProtocol) {
        self.fileStorage = fileStorage
        self.accountManager = accountManager
    }
    
    // MARK: - File Management
    
    func deleteFile(withId fileId: UUID) {
        fileStorage.delete(fileId)
    }
    
    func sortedAndFilteredFiles(for queryOrNil: String?) -> [any FileProtocol] {
        return filteredFiles(for: queryOrNil).sorted { fileA, fileB in
            return fileA.modifiedDate > fileB.modifiedDate
        }
    }
    
    // MARK: - Sign In
    
    func signIn(withServiceProvider signInServiceProvider: SignInServiceProvider,
                completionHandler: @escaping (User?, Error?) -> ()) {
        
        accountManager.signIn(withServiceProvider: signInServiceProvider) { user, error in
            completionHandler(user, error)
        }
    }
    
    // MARK: - Private Functions
    
    private func filteredFiles(for queryOrNil: String?) -> [any FileProtocol] {
        guard let files = files else {
            return []
        }
        
        guard let query = queryOrNil,
              !query.isEmpty else {
            return files
        }
        
        return files.filter {
            return $0.name.lowercased().contains(query.lowercased())
        }
    }
}
