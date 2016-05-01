//
//  TERWord.swift
//  TERTranslateEngRus
//
//  Created by Константин on 01.05.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

class TERWord: NSObject {

    let word_en: String?
    let word_ru: String?
    
    init(word_en: String, word_ru: String) {
        self.word_en = word_en
        self.word_ru = word_ru
    }
}
