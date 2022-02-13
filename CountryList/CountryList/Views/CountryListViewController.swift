//
//  CountryListViewController.swift
//  CountryList
//
//  Created by Christi John on 09/02/2022.
//

import UIKit

class CountryListViewController: UIViewController {
    private struct Constants {
        static let title = "Countries"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: CountryListViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        //
        // Bind view controller with viewmodel
        bindViewModel()
    }

}

// MARK:- Custom Methods

extension CountryListViewController {
    func configureUI() {
        self.title = Constants.title
        
        // Configure Searchbar
        //
        searchBar.searchTextField.font = .systemFont(ofSize: 13.0,
                                                     weight: .light)
        searchBar.delegate = self
        
        // Configure Tableview
        //
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Method to bind View & Viewmodel
    // Using closures to communicate from VM to View
    //
    func bindViewModel() {
        // Initialize view model object
        //
        viewModel = CountryListViewModel()
        
        // API success closure binding
        //
        viewModel?.onAPISuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.tableView.reloadData()
            }
        }
        
        // API failure handling closure binding
        //
        viewModel?.onAPIError = { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.showAlert(title: error.errorDescription, message: nil, cancelTitle: "OK")
            }
        }
        
        // Call to get items from API
        //
        viewModel?.getCountryList()
        showLoader()
    }
    
    // Method to show loader when API in progress
    //
    func showLoader() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    // Method to hide loader when API call completed
    //
    func hideLoader() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    // Method used to push to the detail page
    // Create a detail view model and pass to VC
    //
    func pushToDetailVC(_ vm: CountryListCellViewModelProtocol?) {
        guard let vm = vm else { return }
        let detailsVM = CountryDetailViewModel(vm.country)
        let vc = self.storyboard?.instantiateViewController(
            identifier: StoryboardId.countryDetails) as! CountryDetailViewController
        vc.viewModel = detailsVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK:- UITableView Delegate Methods

extension CountryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(
            CountryListTableViewCell.self, indexPath: indexPath)
        let cellViewModel = viewModel?
            .getCountryListCellModel(for: indexPath.row)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let selected = viewModel?.getCountryListCellModel(for: indexPath.row)
        pushToDetailVC(selected)
    }
}

extension CountryListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        viewModel?.filterCountries(searchText)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension CountryListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
