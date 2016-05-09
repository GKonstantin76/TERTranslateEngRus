//
//  ViewController.swift
//  TERTranslateEngRus
//
//  Created by Константин on 01.05.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    var arrayTranslate = [TERWord]()
    var searchResultController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultController = UISearchController(searchResultsController: nil)
        searchResultController.searchResultsUpdater = self
        searchResultController.searchBar.placeholder = nil
        searchResultController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchResultController.searchBar
        let cache = TERCache()
        arrayTranslate = cache.getAllTranslate()
        // Do any additional setup after loading the view, typically from a nib.
        //let cache = TERCache()
        //cache.getTranslate("ball", language: "En") { (words, error) in
//            self.arrayTranslate = cache.getAllTranslate()
//            for objWord in self.arrayTranslate {
//                print(objWord.wordEn)
//                print(objWord.wordRu)
//            }
        //}
        
//        let coreData = TERCoreData()
//        let array = coreData.getTranslateAllWordsFromCoreData("b", language: "En")
//        for objWord in array {
//            print(objWord.wordEn)
//            print(objWord.wordRu)
//        }
    }

    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTranslate.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ident = "identWord"
        let cell = tableView.dequeueReusableCellWithIdentifier(ident)
        let objWord: TERWord = self.arrayTranslate[indexPath.row]
        //if ()
        cell!.textLabel?.text = objWord.wordEn
        return cell!
    }
    
    // MARK: - UISearchResultsUpdating

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var stringSearch = searchController.searchBar.text?.lowercaseString.capitalizedString
        if stringSearch!.characters.count == 0 {
            stringSearch = ""
        }
            let cache = TERCache()
            cache.getAllWordsPattern(stringSearch!, language: "En", completion: { (translateWords/*, error*/) in
                //if (error == nil) {
                    self.arrayTranslate = translateWords
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                /*} else {
                    print(DataError.UnknownWordError.rawValue)
                }*/
            })
        
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let story = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
        let translateController: TERTranslateController = story.instantiateViewControllerWithIdentifier("TranslateWindow") as! TERTranslateController
        let objWord = arrayTranslate[indexPath.row]
        
        translateController.objWord = objWord
        self.navigationController?.presentViewController(translateController, animated: true, completion: nil)
    }
    
}

