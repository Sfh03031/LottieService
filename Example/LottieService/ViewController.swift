//
//  ViewController.swift
//  LottieService
//
//  Created by Sfh03031 on 02/28/2024.
//  Copyright (c) 2024 Sfh03031. All rights reserved.
//

import UIKit
import Lottie
import LottieService

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.aniView.center = self.view.center
        self.view.addSubview(self.aniView)
        
        let path = "https://ksimg.sparke.cn/images/smartBook/english/2023/7/1852229119376130624.zip"
        
        LottieService.requestLottieModel(with: URL.init(string: path)!) { [weak self] (sceneModel, error) in
            if (error != nil) {
                print(error?.localizedDescription as Any)
            } else {
                self?.aniView.sceneModel = sceneModel
                self?.aniView.play()
            }
            
        }
        
    }
    
    lazy var aniView: LOTAnimationView = {
        let view = LOTAnimationView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .orange
        view.contentMode = .scaleAspectFit
        view.loopAnimation = false
        view.animationSpeed = 0.8
        return view
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

