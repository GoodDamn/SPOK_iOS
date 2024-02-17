//
//  Storage.swift
//  SPOK
//
//  Created by Igor Alexandrov on 06.07.2022.
//

import Foundation
import UIKit
import SystemConfiguration

class StorageApp {
    
    private static let debugTag: String = "StorageApp:";
    
    public static let mUserDef = UserDefaults();
    
    static let historyKey = "history",
               likesKey = "like",
               recommendsKey = "recoms";
    
    public static let mDirCollection = "collection"
    
    public static let mDirCollectionSleep =
        "\(mDirCollection)/sleep"
    
    public static let mDirPreviews = "preview"
    public static let mDirContent = "content"
    
    public static func bundleFile(
        r: String?, exten: String?
    ) -> Data? {
        guard let fileUrl = Bundle.main.url(forResource: r, withExtension: exten) else {
            return nil;
        }
        
        do {
            return try Data(contentsOf: fileUrl);
        } catch {
            print(StorageApp.debugTag,error);
            return nil;
        }
    }
    
    
    public static func modifTime(
        path: String,
        time: Double
    ) {
        let d = Date(
            timeIntervalSince1970: time
        )
        
        let attr = [
            FileAttributeKey
                .creationDate: d
        ]
        
        try? FileManager
            .default
            .setAttributes(
                attr,
                ofItemAtPath: path
            )
    }
    
    public static func modifTime(
        path:String
    ) -> Double {
        
        let fm = FileManager
            .default
        
        let a = try? fm
            .attributesOfItem(
                atPath: path
            ) [
                FileAttributeKey
                    .creationDate
            ]
        
        return (a as? Date)?
            .timeIntervalSince1970 ?? 0;
    }
    
    public static func deleteCollection(
        _ dir: String,
        id: Int,
        lang: String = ""
    ) {
        delete(
            "\(mDirCollection)/\(dir)",
            toscs(
                id: id,
                lang: lang
            )
        )
    }
    
    public static func contentUrl(
        id: Int,
        lang: String = ""
    ) -> URL {
        return rootPath(
            append: mDirContent
        ).append(
            toskc(
                id: id,
                lang: lang
            )
        )
    }
    
    public static func content(
        id: Int,
        lang: String = ""
    ) -> Data? {
        return load(
            path: contentUrl(
                id: id,
                lang: lang
            )
        )
    }
    
    public static func content(
        id: Int,
        lang: String = "",
        data: inout Data?
    ) {
        StorageApp.save(
            file: toskc(
                id: id,
                lang: lang
            ),
            root: mDirContent,
            data: &data
        )
    }
    
    public static func previewUrl(
        id: Int,
        type: CardType,
        lang: String = ""
    ) -> URL {
        return rootPath(
            append: mDirPreviews
        ).append(
            tospc(
                id: id,
                type: type,
                lang: lang
            )
        )
    }
    
    public static func preview(
        id: Int,
        type: CardType,
        lang: String = ""
    ) -> FileSPC? {
        
        guard var d = StorageApp.load(
            path: previewUrl(
                id: id,
                type: type,
                lang: lang
            )
        ) else {
            return nil
        }
        
        return Extension
            .spc(&d)
        
    }
    
    public static func preview(
        id: Int,
        lang: String = "",
        type: CardType,
        data: inout Data?
    ) {
        StorageApp.save(
            file: tospc(
                id: id,
                type: type,
                lang: lang
            ),
            root: mDirPreviews,
            data: &data
        )
        
    }
    
    public static func collectionUrl(
        _ dir: String,
        fileName: String
    ) -> URL {
        return rootPath(
            append: "\(mDirCollection)/\(dir)"
        ).append(fileName)
    }
    
    public static func collection(
        _ dir: String,
        fileName: String
    ) -> FileSCS? {
        var d = StorageApp
            .load(
                path: collectionUrl(
                    dir,
                    fileName: fileName
                )
            )
        
        return Extension
            .scs(&d)
    }
    
    public static func collection(
        _ dir:String,
        id: Int,
        lang: String = ""
    ) -> FileSCS? {
        return collection(
            dir,
            fileName: toscs(
                id: id,
                lang: lang
            )
        )
    }
    
    public static func collection(
        _ dir: String,
        id: Int,
        lang: String = "",
        data: inout Data?
    ) {
        save(
            file: toscs(
                id: id,
                lang: lang
            ),
            root: "\(mDirCollection)/\(dir)",
            data: &data
        )
    }
    
    
    public static func mkdir(
        path: String
    ) {
        let fm = FileManager.default;
        
        if fm.fileExists(
            atPath: path
        ) {
            return
        }
        
        do {
            try fm.createDirectory(
                atPath: path,
                withIntermediateDirectories: true
            )
        } catch {
            print(debugTag, error)
        }
    }
    
    public static func urlContent(
        at path: String,
        onEachName: (String) -> Void
    ) {
        
        guard let d = try? FileManager
            .default
            .contentsOfDirectory(
                atPath: path
            ) else {
            return
        }
        
        for fileName in d {
            onEachName(fileName)
        }
    }
    
    public static func toskc(
        id: Int,
        lang: String = ""
    ) -> String {
        return "\(id)\(lang).skc"
    }
    
    public static func toscs(
        id: Int,
        lang: String = ""
    ) -> String {
        return "\(id)\(lang).scs"
    }
    
    public static func tospc(
        id: Int,
        type: CardType,
        lang: String = ""
    ) -> String {
        return "\(id)\(type)\(lang).spc"
    }
    
    public static func rootPath(
        append path: String
    ) -> URL {
        return FileManager
            .default
            .urls (
                for: .cachesDirectory,
                in: .userDomainMask
            )[0].append(path)
    }
    
    public static func file(
        path: String
    ) -> Data? {
        return FileManager
            .default
            .contents(
                atPath: path
            );
    }
    
    public static func exists(
        at path: String
    ) -> Bool {
        return FileManager
            .default
            .fileExists(
                atPath: path
            )
    }
    
    public static func delete(
        _ dir: String,
        _ file: String
    ) {
        let path = rootPath(
            append: dir
        ).append(file)
        
        try? FileManager
            .default
            .removeItem(at: path)
    }
    
    private static func mkfile(
        path: String,
        data: inout Data?
    ) {
        guard let data = data else {
            return
        }
        
        let fm = FileManager.default;
        
        if fm.fileExists(
            atPath: path
        ) {
            try? fm.removeItem(
                atPath: path
            )
        }
        
        fm.createFile(
            atPath: path,
            contents: data
        )
    }
    
    private static func save(
        file: String,
        root: String,
        data: inout Data?
    ) {
        let r = StorageApp.rootPath(
            append: root
        )
        
        StorageApp.mkdir(
            path: r.pathh()
        )
        
        let f = r.append(
            file
        )
        
        StorageApp.mkfile(
            path: f.pathh(),
            data: &data
        )
    }
    
    private static func load(
        path f: URL
    ) -> Data? {
        
        let fpath = f.pathh()
        print(debugTag, "load:" ,fpath)
        
        if !StorageApp.exists(
            at: fpath
        ) {
            return nil
        }
        
        guard let d = StorageApp
            .file(
                path: f.pathh()
            ) else {
            return nil
        }
        
        return d
    }
    
}
