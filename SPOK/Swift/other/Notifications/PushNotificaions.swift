//
//  PushNotificaions.swift
//  SPOK
//
//  Created by Cell on 27.07.2022.
//

import UserNotifications;
import FirebaseDatabase;
import UIKit;

class PushNotifications{
    
    private static let tag = "SPOK_PushNotifications";
    
    private static func notify(identifier: String, content: UNNotificationContent, center: UNUserNotificationCenter){
        center.add(UNNotificationRequest(identifier: identifier, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)),withCompletionHandler: {
            error in
            print(self.tag, "Error with request on notification \(identifier):", error);
        });
    }
    
    static func notify(notification type: String,center: UNUserNotificationCenter) {
        var path = Utils.getLanguageCode();
        path = path.isEmpty ? ("/"+type) : (path+"/"+type);
        Database.database().reference(withPath: "notifs/"+path).observeSingleEvent(of: .value, with: {
            snapshot in
            if let id = snapshot.childSnapshot(forPath: "id").value as? Int{
                let def = UserDefaults();
                let key = "id"+type;
                
                if def.integer(forKey: key) == id {
                    return;
                }
                
                def.setValue(id, forKey: key);
                
            } else {return;}
            
            var imageAttachment:UNNotificationAttachment? = nil;

            let content = UNMutableNotificationContent();
            content.title = snapshot.childSnapshot(forPath: "tit").value as? String ?? "";
            content.body = snapshot.childSnapshot(forPath: "text").value as? String ?? "";
            
            let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true);
            var attachments:[UNNotificationAttachment] = [];
            
            let imgHttp = snapshot.childSnapshot(forPath: "i").value as? String;
            let audioHttp = snapshot.childSnapshot(forPath: "m").value as? String;
            let imgExists = imgHttp != nil,
                audioExists = audioHttp != nil;
            
            if imgExists{
                Utils.downloadFile(http: imgHttp, completion: {
                    data in
                    let tempImgURL = tempDirURL.appendingPathComponent("i.jpeg");
                    try? UIImage(data: data)?.jpegData(compressionQuality: 1.0)?.write(to: tempImgURL);
                    
                    print(self.tag, "getting image: ", tempImgURL);
                    
                    imageAttachment = try? UNNotificationAttachment(identifier: "img", url: tempImgURL, options: nil);
                    print(self.tag, "image Attachment", imageAttachment);
                    
                    if (!audioExists){
                        content.attachments = [imageAttachment!];
                        notify(identifier: type, content: content, center: center);
                    } else {
                        attachments.append(imageAttachment!);
                    }
                });
            }
            
            if audioExists{
                Utils.downloadFile(http: audioHttp, completion: {
                    data in
                    let fileManager = FileManager.default;
                    let dirSoundLibrary = try? fileManager.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false);
                    let tempRingtoneURL = dirSoundLibrary!.appendingPathComponent("Sounds", isDirectory: true).appendingPathComponent("m.wav");
                    fileManager.createFile(atPath: tempRingtoneURL.path, contents: data, attributes: .none);
                    content.sound = UNNotificationSound(named: UNNotificationSoundName("m.wav"));
                    if let attach = try? UNNotificationAttachment(identifier: "ringtone", url: tempRingtoneURL, options: .none){
                        attachments.append(attach);
                    }
                    print(self.tag, "size of attachments:",attachments.count, "path:",tempRingtoneURL);
                    content.attachments = attachments;
                    notify(identifier: type, content: content, center: center);
                });
            }
            
            if !(audioExists || imgExists){
                notify(identifier: type, content: content, center: center);
            }
        });
    }
}
