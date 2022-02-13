//
//  ViewController.swift
//  CountryList
//
//  Created by Christi John on 08/02/2022.
//

import UIKit

class CountryDetailViewController: UIViewController {
    private struct Constants {
        static let title = "Country Details"
        static let defaultHeight: CGFloat = 220
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var dialCodeLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var flagImageHeightConstraint: NSLayoutConstraint!
    
    var viewModel: CountryDetailViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //
        configureUI()
    }
}

// MARK:- Custom Methods

extension CountryDetailViewController {
    func configureUI() {
        self.title = Constants.title
        
        nameLabel.text = viewModel?.name
        regionLabel.text = viewModel?.region
        capitalLabel.text = viewModel?.capital
        dialCodeLabel.text = viewModel?.dialCode
        domainLabel.text = viewModel?.domain
        
        flagImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        flagImageView.layer.borderWidth = 0.5
        
        viewModel?.fetchImage(completion: { [weak self] (image) in
            DispatchQueue.main.async {
                self?.flagImageView.image = image
                let newHeight = self?.doHeightAdjustments(UIScreen.main.bounds.width - 32,
                                                          image?.size.width,
                                                          image?.size.height)
                self?.flagImageHeightConstraint.constant = newHeight ?? Constants.defaultHeight
                self?.view.layoutIfNeeded()
            }
        })
    }
    
    /// Method to calculate height based on image aspect ratio.
    ///
    /// - Parameter image: The image object just downloaded
    ///
    func doHeightAdjustments(_ availableWidth: CGFloat?,
                             _ width: CGFloat?,
                             _ height: CGFloat?) -> CGFloat {
        if let available = availableWidth,
           let imgWidth = width,
           let imgHeight = height {
            let newHeight = (imgHeight/imgWidth) * available
            return newHeight
        }
        return Constants.defaultHeight
    }
}
