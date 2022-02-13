//
//  CountryListTableViewCell.swift
//  CountryList
//
//  Created by Christi John on 09/02/2022.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    var viewModel: CountryListCellViewModelProtocol? {
        didSet {
            nameLabel.text = viewModel?.name
            viewModel?.fetchImage { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.flagImageView.image = image
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        flagImageView.image = UIImage(named: CLImage.placeHolder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        flagImageView.image = UIImage(named: CLImage.placeHolder)
    }
}
