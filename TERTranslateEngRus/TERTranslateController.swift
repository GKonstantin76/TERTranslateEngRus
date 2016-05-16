//
//  TERTranslateController.swift
//  TERTranslateEngRus
//
//  Created by Константин on 05.05.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

class TERTranslateController: UIViewController {
    
    var objWord: TERWord?
    @IBOutlet weak var lbWordSource: UILabel!
    @IBOutlet weak var lbWordDestination: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lbWordSource.text = objWord?.wordEn?.lowercaseString.capitalizedString
        lbWordDestination.text = objWord?.wordRu?.lowercaseString.capitalizedString
    }

    @IBAction func actionBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
