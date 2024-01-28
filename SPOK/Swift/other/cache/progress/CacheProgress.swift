//
//  CacheProgress.swift
//  SPOK
//
//  Created by GoodDamn on 27/01/2024.
//

import Foundation
import FirebaseStorage

class CacheProgress<
        T,
        Delegate: CacheProgressListener
> : CacheFile<T, Delegate> {
    
    private var mDownloadTask: StorageDownloadTask? = nil
    
    override func onUpdateCache() {
        
        mDownloadTask = mReference.write(
            toFile: mUrlToSave
        ) { [weak self] url, error in

            guard let s = self else {
                return
            }
            
            guard let _ = url, error == nil else {
                print(
                    "CacheFile:",
                    "DOWNLOAD_WRITE:ERROR",
                    error
                )
                return
            }

            print(
                "CacheProgress:",
                "SUCCESSFULLY WRITTEN TO STORAGE"
            )
            
            s.delegate?.onWrittenStorage()
        }
        
        mDownloadTask?.observe(
            .progress
        ) { [weak self] snap in
            
            guard let s = self else {
                return
            }
            
            guard let pr = snap.progress else {
                return
            }
            
            let percent = 100 * Double(
                pr.completedUnitCount
            ) / Double(pr.totalUnitCount)
            
            s.delegate?.onProgress(
                percent: percent
            )
        }
        
        mDownloadTask?.observe(
            .failure
        ) { [weak self] snap in

            print(
                "CacheProgress:",
                "observe:FAIL:",
                snap.error
            )
            
            guard let s = self else {
                return
            }
            
            s.delegate?.onError()
            
        }
        
        mDownloadTask?.observe(
            .success
        ) { [weak self] snap in
           
            guard let s = self else {
                return
            }
            
            print(
                "CacheProgress:",
                "observe: SUCCESSFULLY DOWNLOADED"
            )
            
            s.delegate?.onSuccess()
            
        }
        
    }
    
}
