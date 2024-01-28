//
//  CacheProgress.swift
//  SPOK
//
//  Created by GoodDamn on 27/01/2024.
//

import Foundation
import FirebaseStorage

class CacheProgress<T>
    : CacheFile<T> {
    
    private var mDownloadTask: StorageDownloadTask? = nil
    
    public func stopDownloading() {
        mDownloadTask?.cancel()
    }
    
    override func onUpdateCache() {
        
        var delegate = delegate as? CacheProgressListener
        
        delegate?.onPrepareDownload()
        
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
                        
            delegate?.onWrittenStorage()
        }
        
        mDownloadTask?.observe(
            .progress
        ) { snap in
            
            guard let pr = snap.progress else {
                return
            }
            
            let percent = 100 * Double(
                pr.completedUnitCount
            ) / Double(pr.totalUnitCount)
            
            delegate?.onProgress(
                percent: percent
            )
        }
        
        mDownloadTask?.observe(
            .failure
        ) {snap in

            print(
                "CacheProgress:",
                "observe:FAIL:",
                snap.error
            )
            
            delegate?.onError()
            
        }
        
        mDownloadTask?.observe(
            .success
        ) {snap in
            
            print(
                "CacheProgress:",
                "observe: SUCCESSFULLY DOWNLOADED"
            )
            
            delegate?.onSuccess()
            
        }
        
    }
    
}
