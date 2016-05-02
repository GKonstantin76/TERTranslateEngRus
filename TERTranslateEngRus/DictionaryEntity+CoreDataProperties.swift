//
//  DictionaryEntity+CoreDataProperties.swift
//  TERTranslateEngRus
//
//  Created by Константин on 02.05.16.
//  Copyright © 2016 Константин. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DictionaryEntity {

    @NSManaged var wordEn: String
    @NSManaged var wordRu: String

}
