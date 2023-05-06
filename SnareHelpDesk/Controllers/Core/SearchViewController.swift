//
//  SearchViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit

class SearchViewController: UIViewController {

    private var items: [ItemElement] = [ItemElement]()

    @IBOutlet weak var discoverTableView: UITableView! {
        didSet{
            discoverTableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        }
    }

    private let searchController: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.placeholder = "Enter the Snare name"
        sb.searchBar.searchBarStyle = .minimal
        return sb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title  = "検索"
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
    }

}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            let vc = StoryboardScene.ItemPreviewViewController.initialScene.instantiate()
            let model = self?.items[indexPath.row].Item
            vc.model = model
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating{

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else{return}
        APICaller.shared.getSearchSnare(with: query) { [weak self] result in
            switch result {
            case .success(let items):
                self?.items = items
                DispatchQueue.main.async {
                    self?.discoverTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
