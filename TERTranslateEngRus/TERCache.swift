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
    func getTranslate(word: String, language: String, completion: (translateWord : TERWord, error: String?) -> Void) {
        let resultWord = coreData.getTranslateWordFromCoreData(word, language: language)
        if resultWord.wordEn! == "" {
            servis.getServisTranslate(word, language: language) { (objWord, error) in
                if error == nil {
                    self.coreData.createTranslate(objWord!)
                } else {
                    print(error)
                }
                completion(translateWord: objWord!, error: error! as String)
            }
        } else {
            completion(translateWord: resultWord, error: nil)
        }
    }
    
    func getAllTranslate() -> [TERWord] {
        return coreData.getTranslateAllWordsFromCoreData("", language: "En")
    }

    func getAllWordsPattern(pattern: String, language: String, completion: (translateWord : [TERWord]/*, error: String?*/) -> Void) {
        var resultWords = coreData.getTranslateAllWordsFromCoreData(pattern, language: language)
        if resultWords[0].wordEn! == "" {
            servis.getServisTranslate(pattern, language: language) { (objWord, error) in
//                if error == nil {
                //if objWord?.wordEn != DataError.UnknownWordError.rawValue {
 //                   self.coreData.createTranslate(objWord!)
                    resultWords[0] = objWord!
//                }
                    //else {
                    //print(error)
                //}
                completion(translateWord: resultWords)//, error: error! as String)
            }
        } else {
            completion(translateWord: resultWords/*, error: nil*/)
        }
    }
    
}
