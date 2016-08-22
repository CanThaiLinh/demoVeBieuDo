//
//  ViewController.swift
//  VeBanDo
//
//  Created by thailinh on 8/8/16.
//  Copyright © 2016 thailinh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewBieuDo: BanDo!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.viewBieuDo.layer.masksToBounds = true
        
        self.viewBieuDo.draw([
            CellObject(value: 40, title: "1/2"),
            CellObject(value: 80, title: "2/2"),
            CellObject(value: 10, title: "3/2"),
            CellObject(value: 3, title: "4/2"),
            CellObject(value: 16, title: "5/2"),
            CellObject(value: 112, title: "6/2"),
            CellObject(value: 46, title: "7/2"),
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: 3D transition
    @IBAction func translationPress(sender: AnyObject) {
        self.viewBieuDo.translateView()
    }
    @IBAction func scalePress(sender: AnyObject) {
        self.viewBieuDo.scaleVIew()
    }
    

    @IBAction func rotatePress(sender: AnyObject) {
        self.viewBieuDo.rotateView()
    }
}

