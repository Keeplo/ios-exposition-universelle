//
//  Expo1900 - ExpositionViewController.swift
//  Created by Marco, Soll, Yescoach.
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ExpositionViewController: UIViewController {
    
    // MARK: @IBOutlets
    @IBOutlet weak var titleLabel: CustomUILabel!
    @IBOutlet weak var visitorsLabel: CustomUILabel!
    @IBOutlet weak var locationLabel: CustomUILabel!
    @IBOutlet weak var durationLabel: CustomUILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Properties
    private var exposition: Exposition? {
        didSet {
            // 여기가 동작
            self.updateUI()
        } // 옵져버 KVO
    }
    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private let numberFormatter = NumberFormatter()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = .decimal
        
        exposition = fetchExpositionData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.changeMask(.portrait)
        
        let orientation = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appDelegate.changeMask(.all)
    }
    
    // MARK: Functions
    private func fetchExpositionData() -> Exposition? {
        let jsonDecoder = JSONDecoder()
        let expositionDataIdentifier = "exposition_universelle_1900"
        
        guard let dataAsset = NSDataAsset(name: expositionDataIdentifier) else {
            return nil
        }
        do {
            let decodedData = try jsonDecoder.decode(Exposition.self, from: dataAsset.data)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func updateUI() {
        titleLabel.text = exposition?.divideTitle()
        guard let visitors = exposition?.visitors,
              let stringNumber = numberFormatter.string(from: NSNumber(value: visitors)) else {
            return
        }
        visitorsLabel.text = stringNumber
        locationLabel.text = exposition?.location
        durationLabel.text = exposition?.duration
        descriptionLabel.text = exposition?.description
    }
}

class CustomUILabel: UILabel, CustomLabelable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabelAutoSizeFont()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLabelAutoSizeFont()
    }
}

protocol CustomLabelable: CustomUILabel {
    func setLabelAutoSizeFont()
}

extension CustomLabelable where Self: UILabel {
    func setLabelAutoSizeFont(){
        self.adjustsFontSizeToFitWidth = true
    }
}
