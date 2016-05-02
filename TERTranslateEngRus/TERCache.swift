//
//  TERCache.swift
//  TERTranslateEngRus
//
//  Created by Константин on 01.05.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

class TERCache: NSObject {
    let servis = TERServis()
    let coreData = TERCoreData()
    func getTranslate(word: String, language: String, completion: (translate_word : String?, error: NSError?) -> Void) {
        let result = coreData.getTranslateWordFromCoreData(word, language: language)
        if result.wordEn == "" {
            servis.getServisTranslate(word, language: language) { (objWord, error) in
                if error == nil {
                    self.coreData.createTranslate(objWord!)
                } else {
                    print(error)
                }
            }
        }
    }
    
    func getAllTranslate() -> [TERWord] {
        return coreData.getAllTranslate()
    }
}
