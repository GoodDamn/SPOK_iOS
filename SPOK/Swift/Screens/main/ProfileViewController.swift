//
//  ProfileViewController.swift
//  SPOK
//
//  Created by Cell on 23.12.2021.
//

import UIKit;
import MetalKit;

class ProfileViewController:UIViewController {
    
    private let tag = "ProfileVC:";
    
    //@IBOutlet weak var b_get_sub: UIButton!;
    @IBOutlet weak var b_see_all: UIButton!;
    @IBOutlet weak var b_all_liked: UIButton!;
    
    //@IBOutlet weak var metalView: MTKView!;
    @IBOutlet weak var v_nothing_liked: UIView!;
    //@IBOutlet weak var v_sub: UIView!;
    @IBOutlet weak var v_grad: UIView!;
    @IBOutlet weak var v_grad2: UIView!;
    @IBOutlet weak var v_grad3: UIView!;
    @IBOutlet weak var v_clock: UIView!;
    @IBOutlet weak var v_nothing: UIView!;
    
    @IBOutlet weak var tv_doIt: UITextView!;
    @IBOutlet weak var mBtnLearnMore: UIButton!;
    //@IBOutlet weak var tv_getFullAccess: UITextView!;
    //@IBOutlet weak var tv_beOnTop:UITextView!;
    
    @IBOutlet weak var l_recent: UILabel!;
    
    @IBOutlet weak var cv_history: CollectionView8!;
    @IBOutlet weak var cv_liked: CollectionView8!;
    
    @IBOutlet weak var scrollView: UIScrollView!;
    
    @IBOutlet weak var svHeight: NSLayoutConstraint!;
    
