//
//  Constants.swift
//  SPOK
//
//  Created by Cell on 24.01.2022.
//

import UIKit;
import FirebaseDatabase;

class Utils{
    
    private static let tag = "Utils:";
    
    public static let mDate = Date();

    public static let mSTATS = true;
    
    public static let mKEY_CHECKLIST_COUNT = "cl";
    public static let mKEY_GOT_CHECKLIST = "gl";
    public static let mEChild = "Errors/iOS";
    
    public static let givenName:String = "name",
                      userRef:String = "userID";
    
    public static let nonces:[String] = [
        "8305976241",
        "1870429536",
        "7523194086",
        "1726540389",
    ];
    
    public static func moveToAnotherViewController(_ viewController: UIViewController, animation: UIView.AnimationOptions){
        let window = UIApplication.shared.windows[0] as UIWindow;
        window.rootViewController = viewController;
        UIView.transition(with: window, duration: 0.65, options: animation, animations: nil, completion: nil);
    }
    
    public static func mainNav() -> MainNavigationController {
        return UIApplication
            .shared
            .windows[0]
            .rootViewController
            as! MainNavigationController
    }
    
    public static func main() -> MainViewController {
        return mainNav()
            .viewControllers[0]
            as! MainViewController
    }
    
    public static func insets() -> UIEdgeInsets {
        return UIApplication
            .shared
            .windows
            .first?
            .safeAreaInsets ?? UIEdgeInsets.zero
    }
    
    public static func configNotifications(center: UNUserNotificationCenter = UNUserNotificationCenter.current()){
        center.requestAuthorization(options: [.sound, .alert], completionHandler: {
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
            
        });
        
    }
    
    public static func getLocalizedString(_ key:String)->String{
        return NSLocalizedString(key, tableName: "Localization", bundle: Bundle.main, value: "", comment: "");
    }
    
