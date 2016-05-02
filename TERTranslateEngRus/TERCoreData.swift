//
//  TERCoreData.swift
//  TERTranslateEngRus
//
//  Created by Константин on 01.05.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

class TERCoreData: NSObject {
    func getAllTranslate() -> [TERWord] {
        let arrayDictionaryEntity = DictionaryEntity.findAll() as! [DictionaryEntity]
        var arrayTranslate = [TERWord]()
        for translate in arrayDictionaryEntity {
            let word = TERWord(wordEn: translate.wordEn, wordRu: translate.wordRu)
            arrayTranslate.append(word)
        }
        return arrayTranslate
    }
    
    func getTranslateWordFromCoreData(word: String, language: String) -> TERWord {
        var wordEn: String?
        var wordRu: String?
        if language == "en" {
            wordEn = word
            wordRu = ""
        } else {
            wordEn = ""
            wordRu = word
        }
        let predicate = NSPredicate(format: "word" + language + "=%@", word)
        let arrayDictionary = DictionaryEntity.findAllWithPredicate(predicate) as![DictionaryEntity]
        let word: TERWord
        if arrayDictionary.count > 0 {
            if language == "en" {
                wordRu = arrayDictionary[0].wordRu
            } else {
                wordEn = arrayDictionary[0].wordEn
            }
            word = TERWord(wordEn: wordEn!, wordRu: wordRu!)
        } else {
            word = TERWord(wordEn: "", wordRu: "")
        }
        return word
    }
    func createTranslate(objWord: TERWord) {
        let dictionaryEntity = DictionaryEntity.createEntity() as! DictionaryEntity
        dictionaryEntity.wordEn = objWord.wordEn!
        dictionaryEntity.wordRu = objWord.wordRu!
        NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
    }
}
