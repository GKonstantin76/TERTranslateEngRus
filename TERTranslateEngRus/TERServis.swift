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
    case ParseError = "Error parse"
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
                let transletedText = responseData["translatedText"] as! String
                if (word == transletedText) {
                    completion(objWord: nil, error: DataError.UnknownWordError.rawValue)
                } else {
                    let wordEn: String?
                    let wordRu: String?
                    if language == "en" {
                        wordEn = word
                        wordRu = transletedText
                    } else {
                        wordEn = transletedText
                        wordRu = word
                    }
                    let objWord = TERWord(wordEn: wordEn!, wordRu: wordRu!)
                    //                let objWord = TERWord(word_en: word, word_ru: word)
                    //print(objWord)
                    completion(objWord: objWord, error: nil)
                }
                //print(matches[0]["translation"])
            }
            if error != nil {
                
            }//*/
        }
        task.resume()
    }

}
