//
//  RatingSnackbar.swift
//  SPOK
//
//  Created by Cell on 26.11.2022.
//

import UIKit;
import FirebaseDatabase;

class RatingSnackbar: UIViewController{
    
    @IBOutlet weak var leadingProgress: NSLayoutConstraint!;
    @IBOutlet weak var trailingProgress: NSLayoutConstraint!;
    
    @IBOutlet weak var star1: Star!;
    @IBOutlet weak var star2: Star!;
    @IBOutlet weak var star3: Star!;
    @IBOutlet weak var star4: Star!;
    @IBOutlet weak var star5: Star!;

    @IBOutlet weak var reviewView: UIView!;
    
    var id:UInt16 = 0;
    
    @IBAction func close(_ sender:UIButton){
        self.manager?.hideRateSnackBar();
        Database.database().reference(withPath: "assessTrs/"+self.id.description+"/"+(UserDefaults().string(forKey: Utils.userRef) ?? "nil")).setValue(self.grade);
        self.reset();
    }
    
    var stars:[Star]!;
    
    let maxProgress = UIScreen.main.bounds.width/2;
    var isRated: Bool = false;
    var grade: UInt8 = 0;
    private let manager = Utils.getManager();
    
    private func zeroTimer(){
        leadingProgress.constant = 0;
        trailingProgress.constant = 0;
        view.layoutIfNeeded();
        leadingProgress.constant = maxProgress;
        trailingProgress.constant = maxProgress;
    }
    
    private func timer(_ comp: @escaping (()->Void)){
        UIView.animate(withDuration: 5.0, animations: {
            self.view.layoutIfNeeded();
        }, completion: {
            _ in
            comp();
        });
    }
    
    private func reset(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.reviewView.isHidden = true;
            self.reviewView.frame.origin.x = UIScreen.main.bounds.width;
            self.isRated = false;
            for star in self.stars{
                star.progress = 0;
            }
            
            self.zeroTimer();
        })
    }
    
    @objc func review(_ gesture: UITapGestureRecognizer){
        let v = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(identifier: "feedback") as! FeedBackViewController;
        v.grade = Float(grade);
        v.placeholder = Utils.getLocalizedString("assExample2");
        v.titleButton = Utils.getLocalizedString("sendFeedback");
        v.title = Utils.getLocalizedString("thanksForYourTime");
        v.pathToAssess = "assessTrs/"+id.description+"/";
        v.desc = Utils.getLocalizedString("assDesc2");
        Utils.getManager()?.navigationController?.pushViewController(v, animated: true);
    }
    
    @objc func rate(_ gesture: UITapGestureRecognizer){
        isRated = true;
        let r = Int(gesture.name!)!;
        grade = UInt8(r);
        for i in 0..<r{
            UIView.animate(withDuration: 0.4, animations: {
                self.stars[i].transform = CGAffineTransform(scaleX: 1.35, y: 1.35);
            });
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i+1)*0.2, execute: {
                self.stars[i].progress = 9.9;
                UIView.animate(withDuration: 0.2, animations: {
                    self.stars[i].transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                })
            });
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(r)*0.5, execute: {
            self.reviewView.isHidden = false;
            
            UIView.animate(withDuration: 0.4, animations: {
                self.reviewView.transform = CGAffineTransform(translationX: 0, y: 0);
            });
            
            self.zeroTimer();
            
            self.timer {
                if !self.isRated{
                    Database.database().reference(withPath: "assessTrs/"+self.id.description+"/"+(UserDefaults().string(forKey: Utils.userRef) ?? "nil")).setValue(self.grade);
                }
                self.manager?.hideRateSnackBar();
                self.reset();
            }
        });
    }
    
    private func assignRate(_ star: Star, grade: Int){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(rate(_:)))
        gesture.numberOfTapsRequired = 1;
        gesture.name = grade.description;
        star.addGestureRecognizer(gesture);
    }
    
    
    func startTimer() -> Void {
        
        self.reviewView.isHidden = true;
        self.reviewView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0);
        self.isRated = false;
        self.grade = 0;
        for star in self.stars{
            star.progress = 0;
        }
        
        self.zeroTimer();
        
        timer({
            if !self.isRated{
                self.manager?.hideRateSnackBar();
                self.reset();
                return;
            }
            
            self.isRated = false;
        });
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        reviewView.isHidden = true;
        reviewView.frame.origin.x = UIScreen.main.bounds.width;
        reviewView.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor;
        reviewView.layer.shadowRadius = 12.0;
        reviewView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5);
        reviewView.clipsToBounds = false;
        reviewView.layer.masksToBounds = false;
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(review(_:)));
        gesture.numberOfTapsRequired = 1;
        reviewView.addGestureRecognizer(gesture);
        
        assignRate(star1,grade: 1);
        assignRate(star2,grade: 2);
        assignRate(star3,grade: 3);
        assignRate(star4,grade: 4);
        assignRate(star5,grade: 5);
        
        stars = [star1, star2, star3, star4, star5];
        
        self.reviewView.isHidden = true;
        self.reviewView.frame.origin.x = UIScreen.main.bounds.width;
        self.isRated = false;
        self.grade = 0;
        for star in self.stars{
            star.progress = 0;
        }
        
        self.zeroTimer();
    }
}
