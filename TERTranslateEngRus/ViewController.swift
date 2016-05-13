//
//  ViewController.swift
//  TERTranslateEngRus
//
//  Created by Константин on 01.05.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating /*, UISearchBarDelegate*/ {
    
    var arrayTranslate = [TERWord]()
    var searchResultController: UISearchController!
    var searchText = ""
    var currentLanguage = "En"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        self.navigationController?.navigationBarHidden = true
        searchResultController = UISearchController(searchResultsController: nil)
        searchResultController.searchResultsUpdater = self
        searchResultController.searchBar.placeholder = nil
        searchResultController.dimsBackgroundDuringPresentation = false
        searchResultController.searchBar.sizeToFit()
//        searchResultController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = searchResultController.searchBar
        setCurrentLanguage()
        let cache = TERCache(currentLanguage: self.currentLanguage)
        self.arrayTranslate = cache.getAllTranslate()
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
    
    func keyboardWillShow(notification: NSNotification) {
        let dictionary = notification.userInfo
        let keyBoardFrameBegin = dictionary!["UIKeyboardFrameBeginUserInfoKey"]
        let keyBoardSize = keyBoardFrameBegin?.CGRectValue.size
        let heightKeyboard = keyBoardSize?.height
        
        let insetTableView = tableView.contentInset
        let insetBottomTableView = insetTableView.bottom + heightKeyboard!
        tableView.contentInset = UIEdgeInsetsMake(insetTableView.top, insetTableView.left, insetBottomTableView, insetTableView.right)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsetsZero
        //let dictionary = notification.userInfo
//        let keyBoardFrameBegin = dictionary!["UIKeyboardFrameEndUserInfoKey"]
//        let keyBoardSize = keyBoardFrameBegin?.CGRectValue.size
//        let heightKeyboard = keyBoardSize?.height
//        
//        let insetTableView = tableView.contentInset
//        let insetBottomTableView = insetTableView.bottom + heightKeyboard!
//        tableView.contentInset = UIEdgeInsetsMake(insetTableView.top, insetTableView.left, insetBottomTableView, insetTableView.right)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setCurrentLanguage() {
        let searchBarMode = searchResultController.searchBar.textInputMode
        let doubleLang = searchBarMode?.primaryLanguage
        if doubleLang == "en-US" {
            self.currentLanguage = "En"
        } else if doubleLang == "ru-RU" {
            self.currentLanguage = "Ru"
        }
    }

    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTranslate.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ident = "identWord"
        let cell = tableView.dequeueReusableCellWithIdentifier(ident)
        let objWord: TERWord = self.arrayTranslate[indexPath.row]
        if (self.currentLanguage == "En") {
            cell!.textLabel?.text = objWord.wordEn
        } else {
            cell!.textLabel?.text = objWord.wordRu
        }
        return cell!
    }
    
    // MARK: - UISearchResultsUpdating

//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        let stringSearch = searchBar.text?.lowercaseString.capitalizedString
//    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        let lang = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)!
//        let language = NSLocale.preferredLanguages()
        
        setCurrentLanguage()
        let stringSearch = searchController.searchBar.text?.lowercaseString.capitalizedString
        let cache = TERCache(currentLanguage: self.currentLanguage)
//        if let tempStr = stringSearch {
//            stringSearch = tempStr
//        if stringSearch!.characters.count == 0 && self.searchText != "" {
//            stringSearch = self.searchText
//            self.searchResultController.searchBar.text = stringSearch
//        }
        
        if stringSearch!.characters.count > 0 {
            self.searchText = stringSearch!
            cache.getAllWordsPattern(stringSearch!, language: self.currentLanguage, completion: { (translateWords/*, error*/) in
                //if (error == nil) {
                self.arrayTranslate = translateWords
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                /*} else {
                print(DataError.UnknownWordError.rawValue)
                }*/
            })
        } else {
            self.arrayTranslate = cache.getAllTranslate()
            self.tableView.reloadData()
        }
        
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

