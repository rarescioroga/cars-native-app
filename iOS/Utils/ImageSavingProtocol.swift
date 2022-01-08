//
//  ImageSavingProtocol.swift
//  Cars
//
//  Created by user on 04.01.2022.
//

import Foundation

private let tempFolderName = "TemporaryFolder"

protocol ImageSavingProtocol {
    func save(imageData: Data, withName name: String) throws -> URL
    func clearAllTempFiles()
}

extension ImageSavingProtocol {

    func save(imageData: Data, withName name: String) throws -> URL {
        do {
            let imagePath = try getDocumentsTempFolder().appendingPathComponent(name)
            try imageData.write(to: imagePath)
            return imagePath
        } catch {
            throw AppError(domain: .persistenceReading, message: "")
        }
    }

    func clearAllTempFiles() {
        let fileManager = FileManager.default
        do {
            let tempFolderPath = try getDocumentsTempFolder().path
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + "/" + filePath)
            }
            print("Cleared successfully the temp folder")
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }

    // MARK: - Private functions

    private func getDocumentsTempFolder() throws -> URL {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let folderPath = documentsDirectory.appendingPathComponent(tempFolderName)
            if !fileManager.fileExists(atPath: folderPath.path) {
                do {
                    try fileManager.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
                    return folderPath
                } catch {
                    print("ERROR")
                }
            } else {
                return folderPath
            }
        }
        throw AppError(domain: .persistenceReading, message: "")
    }

}
