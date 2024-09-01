//
//  FileManager.swift
//  SPOK
//
//  Created by GoodDamn on 12/02/2024.
//

import Foundation

extension FileManager {
    
    static func temp(
        data: inout Data,
        exten: String
    ) -> URL {
        
        let dir = FileManager.default
            .temporaryDirectory
        
        let fileName = "123\(exten)"
        
        let url = dir.append(
            fileName
        )
        
        try? data.write(
            to: url
        )
        
        return url
    }
    
    
    static func delete(
        url: URL?
    ) {
        guard let url = url else {
            return
        }
        
        try? FileManager.default
            .removeItem(
                at: url
            )
    }
    
    func copy(
        fromDir: URL,
        fromFile: String,
        toDir: URL,
        toFile: String
    ) {
        copy(
            to: toDir.append(
                toFile
            ),
            from: fromDir.append(
                fromFile
            )
        )
    }
    
    func copy(
        to: URL,
        from: URL
    ) {
        guard let data = contents(
            atPath: from.pathh()
        ), !data.isEmpty else {
            return
        }
        
        createFile(
            atPath: to.pathh(),
            contents: data
        )
    }
    
}
