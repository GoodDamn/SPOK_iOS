//
//  Storage.swift
//  SPOK
//
//  Created by Igor Alexandrov on 06.07.2022.
//

import Foundation
import UIKit
import SystemConfiguration

class StorageApp{
    
    private static let debugTag: String = "SPOkStorage: ";
    
    static let historyKey = "history",
        likesKey = "like",
        recommendsKey = "recoms";
    
    // Children
    static let mCardChild = "M",
               bCardChild = "B";
    
    static func mkdir(path:String) -> Void{
        let fileManager = FileManager.default;
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true);
            } catch {
                print(debugTag, error);
            }
        }
    }
    
    public static func mkfile(path:String, data:Data?)-> Void{
        let fileManager = FileManager.default;
        if fileManager.fileExists(atPath: path) {
            return;
        }
        guard let data = data else {
            return;
        }
        print("mkfile:",path,fileManager.fileExists(atPath: path));
        fileManager.createFile(atPath: path, contents: data);
    }
    
    public static func getFile(path:String,_ manager: FileManager)->Data?{
        return manager.contents(atPath: path);
    }
    
    static func getURL(dir: String)-> URL {
        let dirPath = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(dir, isDirectory: true);
        StorageApp.mkdir(path: dirPath.path);
        return dirPath;
    }
    
    class Topic {
        
        static func getTopicsURL()->URL {
            return getURL(dir: "topics");
        }
        
        static func fileManipulation(path:String,action:((FileManager, String)->Void))->Void{
            let manager = FileManager.default;
            let url = getTopicsURL().appendingPathComponent(path, isDirectory: false);
            action(manager,url.path);
        }
        
        private static func getString(p:String)->String?{
            var name: String? = nil;
            fileManipulation(path: p, action: {
                manager, url in
                if manager.fileExists(atPath: url){
                    name = String(data: StorageApp.getFile(path: url, manager)!, encoding: .utf8);
                }
            });
            return name;
        }
        
        private static func getBool(p:String)->Bool{
            var b: Bool = false;
            fileManipulation(path: p, action: {
                manager, path in
                b = manager.fileExists(atPath: path);
            });
            return b;
        }
        
        public static func preview(name:String)->FileSPC? {
            var preview: FileSPC? = nil;
            fileManipulation(path: name+".spc",
               action: {
                manager, path in
                print("preview:",path);
                if manager.fileExists(atPath: path) {
                    preview = Utils.Exten.getSPCFile(StorageApp.getFile(path: path, manager)!);
                }
            });
            
            return preview;
        }
        
        public static func content(id:Int)->FileSKC1? {
            let manager = FileManager.default;
            let path = manager.urls(for: .cachesDirectory, in: .userDomainMask)
                .first!.appendingPathComponent("content/"+id.description+".skc1",
                                               isDirectory: false).path;
            print("content: LOCAL_PATH:",path, "EXISTS:",manager.fileExists(atPath: path))
            if (!manager.fileExists(atPath: path)) {
                return nil;
            }
            
            let data = manager.contents(atPath: path)!;
            return Utils.Exten.getSKC1File(data);
        }
        
        public static func fileExist(cachePath: String)->Bool{
            return getBool(p: cachePath);
        }
        
        
        class Save {
            private static func saveFile(p:String, data:Data?){
                StorageApp.Topic.fileManipulation(path: p, action: {
                    manager, fullPath in
                    print("spokTopic:",fullPath);
                    StorageApp.mkfile(path: fullPath, data: data);
                });
            }
            
            private static func getPath(id:Int, t:String)->String{
                return id.description+"/"+t;
            }

            public static func content(id:Int, data:Data?) {
                let manager = FileManager.default;
                let path = manager.urls(for: .cachesDirectory, in: .userDomainMask)
                    .first!.appendingPathComponent("content/", isDirectory: true).path;
                
                StorageApp.mkdir(path: path);
                StorageApp.mkfile(path: path+"/"+id.description+".skc1",
                                  data: data);
            }
            
            public static func preview(name:String, data:Data?) {
                saveFile(p: name + ".spc", data: data);
            }
            
        }
    }
    
    class Collection {
        
        private static func collectionURL(_ dir:String)->URL {
            return StorageApp.getURL(dir: dir);
        }
        
        public static func save(_ dir:String,name: String, data: Data?) {
            let url = collectionURL(dir);
            StorageApp.mkdir(path: url.path);
            StorageApp.mkfile(path: url.appendingPathComponent(name+".scs", isDirectory: false).path,
                              data: data);
        }
        
        public static func collection(_ dir:String,name:String) -> FileSCS? {
            let url = collectionURL(dir);
            let data = StorageApp.getFile(path: url.appendingPathComponent(name+".scs", isDirectory: false).path, FileManager.default);
            if (data == nil) {
                return nil;
            }
            
            return Utils.Exten.getSCSFile(data!);
        }
    }
}
