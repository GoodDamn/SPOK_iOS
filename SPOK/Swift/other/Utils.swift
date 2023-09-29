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
                
                for i in 1...4{
                    let content = UNMutableNotificationContent();
                    content.title = Utils.getLocalizedString("edn"+i.description);
                    content.body = Utils.getLocalizedString("ednb"+i.description);
                    
                    center.add(UNNotificationRequest(identifier: ("daily"+i.description), content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 86400 * Double(i+3), repeats: true)), withCompletionHandler: {
                        error in
                        print(self.tag,error);
                    });
                    // Short-fired notification on the first 4 days.
                    center.add(UNNotificationRequest(identifier: ("dailyTest"+i.description), content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 86400 * Double(i), repeats: true)), withCompletionHandler: {
                        error in
                        print(self.tag,error);
                    })
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
    
    
    static func singleTap(_ cell:SCellCollectionView,
                          origin:CGPoint) {
        
        let manager = Utils.getManager()!;
        print(Utils.tag, "single tap");
        
        if (cell.mFileSPC.isPremium) {
            manager.showSubScreen();
            return;
        }
        
        if (manager.isConnected) {
            manager.startTraining(
                cell:cell,
                startFrame: CGRect(
                            origin: origin,
                            size: CGSize(
                                  width: cell.frame.size.width*1.075,
                                  height: cell.frame.size.height*1.075)));
            return;
        }
        
        manager.showNoInternet(cell: cell);
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
    
    static func showCard(_ cell: UICollectionViewCell){
        UIView.animate(withDuration: 0.35, animations: {
            cell.contentView.alpha = 1.0;
        });
    }
    
    public static func scaleFont(_ label:UILabel, increaseSize:CGFloat = 0.0)->Void{
        label.font = UIFont(name: label.font.fontName, size: label.font.pointSize * UIScreen.main.nativeScale/3 + UIScreen.main.nativeScale + increaseSize);
    }
    
    public static func getManager()->ManagerViewController? {
        return ((UIApplication.shared.windows.first!.rootViewController as? MainNavigationController)?.viewControllers.first as? ManagerViewController);
    }
    
    public static func isNewTraining(_ id:Int)->Bool{
        return getManager()?.news.contains(UInt16(id)) ?? false;
    }
    
    public static func convertHex(_ s:String)->UIColor{
        let hex: String = s.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
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
    
    public static func changeSizeOfImage(_ s:CGSize, image: UIImage)->UIImage{
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
 
    class Byte {
        
        static func uint16(_ inp: Data, offset: Int = 0) -> UInt16 {
            return uint16(([UInt8])(inp), offset: offset);
        }
        
        static func uint16(_ inp: [UInt8], offset: Int = 0) -> UInt16 {
            let r = UInt16(inp[offset]);
            let r1 = UInt16(inp[offset+1]);
            return r << 8 | r1;
        }
        
        static func uint32(_ inp: Data, offset: Int = 0) -> UInt32 {
            return uint32(([UInt8])(inp), offset: offset);
        }
        
        static func uint32(_ inp: [UInt8], offset: Int = 0) -> UInt32 {
            print("uint32:INPUT:",inp[offset], inp[offset+1], inp[offset+2], inp[offset+3]);
            print("uint32:RADIX_2:", String(inp[offset], radix: 2), String(inp[offset+1], radix: 2),String(inp[offset+2], radix: 2),String(inp[offset+3], radix: 2));
            print("uint32:OUTPUT:", String(inp[offset] << 24, radix: 2),String(inp[offset+1] << 16, radix: 2),String(inp[offset+2] << 8, radix: 2),String(inp[offset+3], radix: 2));
            return UInt32(inp[offset] << 24   |
                          inp[offset+1] << 16 |
                          inp[offset+2] << 8  |
                          inp[offset+3]);
        }
    }
    
    class Exten {
        
        static func getSKC1File(_ data: Data) -> FileSKC1? {
            let trackLen = Int((UInt8) (data[0]));
            var pos = trackLen + 1;
            
            let tag = "getSKC1File:";
            
            let artistSong = String(data: data.subdata(in: 1..<pos),
                                    encoding: .utf8);
            
            let contentLen = Int(Byte.uint16(data.subdata(in: pos..<(pos+2))));
            pos += 2;
            let content = String(data: data.subdata(in: pos..<(pos+contentLen)),
                                 encoding: .utf8);
            let contentArr = content?.components(separatedBy: .newlines).filter{$0 != ""};
            pos += contentLen;
            
            if content == nil {
                return nil;
            }
            
            return FileSKC1(content: contentArr!,
                            artistSong: artistSong,
                            mp3Data: data.subdata(in: pos..<data.count));
        }
        
        static func getSPCFile(_ data: Data, scale: CGFloat = 2.0) -> FileSPC {
            let conf = (UInt8) (data[0]);
            let isPremium = (conf & 0xff) >> 6 == 1;
            let categoryID = conf & 0x3f;
            
            let color = UIColor(red: CGFloat(data[2]) / 255,
                                green: CGFloat(data[3]) / 255,
                                blue: CGFloat(data[4]) / 255,
                                alpha: CGFloat(data[1]) / 255);
            
            let descLen = Int(Byte.uint16(data.subdata(in: 5..<7)));
            var pos = 7 + descLen;
            let description = String(data: data.subdata(in: 7..<pos),
                                     encoding: .utf8);
            
            let titleLen = Int(Byte.uint16(data.subdata(in: pos..<(pos+2))));
            pos += 2;
            let title = String(data: data.subdata(in: pos..<(titleLen+pos)),
                               encoding: .utf8);
            
            pos += titleLen;
            
            let image = UIImage(data: data.subdata(in: pos..<data.count), scale: scale);
            
            return FileSPC(isPremium: isPremium,
                           categoryID: categoryID,
                           color: color,
                           description: description,
                           title: title,
                           image: image);
        }
        
        static func getSCSFile(_ data: Data, scale: CGFloat = 2.0) -> FileSCS {
                        
            let titleLen = Int((UInt8) (data[0]));
            let titleData = data.subdata(in: 1..<(titleLen+1));
            
            let title = String(data: titleData,
                               encoding: .utf8);
            var pos = 1+titleLen;
            
            let topicsLen = Byte.uint32(data.subdata(in: pos..<(pos+4)));
            pos += 4;
            var topics:[UInt16] = [];
            let dataTopics = ([UInt8]) (data.subdata(in: pos..<(pos+Int(topicsLen))));
            
            var i:Int = 0;
            while i < topicsLen {
                topics.append(Byte.uint16(dataTopics, offset: i));
                i += 2;
            }
            
            pos += i;
            
            if (pos >= data.count) {
                return FileSCS(title: title,
                               topics: topics,
                               image: nil);
            }
            
            let img = UIImage(data: data.subdata(in: pos..<(data.count)),
                              scale: scale);
            
            return FileSCS(title: title,
                           topics: topics,
                           image: img);
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
