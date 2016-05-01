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

class TERServis: NSObject {
    let arrayLanguage: [String: String] = ["en": "ru", "ru": "en"]

    func getTranslate(word: String, language: String, completion: (words: [TERWord]?, error: NSError?) -> Void) {
        let strUrl = "http://api.mymemory.translated.net/get?q=\(word)&langpair=\(language)|" +
        arrayLanguage[language]!
        let ecsStr = strUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: ecsStr!)
        let request = NSURLRequest(URL: url!)
        let session = AFHTTPSessionManager()
        let task = session.dataTaskWithRequest(request) { (response, data, error) -> Void in
            if error == nil && data != nil {
                let matches = data!["matches"] as! [AnyObject]
                print(matches[0]["translation"])
            }
            if error != nil {
                
            }
        }
        task.resume()
    }
}
