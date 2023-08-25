//
//  MainViewController.swift
//  SPOK
//
//  Created by Cell on 19.12.2021.
//

import UIKit;
import FirebaseDatabase;
import FirebaseStorage;

class HomeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var colsTable: UITableView!;
    @IBOutlet weak var topConstraint: NSLayoutConstraint!;
    
    private var collections:[Collection] = [];
    private let tag = "Home:";
    private let mDirCache = "collection"+Utils.getLanguageCode();
    
    private var isDoubleTapped: Bool = false;
    private var manager: ManagerViewController? = nil;
    private var w:CGFloat = UIScreen.main.bounds.width/2.0-32;
    private var h:CGFloat = 1.24;
    private var hCard:CGFloat = 0.0;
    
    private func showData() {
        self.manager?.news = self.collections[0].trs;
        self.colsTable.dataSource = self;
        self.colsTable.delegate = self;
        self.colsTable.reloadData();
    }
    
    private func downloadCollection(current: Int, refs: [StorageReference]) {
        if current >= refs.count {
            showData();
            return;
        }
        
        refs[current].getData(maxSize: 1024*1024) { data, error in
            if error != nil {
                return;
            }
            
            let fileSCS = Utils.Exten.getSCSFile(data!);
            
            StorageApp.Collection.save(self.mDirCache, name: current.description, data: data);
            
            self.collections.append(Collection( trs: fileSCS.topics ?? [],
                                               name: fileSCS.title ?? ""));
            
            self.downloadCollection(current: current+1,
                                    refs: refs);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();

        manager = Utils.getManager();
        
        h = w*1.24;
        hCard = h/207;
        
        colsTable.contentInset = UIEdgeInsets(top: topConstraint.constant, left: 0, bottom: 25, right: 0);
        
        let code = self.manager?.language ?? "";
        let ll = code.isEmpty ? "RU" : "EN";
        
        
        let fileManager = FileManager.default;
        let urlColl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(mDirCache, isDirectory: true);
        
        let path = urlColl.path;
        let filePaths = try? fileManager.contentsOfDirectory(atPath: path);
        if filePaths != nil {
            for fileName in filePaths! {
                let data = StorageApp.getFile(path: path+"/"+fileName,fileManager);
                print(self.tag, "LOAD FROM STORAGE:",data);
                if data == nil {
                    continue;
                }
                
                let fileSCS = Utils.Exten.getSCSFile(data!);
                
                self.collections.append(Collection( trs: fileSCS.topics ?? [],
                                                    name: fileSCS.title ?? ""));
            }
            
            showData();
            
            return;
        }
    
        
        Storage.storage()
            .reference(withPath: "Collection/"+ll)
            .listAll { listResult, error in
                guard let listResult = listResult, error == nil else {
                    return;
                }
                
                let files = listResult.items;
                
                self.downloadCollection(current: 0,
                                   refs: files);
                
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.tag == 0 ? h*1.70 : w, height: h);
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections[collectionView.tag].trs.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let id = collections[collectionView.tag].trs[indexPath.row];
        let intID = Int(id);
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath) as! MCellCollectionView;
        cell.collectionView = collectionView;
        
        if (collectionView.tag == 0){ // is New collection
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bCell", for: indexPath) as! BCellCollectionView;
            (cell as? BCellCollectionView)?.load(view: manager!,id: intID, self, manager: manager!, lang: manager!.language);
            return cell;
        }
        
        cell.load(id: intID, controller: self, manager: manager!, lang: manager!.language, nameSize: 15.0, descSize: 8.65);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight*hCard;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! collectionsCellTableView).collectionView.reloadData();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collections", for: indexPath) as! collectionsCellTableView;
        cell.selectionStyle = .none;
        cell.nameCollection.text = collections[indexPath.row].name;
        if (indexPath.row == 0){
            cell.nameCollection.font = UIFont(name: "OpenSans-Bold", size: 30);
        }
     
        UIView.animate(withDuration: 0.15, animations: {
            cell.nameCollection.alpha = 1.0;
        });
        
        cell.collectionView.dataSource = self;
        cell.collectionView.delegate = self;
        cell.collectionView.tag = indexPath.row;
        
        return cell;
    }
    
    struct Collection {
        var trs:[UInt16];
        var name: String;
    }
    
}

