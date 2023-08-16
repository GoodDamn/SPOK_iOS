//
//  TrainingActivity.swift
//  SPOK
//
//  Created by Cell on 03.06.2022.
//

import UIKit;
import AVFoundation;
import FirebaseDatabase;
import FirebaseStorage;

class TopicActivity: UIViewController{
    
    @IBOutlet weak var l_nameTraining: UILabel!;
    @IBOutlet weak var iv_note: UIImageView!;
    @IBOutlet weak var l_trackName: UILabel!;
    
    private var mActivityIndicator: UIActivityIndicatorView!;
    private var mImageViewHeadphones: UIImageView!;
    
    private var audioPlayer: AVAudioPlayer?;
    private var currentPhrase:Int = 0;
    private var spawnPoint:CGPoint = CGPoint(x: 0.0, y: 0.0);
    private var spawnSize: CGSize = .zero;
    private var manager: ManagerViewController? = nil;
    private var currentTextView: UITextViewPhrase!;
    private var fieldToFade:CGFloat = 0.0;
    private let to:CGAffineTransform = CGAffineTransform(translationX: 0.0, y: 150.0),
                zero = CGAffineTransform(translationX: 0.0, y: 0.0);
    
    var v_tap: TouchView!;
    var id:Int!;
    var typeTopic:String = "Trainings/";
    var musicChild:String = "M";
    var contentChild:String = "text";
    var endOfSession:((Int)->Void)? = nil;
    
    var phrases:[String] = [];
    let tag = "TopicActivity: ";
    
    private var preview:UIImageView!;
    private var startFramePreview: CGRect = .null;
    private var cell:SCellCollectionView!;
    
    public var toExitX:CGFloat = 0;
    
    @objc func onStart(){
        if currentPhrase != 0 {
            audioPlayer?.play();
            audioPlayer?.setVolume(1.0, fadeDuration: 0.8);
        }
    }
    
