//
//  Utility.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/24/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation


func performUIUpdateOnMain(_ updates: @escaping ()->Void){

    DispatchQueue.main.async {
        updates()
    }
}

func doInBackground(updates: @escaping()->Void){
    
    DispatchQueue.global(qos: .userInteractive).async {
        updates()
    }
}


