//
//  LoginViewController.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/10/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var vietnamView: UIView!
    @IBOutlet weak var usaView: UIView!
    
    @IBOutlet weak var vietnameImageView: UIImageView!
    @IBOutlet weak var usaImageView: UIImageView!
    
    @IBOutlet weak var particleView: SKView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setShadowView(view: loginView)
        setShadowButton(button: loginButton, cornerRadius: 8)
        
        setShadowView(view: vietnamView, cornerRadius: 8)
        setShadowView(view: usaView, cornerRadius: 8)
        
        vietnameImageView.roundCorners(corners: .allCorners, radius: 8)
        usaView.roundCorners(corners: .allCorners, radius: 8)
        
        if let language = UserDefaults.standard.string(forKey: UserDefaultKey.currentLanguage) {
            LocalizationHandlerUtil.shareInstance().setLanguageIdentifier(language)
            if language == "vi" {
                vietnamView.alpha = 1
                usaView.alpha = 0.5
            } else {
                vietnamView.alpha = 0.5
                usaView.alpha = 1
            }
        }
        
    }
    
    //    override var shouldAutorotate: Bool {
    //        return true
    //    }
    //
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        if UIDevice.current.userInterfaceIdiom == .phone {
    //            return .allButUpsideDown
    //        } else {
    //            return .all
    //        }
    //    }
    //
    //    override var prefersStatusBarHidden: Bool {
    //        return true
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let particleScene = SKScene(fileNamed: "ParticleScene") {
            particleView.presentScene(particleScene)
        }
    }
    
    @IBAction func tapChooseVietNam(_ sender: Any) {
        LocalizationHandlerUtil.shareInstance().setLanguageIdentifier("vi")
        
        let current = "vi"
        UserDefaults.standard.set(current, forKey: UserDefaultKey.currentLanguage)
        
        vietnamView.alpha = 1
        usaView.alpha = 0.5
    }
    @IBAction func tapChooseUSA(_ sender: Any) {
        LocalizationHandlerUtil.shareInstance().setLanguageIdentifier("en")
        let current = "en"
        UserDefaults.standard.set(current, forKey: UserDefaultKey.currentLanguage)
        
        vietnamView.alpha = 0.5
        usaView.alpha = 1
    }
    
    @IBAction func tapLogin(_ sender: Any) {
        title = ""
        let vc = Storyboard.Main.mealTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

enum ChooseLanguage: String {
    case vi = "vi"
    case en = "en"
}