    private let lang = Utils.getLanguageCode();
    private let manager = Utils.getManager();
    
    
    private let pointsStart:[CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0.5, y: 0),
        CGPoint(x: 1, y: 0)];
    private let pointsEnd:[CGPoint] = [
        CGPoint(x: 1, y: 1),
        CGPoint(x: 0.5, y: 1),
        CGPoint(x: 0, y: 1)];
    
    private var gradients:[CAGradientLayer] = [CAGradientLayer(), CAGradientLayer(), CAGradientLayer()];
    
    
    func updateLikes() {
        if cv_liked == nil{
            return;
        }
        updateCollection(cv_liked, seeAll: b_all_liked, nothing: v_nothing_liked, arr: manager?.likes);
    }
    
    func updateHistory() {
        if cv_history == nil {
            return;
        }
        updateCollection(cv_history, seeAll: b_see_all, nothing: v_nothing, arr: manager?.history);
    }
    
    private func updateCollection(_ cv: CollectionView8, seeAll: UIButton, nothing: UIView, arr: [UInt16]?){
        
        guard let arr = arr else {
            return;
        }
        
        print(tag,"updateCollection:", arr);

        cv.mIDs = arr;
        
        if !cv.mIDs.isEmpty {
            nothing.isHidden = true;
            seeAll.isEnabled = true;
            cv.isHidden = false;
        } else {
            nothing.isHidden = false;
            seeAll.isEnabled = false;
            cv.isHidden = true;
        }
        
        cv.reloadData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        cv_liked.mCellIdentifier = "likedCollectionViewCell";
        cv_history.mCellIdentifier = "historyCollectionViewCell";
        
        cv_liked.mContext = manager;
        cv_history.mContext = manager;
        
        cv_liked.start();
        cv_history.start();
        
        //shadow(v_sub.layer);
        shadow(v_grad.layer);
        shadow(v_grad2.layer);
        shadow(v_grad3.layer);
        
        //corners(b_get_sub.layer, 4);
        corners(b_see_all.layer, 4);
        //corners(v_sub.layer, 15);
        corners(v_grad.layer, 15);
        corners(v_grad2.layer, 15);
        corners(v_grad3.layer, 15);
        
        createGradient(v_grad,0);
        createGradient(v_grad2,1);
        createGradient(v_grad3,2);
        
        /*svHeight.constant = v_nothing_liked.frame.origin.y + v_nothing_liked.bounds.height;*/
        
        let rot:CGFloat = .pi * 15/180;
        v_grad.transform = CGAffineTransform(rotationAngle: -rot);
        v_grad3.transform = CGAffineTransform(rotationAngle: rot);
        
        tv_doIt.text = Utils.getLocalizedString("spokBeta");
        //tv_beOnTop.text = Utils.getLocalizedString("dontLimit")
        //tv_getFullAccess.text = Utils.getLocalizedString("getFull");
        
        let t = tv_doIt.text!;
        let br = t.distance(from: t.startIndex, to: t.firstIndex(of: "\n")!);
        
        var attr = NSMutableAttributedString(string: t);
        attr.addAttribute(.font, value: UIFont(name: "OpenSans-Bold", size: 21)!, range: NSRange(location: 0, length: br));

        attr.addAttribute(.font, value: UIFont(name: "OpenSans-SemiBold", size: 15)!, range: NSRange(location: br, length: t.count-br))
        
        let par = NSMutableParagraphStyle();
        par.alignment = .center;
        
        attr.addAttributes([NSAttributedString.Key.paragraphStyle:par,NSAttributedString.Key.foregroundColor:UIColor(named: "AccentColor")!], range: NSRange(location: 0, length: t.count));
        
        tv_doIt.attributedText = attr;
        
        v_clock.layer.addSublayer( drawClock(v_clock.bounds, color: UIColor(named: "clock")!.cgColor));
        rasterization(v_clock);
        
        let clock2 = drawClock(CGRect(x: 0, y: 0, width: 90, height: 90), color: UIColor(named: "privacy_color")!.cgColor);
        
        // render image in UIGraphicsContext
        UIGraphicsBeginImageContext(CGSize(width: 90, height: 90));
        clock2.render(in: UIGraphicsGetCurrentContext()!);
        var image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // change size of image
        let h = l_recent.bounds.height * 1.2;
        let size = CGSize(width: h, height: h);
        image = Utils.changeSizeOfImage(size, image: image!);
        
        let attachment = NSTextAttachment();
        attachment.image = image;
        attachment.bounds = CGRect(x: 0, y: -l_recent.bounds.height/2.4, width: h, height: h);
        attr = NSMutableAttributedString();
        attr.append(NSAttributedString(attachment: attachment));
        let a = NSMutableAttributedString(string: l_recent.text!);
        a.addAttributes([NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 14)!,
                         NSAttributedString.Key.foregroundColor:UIColor(named: "nothing_here")!],
                         range: NSRange(location: 0, length: l_recent.text!.count));
        attr.append(a);
        l_recent.attributedText = attr;
        
        // create icon for "See all history" button
        let listPath = UIBezierPath();
        listPath.move(to: CGPoint(x: 0, y: 0));
        listPath.addLine(to: CGPoint(x: 0, y: 15));
        listPath.addLine(to: CGPoint(x: 15, y: 15));
        listPath.addLine(to: CGPoint(x: 15, y: 5));
        listPath.addLine(to: CGPoint(x: 11, y: 0));
        listPath.addLine(to: CGPoint(x: 0, y:0));
        
        listPath.close();
        
        let linesPath = UIBezierPath();
        linesPath.move(to: CGPoint(x: 3, y: 3));
        linesPath.addLine(to: CGPoint(x: 7, y: 3));
        linesPath.move(to: CGPoint(x: 3, y: 7));
        linesPath.addLine(to: CGPoint(x: 10, y: 7));
        linesPath.move(to: CGPoint(x: 3, y: 11));
        linesPath.addLine(to: CGPoint(x: 10, y: 11));
        linesPath.close();
        
        let l = CAShapeLayer();
        l.path = linesPath.cgPath;
        l.lineCap = .round;
        l.strokeColor = UIColor.white.cgColor;
        l.lineWidth = 2.0;
        
        let lay = CAShapeLayer();
        lay.path = listPath.cgPath;
        lay.lineCap = .round;
        let c = UIColor(red: 0.07, green: 0.74, blue: 0.37, alpha: 1.0).cgColor;
        lay.strokeColor = c;
        lay.fillColor = c;
        lay.lineJoin = .round;
        lay.addSublayer(l);
        
        UIGraphicsBeginImageContext(CGSize(width: 15, height: 15));
        lay.render(in: UIGraphicsGetCurrentContext()!);
        b_see_all.setImage(UIGraphicsGetImageFromCurrentImageContext(), for: .normal);
        UIGraphicsEndImageContext();
        
        b_see_all.imageView?.contentMode = .scaleAspectFit;
        b_see_all.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0);
        
        b_see_all.tag = 5;
        
        rasterization(b_see_all.imageView!);
        
        UIGraphicsBeginImageContext(CGSize(width: 50, height: 50));
        Utils.setBackButton(CGRect(x: 0, y: 0, width: 50, height: 50), isLeftArrow: false).render(in: UIGraphicsGetCurrentContext()!);
        var i = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        i = Utils.changeSizeOfImage(CGSize(width: b_all_liked.bounds.height, height: b_all_liked.bounds.height), image: i!);
        
        b_all_liked.setImage(i, for: .normal);
        b_all_liked.imageView?.contentMode = .scaleAspectFit;
        
        rasterization(b_all_liked.imageView!);
        
        updateHistory();
        updateLikes();
        
        v_grad2.addGestureRecognizer(newGestureGradient());
        v_grad.addGestureRecognizer(newGestureGradient());
        v_grad3.addGestureRecognizer(newGestureGradient());
        
        let attrStr = NSAttributedString(string: Utils.getLocalizedString("spokBeta_"),
                                         attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,
                                                      NSAttributedString.Key.underlineColor: mBtnLearnMore.titleLabel?.textColor,
                                                      NSAttributedString.Key.font: UIFont(name: "OpenSans-Semibold", size: mBtnLearnMore.titleLabel?.font.pointSize ?? 15.0)]);
        
        mBtnLearnMore.setAttributedTitle(attrStr, for: .normal);
        
        mBtnLearnMore.addTarget(self, action: #selector(showBanner(_:)), for: .touchUpInside);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 30) ?? UIFont.systemFont(ofSize: 30)];
    }
    
    @objc func showBanner(_ sender: UITapGestureRecognizer) {
        manager?.showSubScreen();
    }
    
    @objc func updateGradients(_ sender: UITapGestureRecognizer) {
        manager?.showSubScreen();
        createGradient(v_grad,0);
        createGradient(v_grad2,1);
        createGradient(v_grad3,2);
    }
    
    @IBAction func showSubScreen(_ sender: UIButton){
        manager?.showSubScreen();
    }
    
    @IBAction func showSettings(_ sender: UIButton) {
        guard let manager = manager else {
            return;
        }
        manager.bottomInset.constant = 0;
        //manager.pageViewController?.isUserInteractionEnabled = false;
        
        UIView.animate(withDuration: 0.25, animations: {
            manager.view.layoutIfNeeded();
            manager.mNavBar.transform = CGAffineTransform(translationX: 0, y: manager.mNavBar.frame.size.height)
        });
        navigationController?.pushViewController(UIStoryboard(name: "mainMenu", bundle: Bundle.main).instantiateViewController(withIdentifier: "settings"), animated: true);
        
    }
    
    @IBAction func showHistory(_ sender: UIButton){
        let c = UIStoryboard(name: "mainMenu", bundle: nil)
            .instantiateViewController(withIdentifier: "listOfTrainings")
        as! ListOfTopicsViewController;
        
        c.title = Utils.getLocalizedString("liked");
        
        if (sender.tag == 5){
            c.title = Utils.getLocalizedString("history");
            c.setTopics(Utils.getManager()?.history ?? []);
        } else {
            c.setTopics(Utils.getManager()?.likes ?? []);
        }
        
        c.delegate.insetSections = UIEdgeInsets(top: 15, left: 0, bottom: 50, right: 0);
        
        navigationController?.pushViewController(c, animated: true);
    }
    
    
    private func newGestureGradient()->UITapGestureRecognizer {
        return newGesture(#selector(updateGradients(_:)));
    }
    
    private func newGesture(_ s: Selector)->UITapGestureRecognizer {
        let tapGest = UITapGestureRecognizer(target: self, action: s);
        tapGest.numberOfTouchesRequired = 1;
        return tapGest;
    }
    
    private func shadow(_ v:CALayer)->Void{
        v.shadowColor = UIColor(named: "AccentColor")?.cgColor;
        v.shadowRadius = 5;
        v.shadowOpacity = 0.4;
        v.shadowOffset = .zero;
        v.shouldRasterize = true;
        v.rasterizationScale = UIScreen.main.scale;
    }
    
    private func drawClock(_ bounds:CGRect, color:CGColor)->CALayer{
        let w = bounds.width/2;
        
        let l = CAShapeLayer();
        l.path = UIBezierPath(arcCenter: CGPoint(x:w , y: bounds.height/2), radius: w-15, startAngle: .pi * 2/3 , endAngle: .pi, clockwise: false).cgPath;
        l.strokeColor = color;
        l.lineJoin = .round;
        l.lineCap = .round;
        l.lineWidth = 9;
        l.fillColor = nil;
        
        let path = UIBezierPath();
    
        path.move(to: CGPoint(x: 5, y: w));
        path.addLine(to: CGPoint(x: 27, y: w));
        path.addLine(to: CGPoint(x: 16, y: w+8));
        path.addLine(to: CGPoint(x: 5, y: w));
        
        path.move(to: CGPoint(x: w, y: w-12));
        path.addLine(to: CGPoint(x: w, y: w));
        path.addLine(to: CGPoint(x: 53, y: 52));
        
        let l2 = CAShapeLayer();
        l2.path = path.cgPath;
        l2.lineWidth = 6;
        l2.strokeColor = color;
        l2.fillColor = nil;
        l2.lineJoin = .round;
        l2.lineCap = .round;
        
        let layer = CALayer();
        layer.addSublayer(l);
        layer.addSublayer(l2);
        
        return layer;
    }
    
    private func corners(_ l:CALayer, _ v:CGFloat)->Void{
        l.cornerRadius = l.bounds.height/v;
    }
    
    
    private func createGradient(_ v:UIView, _ i: Int)->Void{
        if (gradients[i].name != "") {
            gradients[i] = CAGradientLayer(layer: v.layer);
            gradients[i].frame = v.bounds;
            gradients[i].type = .axial;
            let r = Int.random(in: 0..<pointsStart.count);
            gradients[i].startPoint = pointsStart[r];
            gradients[i].endPoint = pointsEnd[r];
            corners(gradients[i], 15);
            gradients[i].name = String(i);
            v.layer.addSublayer(gradients[i]);
        }
        gradients[i].colors = [UIColor(red: rand(), green: rand(), blue: rand(), alpha: 1.0).cgColor, UIColor(red: rand(), green: rand(), blue: rand(), alpha: 1.0).cgColor];
    }
    
    private func rand()->CGFloat{
        return CGFloat.random(in: 0...255)/255;
    }
    
    private func rasterization(_ v:UIView)->Void{
        v.layer.rasterizationScale = UIScreen.main.scale;
        v.layer.shouldRasterize = true;
    }
}
