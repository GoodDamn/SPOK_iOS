//
//  TrainingsConfig.swift
//  SPOK
//
//  Created by Cell on 10.07.2022.
//

import FirebaseDatabase;
import UIKit;

class TopicsConfig{
    
    static func isNew(
        _ id: Int,
        _ cell:MCellCollectionView
    ) {
        /*if Utils.isNewTraining(id){
            cell.l_new.isHidden = false;
            cell.l_new.layer.cornerRadius = cell.l_new.frame.height/2.25;
            return;
        }*/
        cell.l_new.isHidden = true;
    }
    
    static func isPremium(
        _ id: Int,
        _ cell:MCellCollectionView,
        isPrem: Bool
    ) {
        //let m = Utils.getManager();
        cell.padlock.isHidden = !isPrem;
        cell.heartTop.constant = isPrem ? 45.0 : 15.0;
        /*if (m != nil && m!.isPremiumUser) {
            cell.padlock.isHidden = true;
            cell.heartTop.constant = 15.0;
        }*/
    }
}
