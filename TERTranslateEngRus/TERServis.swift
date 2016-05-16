//
//  TERServis.swift
//  TERTranslateEngRus
//
//  Created by Константин on 01.05.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

enum DataError: String {
    case UnknownWordError = "Word not found"
    case ServerError = "Error server"
}
let arrayLanguage: [String: String] = ["En": "Ru", "Ru": "En"]

class TERServis: NSObject {

    func getServisTranslate(word: String, language: String, completion: (objWord: TERWord?, error: NSString?) -> Void) {
        let strUrl = "http://api.mymemory.translated.net/get?q=\(word)&langpair=\(language)|" +
        arrayLanguage[language]!
        let ecsStr = strUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: ecsStr!)
        let request = NSURLRequest(URL: url!)
        let session = AFHTTPSessionManager()
        let task = session.dataTaskWithRequest(request) { (response, data, error) -> Void in
            if error == nil && data != nil {
                let responseData = data!["responseData"] as! [String: AnyObject]
                let transletedText = (responseData["translatedText"] as! String).lowercaseString.capitalizedString
                if (word == transletedText) {
                    let objWord = TERWord(wordEn: DataError.UnknownWordError.rawValue, wordRu: "error")
                    completion(objWord: objWord, error: DataError.UnknownWordError.rawValue)
                } else {
                    let wordEn: String?
                    let wordRu: String?
                    if language == "En" {
                        wordEn = word
                        wordRu = transletedText
                    } else {
                        wordEn = transletedText
                        wordRu = word
                    }
                    let objWord = TERWord(wordEn: wordEn!, wordRu: wordRu!)
                    completion(objWord: objWord, error: nil)
                }
            }
            if error != nil {
                let objWord = TERWord(wordEn: DataError.ServerError.rawValue, wordRu: "error")
                completion(objWord: objWord, error: error?.localizedDescription)
            }
        }
        task.resume()
    }

}
