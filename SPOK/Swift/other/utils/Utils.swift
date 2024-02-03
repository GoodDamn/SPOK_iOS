//
//  Constants.swift
//  SPOK
//
//  Created by Cell on 24.01.2022.
//

import UIKit;
import FirebaseDatabase;

class Utils {
    
    private static let tag = "Utils:";
    
    
    public static func mainNav(
    ) -> MainNavigationController {
        return UIApplication
            .shared
            .windows[0]
            .rootViewController
            as! MainNavigationController
    }
    
    public static func main(
    ) -> MainViewController {
        return mainNav()
            .viewControllers[0]
            as! MainViewController
    }
    
    public static func insets(
    ) -> UIEdgeInsets {
        return UIApplication
            .shared
            .windows
            .first?
            .safeAreaInsets ?? UIEdgeInsets.zero
    }
    
    public static func configNotifications(
        center: UNUserNotificationCenter = UNUserNotificationCenter.current()
    ) {
        center.requestAuthorization(
            options: [.sound, .alert]
        ) {
            (granted, error) in
            
            if let error = error {
                print(self.tag, error)
                return;
            }
            
            if granted{
                print(self.tag, "Permission is granted");
                
                center.removeAllPendingNotificationRequests();
                
                let dailyContentSize:UInt8 = 4;
                
                var dateComponents = DateComponents();
                dateComponents.calendar = Calendar.current;
                
                let content = UNMutableNotificationContent();
                
                for day in 1...7 {
                    
                    var dd = UInt8.random(in: 1...dailyContentSize);
                    
                    content.title = Utils.getLocalizedString("edn\(dd)");
                    content.body = Utils.getLocalizedString("ednb\(dd)");
                    
                    dateComponents.weekday = day;
                    dateComponents.minute = 0
                    dateComponents.hour = 7
                    
                    center.add(UNNotificationRequest(
                        identifier: ("SPOK7\(day)\(dd)"),
                        content: content,
                        trigger: UNCalendarNotificationTrigger(
                            dateMatching: dateComponents,
                            repeats: true)))
                    
                    dateComponents.hour = 18;
                    
                    dd = UInt8.random(in: 1...dailyContentSize);
                    
                    content.title = Utils.getLocalizedString("edn\(dd)");
                    content.body = Utils.getLocalizedString("ednb\(dd)");
                    
                    center.add(UNNotificationRequest(
                        identifier: "SPOK18\(day)\(dd)",
                        content: content,
                        trigger: UNCalendarNotificationTrigger(
                            dateMatching: dateComponents,
                            repeats: true)))
                    
                }
            }
            
        }
        
    }
    
    public static func getLocalizedString(
        _ key:String
    ) -> String {
        return NSLocalizedString(
            key,
            tableName: "Localization",
            bundle: Bundle.main,
            value: "",
            comment: ""
        )
    }
    
    static func getLanguageCode()->String{
        return Locale.current.languageCode?.replacingOccurrences(of: "ru", with: "").uppercased() ?? "";
    }
    
    
    static func configLikes(_ controller: UIViewController,_ cell:UICollectionViewCell, id:Int, selectors:[Selector]) {
        let gesture = UITapGestureRecognizer(target: controller, action: selectors[0]);
        gesture.numberOfTapsRequired = 1;
        gesture.name = id.description;
        cell.addGestureRecognizer(gesture);
        
        let double = UITapGestureRecognizer(target: controller, action: selectors[1]);
        double.numberOfTapsRequired = 2;
        double.name = id.description;
        cell.addGestureRecognizer(double);
        
        gesture.require(toFail: double);
        
    }

    
    public static func cropImage(
        _ s:CGSize,
        input:UIImage?
    )->UIImage {
        
        if input == nil{
            return UIImage();
        }
        
        let croppedimg = input?
            .cgImage?
            .cropping(
                to: CGRect(
                    origin: .zero,
                    size: s
                )
            )
        
        if croppedimg == nil{
            return UIImage();
        }
        
        return UIImage(cgImage: croppedimg!);
    }
    
    public static func changeSizeOfImage(
        _ s:CGSize,
        image: UIImage
    ) -> UIImage{
        
        var i = image;
        UIGraphicsBeginImageContext(s);
        i.draw(
            in: CGRect(
                origin: .zero,
                size: s)
        )
        i = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return i;
    }
    
 
    class Exten {
        
        static func getSPCFile(
            _ data: inout Data,
            scale: CGFloat = UIScreen.main.scale
        ) -> FileSPC {
            let conf = data[0];
            let isPremium = (conf & 0xff) >> 6 == 1;
            let categoryID = conf & 0x3f;
            
            let color = UIColor(
                red: CGFloat(data[2]) / 255,
                green: CGFloat(data[3]) / 255,
                blue: CGFloat(data[4]) / 255,
                alpha: CGFloat(data[1]) / 255
            );
            
            let descLen = Int(
                ByteUtils.short(
                    &data,
                    offset: 5
                )
            )
            
            var pos = 7 + descLen;
            let description = String(
                data: data[7..<pos],
                encoding: .utf8
            )
            
            let titleLen = Int(
                ByteUtils.short(
                    &data,
                    offset: pos
                )
            )
            
            pos += 2;
            let title = String(
                data: data[
                    pos..<(titleLen+pos)
                ],
                encoding: .utf8
            );
            
            pos += titleLen;
            
            let image = UIImage(
                data: data[
                    pos..<data.count
                ],
                scale: scale
            );
            
            return FileSPC(
                isPremium: isPremium,
                categoryID: categoryID,
                color: color,
                description: description,
                title: title,
                image: image
            );
        }
        
        static func getSCSFile(
            _ data: inout Data?,
            scale: CGFloat = UIScreen.main.scale
        ) -> FileSCS? {
            
            guard var data = data else {
                return nil
            }
            
            var type: CardType
            var cardSize: CGSize
            var cardTextSize: CardTextSize
            
            switch(data[0]) {
            case 0:
                cardSize = MainViewController
                    .mCardSizeB
                type = .B
                cardTextSize = MainViewController
                    .mCardTextSizeB
                break
            case 1:
                cardSize = MainViewController
                    .mCardSizeM
                type = .M
                cardTextSize = MainViewController
                    .mCardTextSizeM
                break
            default:
                type = .M
                cardTextSize = MainViewController
                    .mCardTextSizeM
                cardSize = .zero
            }
            
            let titleLen = Int(data[1])
            
            let title = String(
                data: data[
                    2..<(titleLen+2)
                ],
                encoding: .utf8
            )
            
            var pos = 2+titleLen;
            
            let topicsLen = ByteUtils
                .int(
                    &data,
                    offset: pos
                )
            
            pos += 4
            var topics:[UInt16] = []
            let b = pos + topicsLen
            while pos < b {
                topics.append(
                    UInt16(
                        ByteUtils.short(
                            &data,
                            offset: pos
                        )
                    )
                )
                pos += 2;
            }
            
            if (pos >= data.count) {
                return FileSCS(
                    title: title,
                    topics: topics,
                    image: nil,
                    cardSize: cardSize,
                    cardTextSize: cardTextSize,
                    type: type
                )
            }
            
            let img = UIImage(
                data: data[
                    pos..<(data.count)
                ],
                scale: scale
            );
            
            return FileSCS(
                title: title,
                topics: topics,
                image: img,
                cardSize: cardSize,
                cardTextSize: cardTextSize,
                type: type
            )
        }
    }
    
    
}
