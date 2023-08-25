//
//  SearchViewController.swift
//  SPOK
//
//  Created by Cell on 23.12.2021.
//

import UIKit;
import FirebaseDatabase;
import FirebaseStorage;

class SearchViewController:UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{

    @IBOutlet weak var heightTabLayout: NSLayoutConstraint!;
    @IBOutlet weak var categStack: UIStackView!;
    @IBOutlet weak var stackViewWidth: NSLayoutConstraint!;
    @IBOutlet weak var deformView: UIView!;
    @IBOutlet weak var widthDefView: NSLayoutConstraint!;
    @IBOutlet weak var leadingDefView: NSLayoutConstraint!;
    @IBOutlet weak var leadContentView: NSLayoutConstraint!;
    @IBOutlet weak var topContent: NSLayoutConstraint!;
    
    @IBOutlet weak var scrollViewCategories: UIScrollView!;
    
    private let tag = "SearchViewController:";
    
    private let mLang = Utils.getLanguageCode();
    private let mDirCache = "category"+Utils.getLanguageCode();
    
    private var pageController:UIPageViewController? = nil;
    
    private var tabsFrames:[CategoryView] = [];
    
    var categoriesVC:[UIViewController] = [];
    
    private func finishSetup() {
        self.pageController?.dataSource = self;
        self.pageController?.delegate = self;
        self.pageController?.setViewControllers([self.categoriesVC.first!], direction: .forward, animated: true, completion: nil);
        UIView.animate(withDuration: 0.4, animations: {
            self.deformView.alpha = 1.0;
        }, completion: {
            _ in
            self.updateScrollPosition(0);
        });
    }
    
    private func configCategory(current: Int,
                                fileSCS: FileSCS) {
        let categoryView = UINib(nibName: "CategoryView",
                                 bundle: nil)
            .instantiate(withOwner: self, options: nil).first as! CategoryView;
        
        categoryView.backgroundColor = .clear;
        categoryView.butCategory.tag = current;
        categoryView.butCategory.addTarget(self,
                action: #selector(self.moveToCategory(_:)),
                                           for: .touchUpInside);
        
        categoryView.nameCategory.text = fileSCS.title;
        categoryView.nameCategory.font = UIFont(name: "OpenSans-Bold", size: 17.0);
        categoryView.imgIcon.image = fileSCS.image;
        
        let controller = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "listOfTrainings") as! ListOfTopicsViewController;
        controller.view.backgroundColor = .clear;
        controller.index = current;
        controller.setTopics(fileSCS.topics!);
        