    @objc func onPause(){
        if currentPhrase != 0 {
            audioPlayer?.pause();
            audioPlayer?.setVolume(0.0, fadeDuration: 1.5);
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onPause), name: UIApplication.willResignActiveNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(onStart), name: UIApplication.didBecomeActiveNotification, object: nil);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self);
        audioPlayer?.setVolume(0.0, fadeDuration: 1.5);
        print(tag, "will disappear");
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // headphones
        let screen = UIScreen.main.bounds;
        
        view.layer.shadowColor = UIColor(named: "settings_title")?.cgColor;
        view.layer.shadowRadius = 7.5 * UIScreen.main.scale;
        view.layer.shadowOpacity = 0.45;
        view.layer.shadowOffset = CGSize(width: 0.5, height: 0.5);
        view.layer.rasterizationScale = UIScreen.main.nativeScale;
        view.layer.shouldRasterize = true;
        
        manager = Utils.getManager()!;
        let blurView = manager!.blurView;
        toExitX = UIScreen.main.bounds.width * 0.25;
        
        v_tap = TouchView(frame: CGRect(x: 0.0, y: 0.0, width: screen.width, height: screen.height));
        v_tap.isUserInteractionEnabled = false;
        v_tap.onTriggered = {
            if (self.v_tap.isTriggered) {
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layer.cornerRadius = 7.5 * UIScreen.main.scale;
                });
            }
        }
        
        v_tap.onTouchMoves = {
            (currentPos, beginPos, originScaled) in
            if self.v_tap.isTriggered {
                self.view.frame.origin.x += currentPos.x - beginPos.x;
                let diff = abs(self.view.frame.origin.x-originScaled);
                
                blurView.alpha = 1.7 - diff/self.toExitX;
                self.audioPlayer?.setVolume(Float(blurView.alpha), fadeDuration: 0.0);
            }
        }
        
        let screenBounds = UIScreen.main.bounds;
        
        let sWidth = screenBounds.size.width;
        let sHeight = screenBounds.size.height;
        let paddingX = sWidth * 0.11;
        
        let iSize = CGSize(width: 40, height: 40);
        let offset:CGFloat = 60;
        
        mActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: (sWidth - iSize.width) * 0.5,
                                                                   y: sHeight * 0.5 - offset - iSize.height,
                                                                   width: iSize.width,
                                                                   height: iSize.height));
        view.addSubview(mActivityIndicator);
        mActivityIndicator.startAnimating();
        
        mImageViewHeadphones = UIImageView(frame: mActivityIndicator.frame);
        mImageViewHeadphones.image = UIImage(systemName: "headphones");
        mImageViewHeadphones.tintColor = UIColor(named: "AccentColor");
        
        spawnPoint.x = paddingX;
        spawnPoint.y = sHeight * 0.5 - offset * 0.9;
        spawnSize = CGSize(width: sWidth-paddingX-paddingX,
                           height: screenBounds.size.height-spawnPoint.y);
        
        print("TopicActivity: ",spawnPoint, spawnSize, screenBounds);
        
        fieldToFade = spawnPoint.y * 0.35;
        
        currentTextView = createTextView(Utils.getLocalizedString("topicLoad"));
        
        UIView.animate(withDuration: 0.5, animations: {
            self.currentTextView.alpha = 1.0;
        });
        
        v_tap.onTouchEnd = { [self] in
            if (v_tap.isTriggered) {
                if (view.frame.origin.x > toExitX) {
                    audioPlayer?.setVolume(0.0, fadeDuration: 1.5);
                    stopSession(0.3, anim: {
                        self.view.frame = self.startFramePreview;
                        self.preview.alpha = 1.0;
                    });
                    return;
                }
                
                UIView.animate(withDuration: 0.23 , animations: {
                    self.view.layer.cornerRadius = 0;
                    self.view.frame.origin.x = 0.0;
                });
                return;
            }
            
            if (currentPhrase == phrases.count) { // End of session
                v_tap.isUserInteractionEnabled = false;
                let comp:((Bool)->Void) = {
                    b in
                    self.audioPlayer?.stop();
                    self.endOfSession?(id);
                    self.stopSession(0.3, anim: {
                        self.view.frame = startFramePreview;
                        self.preview.alpha = 1.0;
                    });
                }
                
                audioPlayer?.setVolume(0.0, fadeDuration: 1.3);
                UIView.animate(withDuration: 1.3, animations: {
                    self.currentTextView.alpha = 0.0;
                }, completion: comp);
                
                return;
            }
            if (currentPhrase == 0){
                UIView.animate(withDuration: 0.55,  animations: {
                    self.mImageViewHeadphones.transform = CGAffineTransform(scaleX: 3.0, y: 3.0);
                    self.mImageViewHeadphones.alpha = 0.0;
                    
                    self.l_nameTraining.alpha = 0.0;
                    self.l_trackName.alpha = 0.0;
                    self.iv_note.alpha = 0.0;
                    
                    self.audioPlayer?.setVolume(0.0, fadeDuration: 0);
                    self.audioPlayer?.play();
                    self.audioPlayer?.setVolume(1.0, fadeDuration: 1.5);
                    self.audioPlayer?.numberOfLoops = -1;
                }, completion: {
                    (b) in
                    self.mImageViewHeadphones.removeFromSuperview();
                    self.l_nameTraining.removeFromSuperview();
                });
                
            }
            
            nextPhrase(phrases[self.currentPhrase]);
            
            self.currentPhrase+=1;
        };
        
        view.addSubview(v_tap);
    }
    
    func prepareSession(with fileSKC1: FileSKC1) {
        do {
            try AVAudioSession.sharedInstance().setMode(.default);
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation);
            
            self.audioPlayer = try AVAudioPlayer(data: fileSKC1.mp3Data!, fileTypeHint: AVFileType.mp3.rawValue);
        
        } catch {
            print(self.tag,error);
        }
        
        phrases = fileSKC1.content;
        l_trackName.text = fileSKC1.artistSong;
        
        mImageViewHeadphones.transform = CGAffineTransform(scaleX: 3.0, y: 3.0);
        mImageViewHeadphones.alpha = 0.0;
        
        view.addSubview(mImageViewHeadphones);
        
        nextPhrase(Utils.getLocalizedString("putHeadphones"));
        
        UIView.animate(withDuration: 0.65, animations: {
            self.mActivityIndicator.alpha = 0.0;
            
            self.mImageViewHeadphones.alpha = 1.0;
            self.mImageViewHeadphones.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            
            self.l_nameTraining.alpha = 1.0;
            self.l_trackName.alpha = 1.0;
            self.iv_note.alpha = 1.0;
        }, completion: {
            (b) in
            self.mActivityIndicator.stopAnimating();
            self.mActivityIndicator.removeFromSuperview()
            self.v_tap.isUserInteractionEnabled = true;
            if self.phrases.last?.isEmpty ?? false{
                self.phrases.popLast();
            }
        });
    }
    
    func loadData() {
        print("TopicActivity: ", typeTopic, contentChild, musicChild);
        
        let id = abs(self.id);
        
        let localSKC1 = StorageApp.Topic.content(id: id);
        
        if (localSKC1 != nil) {
            print("loadData: LOAD CONTENT FROM STORAGE");
            self.prepareSession(with: localSKC1!);
            return;
        }
        
        let sRef = Storage.storage()
            .reference(withPath: "content/"+id.description+Utils.getLanguageCode()+".skc1");
        
        sRef.getData(maxSize: 10*1024*1024) {
            data, error in
            if error != nil || data == nil {
                self.throwError("ERROR: DATA_NULL_PTR");
                return;
            }
            
            let fileSKC1 = Utils.Exten
                .getSKC1File(data!);
            
            if fileSKC1 == nil {
                self.throwError("ERROR_READ_FILE");
                return;
            }
            
            StorageApp.Topic.Save.content(id: id, data: data);
            self.prepareSession(with: fileSKC1!);
        }
    }
    
    func putPreviewImage(cell:SCellCollectionView, startFrame:CGRect){
        self.cell = cell;
        preview = UIImageView(frame: CGRect(origin: .zero, size: cell.frame.size));
        startFramePreview = startFrame;
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, UIScreen.main.scale);
        cell.drawHierarchy(in: cell.bounds, afterScreenUpdates: true);
        preview.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        preview.contentMode = .scaleToFill;
        view.addSubview(preview);
        UIView.animate(withDuration: 0.25, animations: {
            self.preview.alpha = 0.0;
        });
        cell.isHidden = true;
    }
    
    private func throwError(_ text:String) {
        Toast.init(text: text, duration: 1.5).show();
        
        self.stopSession(0.3, anim: {
            self.view.frame = self.startFramePreview;
            self.preview.alpha = 1.0;
        });
    }
    
    private func nextPhrase(_ text: String)->Void{
        let prev_text:UITextViewPhrase = currentTextView;
        currentTextView = createTextView(text);
        print(self, self.fieldToFade);
        prev_text.hide(self.fieldToFade);
        currentTextView.show();
    }
    
    private func stopSession(_ duration: TimeInterval,  anim: @escaping ()->Void){
        UIView.animate(withDuration: duration, animations: {
            self.manager?.blurView.alpha = 0.0;
            anim();
        }, completion: {
            (b) in
            UIView.animate(withDuration: 0.14,
                           animations: {
                self.cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                self.cell.layer.shadowOpacity = 0.0;
            });
            
            self.cell.isHidden = false;
            self.manager?.closeFragment();
        });
    }
    
    private func createTextView(_ text: String)->UITextViewPhrase{
        let textView = UITextViewPhrase(frame: CGRect(origin: spawnPoint, size: spawnSize));
        textView.initial(t: text);
        view.insertSubview(textView, at: 0);
        return textView;
    }
}

class TouchView : UIView{
    
    public var isTriggered:Bool = false;
    public var onTouchEnd:(()->Void) = {() in};
    public var onTriggered:(()->Void) = {()in};
    public var onTouchMoves:((CGPoint, CGPoint, CGFloat)->Void) = {(t,g,a)in};
    public var originScaled:CGFloat = 0.0;
    private let triggerLimit: CGFloat = UIScreen.main.bounds.width * 0.18;
    private var beginPos:CGPoint = CGPoint(x: 0, y: 0);
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beginPos = touches.first!.location(in: self);
        isTriggered = beginPos.x < triggerLimit;
        if isTriggered {
            self.onTriggered();
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchMoves(touches.first!.location(in: self), beginPos, originScaled);
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchEnd();
        isTriggered = false;
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchEnd();
        isTriggered = false;
    }
    

}