    public static func setPrivacyAndTerms(tv_terms:UITextView, textColour:UIColor)-> Void{
        
        let terms = tv_terms.text!;
        
        var loc = terms.firstIndex(of: "\n");
        var begin = 0;
        
        if (loc != nil){
            begin = terms.distance(from: terms.startIndex, to: loc!)+1;
        } else {
            loc = terms.startIndex;
        }
        
        let attrStr = NSMutableAttributedString(string: terms);
        
        attrStr.addAttributes([NSAttributedString.Key.font:UIFont(name: "OpenSans-SemiBold", size: tv_terms.font!.pointSize)!,
            NSAttributedString.Key.foregroundColor:textColour],range: NSRange(location: 0, length: terms.count));
        
        let lang = ((Locale.current.languageCode ?? "ru")+"s").replacingOccurrences(of: "ens", with: "");
        
        print("setPrivacyAndTerms:",((Locale.current.languageCode ?? "ru")+"s").replacingOccurrences(of: "ens", with: ""), Locale.current.languageCode, (Locale.current.languageCode ?? "ru")+"s");
        
        var rang = NSRange(location: begin, length: terms.distance(from: loc!, to: terms.firstIndex(of: "&")!)-1);
        
        attrStr.addAttribute(.link, value: "https://sites.google.com/view/spokapp/"+lang+"terms", range: rang);
        begin = rang.location+rang.length+2;
        rang = NSRange(location: begin, length: terms.count-begin);
        
        attrStr.addAttribute(.link, value: "https://sites.google.com/view/spokapp/"+lang+"policy", range: rang);
        
        let parag = NSMutableParagraphStyle();
        parag.alignment = .center;
        
        attrStr.addAttribute(.paragraphStyle, value: parag, range: NSRange(location: 0, length: terms.count-1));
        
        tv_terms.linkTextAttributes = [NSAttributedString.Key.foregroundColor: textColour,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue];
        tv_terms.attributedText = attrStr;
        
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
    
    static func downloadFile(http:String?,
                             asyncExec: ((Data)->Void)? = nil,
                             background: ((Data)->Void)? = nil,
                             onError: (()->Void)? = nil) {
        if http == nil{
            print(self, "Http address is nil");
            onError?();
            return;
        }
        
        if let url = URL(string:http!){
            URLSession.shared.dataTask(with: url, completionHandler: {
                data,response,error in
                guard let data = data, error == nil else{
                    print(self, error);
                    onError?();
                    return;
                }
                background?(data);
                
                DispatchQueue.main.async {
                    asyncExec?(data);
                }
            }).resume();
        }
    }
    
    static func downloadFile(http:String?,
                             completion:@escaping((Data)->Void),
                             onError: (()->Void)? = nil){
        downloadFile(http: http, asyncExec: completion, onError: onError);
    }
    
    public static func scaleFont(_ label:UILabel, increaseSize:CGFloat = 0.0)->Void{
        label.font = UIFont(name: label.font.fontName, size: label.font.pointSize * UIScreen.main.nativeScale/3 + UIScreen.main.nativeScale + increaseSize);
    }
    
    public static func convertHex(
        _ s:String
    ) -> UIColor {
        
        let hex: String = s
            .trimmingCharacters(
                in: CharacterSet
                    .whitespacesAndNewlines
            );
        let scanner = Scanner(string: hex);
        scanner.scanLocation = 1;
        
        var color: UInt32 = 0;
        scanner.scanHexInt32(&color);
        
        let mask = 0x000000FF;
        return UIColor(red: CGFloat(Int(color >> 16) & mask)/255.0,
                       green: CGFloat(Int(color >> 8) & mask)/255.0,
                       blue: CGFloat(Int(color) & mask)/255.0,
                       alpha: CGFloat(color >> 24)/255.0);
    }
    
    public static func cropImage(_ s:CGSize, input:UIImage?)->UIImage{
        if input == nil{
            return UIImage();
        }
        
        let croppedimg = input?.cgImage?.cropping(to: CGRect(origin: .zero, size: s));
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
        i.draw(in: CGRect(origin: .zero, size: s));
        i = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return i;
    }
    
    public static func convertPathToUIImage(imageSize s:CGSize, path:UIBezierPath, tint: UIColor)->UIImage{
        let layer = CAShapeLayer();
        layer.path = path.cgPath;
        layer.fillColor = tint.cgColor;
        return convertCAToUIImage(s, layer: layer);
    }
    
    public static func convertCAToUIImage(_ s:CGSize, layer: CAShapeLayer)->UIImage{
        UIGraphicsBeginImageContext(s);
        layer.render(in: UIGraphicsGetCurrentContext()!);
        let i = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return i;
    }
    
    public static func setBackButton(_ b_close:CGRect, isLeftArrow:Bool)->CAShapeLayer{
        let arrow = CAShapeLayer();
        let path = UIBezierPath();
        
        var p1:CGPoint,p:CGPoint;
        
        if (isLeftArrow){
            p1 = CGPoint(x: b_close.width*0.85, y: b_close.height*0.7);
            path.move(to: p1);
            p = CGPoint(x: b_close.width*0.65, y: b_close.height/2);
        } else {
            p1 = CGPoint(x: b_close.width*0.15, y: b_close.height*0.7);
            path.move(to: p1);
            p = CGPoint(x: b_close.width*0.35, y: b_close.height/2);
        }
        
        path.addLine(to: p);
        path.move(to: p);
        path.addLine(to: CGPoint(x: p1.x, y: b_close.height-p1.y));
        
        arrow.path = path.cgPath;
        arrow.lineWidth = 2.6;
        arrow.lineCap = .round;
        arrow.lineJoin = .round;
        arrow.strokeColor = UIColor(named: "nothing_here")?.cgColor;
        
        return arrow;
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
    
    class Design{
        static func roundedButton(_ b: UIButton){
            b.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor;
            b.layer.shadowOpacity = 0.2;
            b.layer.cornerRadius = b.bounds.height/2;
            b.layer.shadowOffset = CGSize(width: 0, height:0);
        }
        
        static func barButton(_ nc:UINavigationController?, _ title:String){
            let item = UIBarButtonItem();
            item.title = title;
            item.tintColor = UIColor(named: "AccentColor");
            nc?.navigationBar.topItem?.backBarButtonItem = item;
        }
    }
}