        self.addCategory(categoryView,
                         categoryVC: controller);
    }
    
    private func downloadCategory(current: Int, categories: [StorageReference]) {
        print(self.tag, current, categories.count);
        
        if current >= categories.count {
            finishSetup();
            return;
        }
        
        let name = self.mLang+current.description;
        
        categories[current]
            .getData(maxSize: 3*1024*1024) { data, error in
                if error != nil || data == nil {
                    return;
                }
                
                let fileSCS = Utils.Exten.getSCSFile(data!,scale: UIScreen.main.scale);
                StorageApp.Collection.save(self.mDirCache,name: name, data:data);
                print(self.tag,"LOAD CATEGORY FROM SERVER");
                self.configCategory(current: current+1,
                                    fileSCS: fileSCS);
                self.downloadCategory(current: current+1,
                                      categories: categories);
            }
    }
    
    
    private func addCategory(_ v: CategoryView,
                        categoryVC: ListOfTopicsViewController) {
        v.alpha = 0.0;
        categoriesVC.append(categoryVC);
        categStack.addArrangedSubview(v);
        tabsFrames.append(v);
        
        v.frame.size.width = v.nameCategory.intrinsicContentSize.width +
            v.nameCategory.frame.origin.x;
        
        if v.nameCategory.text!.isEmpty {
            v.frame.size.width = 0;
            self.stackViewWidth.constant += 20;
        }
        
        self.stackViewWidth.constant += v.frame.size.width+20;
        self.leadContentView.constant = self.stackViewWidth.constant + 20;
        
        UIView.animate(withDuration: 0.4,
            animations: {
            v.alpha = 1.0;
        });
    }
    
    private func updateScrollPosition(_ index:Int) {
        
        widthDefView.constant = tabsFrames[index].frame.size
            .width+20;
        leadingDefView.constant = tabsFrames[index].frame.origin.x+10;
        
        let norm = leadingDefView.constant / stackViewWidth.constant;
        let screenWidth = UIScreen.main.bounds.width;
        let screenPos = screenWidth * norm;
        
        var offset = leadingDefView.constant - screenPos;
        
        if screenPos + widthDefView.constant > screenWidth { // right bound is out of screen's bound
            offset += offset + widthDefView.constant - screenWidth;
        }
        
        self.scrollViewCategories
            .setContentOffset(CGPoint(x: offset, y: 0),
                              animated: true);
        
        UIView.animate(withDuration: 0.15, animations: {
            self.view.layoutIfNeeded();
        });
    }
    
    @objc func moveToCategory(_ sender:UIButton){
        pageController?.setViewControllers([categoriesVC[sender.tag]], direction: .forward, animated: true, completion: nil);
        updateScrollPosition(sender.tag);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        modalPresentationStyle = .overFullScreen;
        
        deformView.layer.shadowRadius = 4.5;
        deformView.layer.shadowOpacity = 0.35;
        deformView.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor;
        deformView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5);
        deformView.layer.cornerRadius = deformView.bounds.height/2.2;
        deformView.layer.shouldRasterize = true;

        guard let edges = UIApplication.shared.windows.first?.safeAreaInsets else {
            return;
        };
        print(self.tag, edges);
        
        heightTabLayout.constant = 66+edges.top*0.75;
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier != "page") {
            return;
        }
        self.pageController = segue.destination as? UIPageViewController;
        
        
        let fileManager = FileManager.default;
        let urlCat = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(mDirCache, isDirectory: true);
        let pathCat = urlCat.path;
        let filePaths = try? fileManager.contentsOfDirectory(atPath: pathCat);
        
        var starImage = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate);
        let color = UIColor(red: 1.0, green: 0.9, blue: 0.21, alpha: 1.0);
        
        UIGraphicsBeginImageContextWithOptions(starImage!.size, false, starImage!.scale);
        color.set();
        starImage?.draw(in: CGRect(origin: .zero, size: starImage!.size));
        starImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        self.configCategory(current: 0,
                            fileSCS: FileSCS(title: "",
                                            topics: [3,41,5,6,14,11],
                                            image: starImage))
        
        if filePaths != nil {
            print(self.tag, "LOAD CATEGORIES FROM LOCAL STORAGE:");
            for i in 0..<filePaths!.count {
                let data = StorageApp.getFile(path: pathCat+"/"+filePaths![i], fileManager);
                print(self.tag, "CATEGORY:", data);
                if data == nil {
                    continue;
                }
                
                let fileSCS = Utils.Exten.getSCSFile(data!);
                
                self.configCategory(current: i+1,
                                    fileSCS: fileSCS);
            }
            finishSetup();
            return;
        }
        
        let ll = mLang.isEmpty ? "RU" : "EN";
        
        Storage.storage()
            .reference(withPath: "Categories/"+ll)
            .listAll { listResult, error in
                
                guard let listResult = listResult, error == nil else {
                    return;
                }
                
                print(self.tag, "CATEGORIES_COUNT:", listResult.items.count);
                self.downloadCategory(current: 0,
                                      categories: listResult.items);
            }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = categoriesVC.firstIndex(of: viewController), index > 0 else {
            return nil;
        }
        return categoriesVC[index-1];
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = categoriesVC.firstIndex(of: viewController), index < (categoriesVC.count-1) else {
            return nil;
        }
        return categoriesVC[index+1];
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updateScrollPosition((pageViewController.viewControllers?.first as? ListOfTopicsViewController)?.index ?? 0)
    }
    
}
