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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
