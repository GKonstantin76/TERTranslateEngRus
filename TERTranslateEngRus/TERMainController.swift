//
//  TERMainController.swift
//  TERTranslateEngRus
//
//  Created by Константин on 01.05.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

class TERMainController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    var arrayTranslate = [TERWord]()
    var searchResultController: UISearchController!
    var searchText = ""
    var currentLanguage = "En"
    var activityIndicator: UIActivityIndicatorView!
    var labelNavigation: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TERMainController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TERMainController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        searchResultController = UISearchController(searchResultsController: nil)
        searchResultController.searchResultsUpdater = self
        searchResultController.searchBar.placeholder = nil
        searchResultController.dimsBackgroundDuringPresentation = false
        searchResultController.searchBar.sizeToFit()
        searchResultController.hidesNavigationBarDuringPresentation = false
        searchResultController.searchBar.placeholder = "Search"
        let searchField = searchResultController.searchBar.valueForKey("searchField") as? UITextField
        searchField?.font = UIFont(name: "Arial", size: 18)
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = searchResultController.searchBar
        setCurrentLanguage()
        let cache = TERCache(currentLanguage: self.currentLanguage)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.activityIndicator.frame = CGRectMake(0, 0, 20, 20)
        let viewNavigation = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 20))
        viewNavigation.addSubview(self.activityIndicator)
        self.labelNavigation = UILabel(frame: CGRect(x: 30, y: 0, width: 300, height: 20))
        self.labelNavigation.text = "Translation English to Russian"
        viewNavigation.addSubview(self.labelNavigation)
        self.navigationItem.titleView = viewNavigation
        self.arrayTranslate = cache.getAllTranslate()
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
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setCurrentLanguage() {
        let searchBarMode = searchResultController.searchBar.textInputMode
        let doubleLang = searchBarMode?.primaryLanguage
        if doubleLang == "en-US" {
            self.currentLanguage = "En"
            self.labelNavigation.text = "Translation English to Russian"
        } else if doubleLang == "ru-RU" {
            self.currentLanguage = "Ru"
            self.labelNavigation.text = "Перевод с Русского на Английский"
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
        cell!.textLabel?.font = UIFont(name: "Arial", size: 24.0)

        if (self.currentLanguage == "En") {
            cell!.textLabel?.text = objWord.wordEn
        } else {
            cell!.textLabel?.text = objWord.wordRu
        }
        return cell!
    }
    
    // MARK: - UISearchResultsUpdating

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        setCurrentLanguage()
        let stringSearch = searchController.searchBar.text?.lowercaseString.capitalizedString
        let cache = TERCache(currentLanguage: self.currentLanguage)
        if stringSearch!.characters.count > 0 {
            self.searchText = stringSearch!
            self.activityIndicator.startAnimating()
            cache.getAllWordsPattern(stringSearch!, language: self.currentLanguage, completion: { (translateWords) in
                self.arrayTranslate = translateWords
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                })
            })
        } else {
            self.arrayTranslate = cache.getAllTranslate()
            self.tableView.reloadData()
        }
        
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let objWord = arrayTranslate[indexPath.row]
        if objWord.wordRu != "error" {
            let story = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
            let translateController: TERTranslateController = story.instantiateViewControllerWithIdentifier("TranslateWindow") as! TERTranslateController
            translateController.objWord = objWord
            self.navigationController?.presentViewController(translateController, animated: true, completion: nil)
        }
    }
    
}

