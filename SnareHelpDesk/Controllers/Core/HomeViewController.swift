//
//  ViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit
import SkeletonView

enum Sections: Int {
    case yamaha = 0
    case pearl = 1
    case tama = 2
    case dw = 3
    case ludwig = 4
}

class HomeViewController: UIViewController {

    private let sectionTitles: [String] = ["Yamaha", "Pearl", "Tama", "DW", "Ludwig"]

    @IBOutlet private weak var homeTableView: UITableView! {
        didSet {
            homeTableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableViewCell", for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.setActivityIndicatorView()
        cell.activityIndicatorView.startAnimating()

        let sectionName: String
        switch indexPath.section {
        case Sections.yamaha.rawValue:
            sectionName = "Yamaha"
        case Sections.pearl.rawValue:
            sectionName = "Pearl"
        case Sections.tama.rawValue:
            sectionName = "Tama"
        case Sections.dw.rawValue:
            sectionName = "DW"
        case Sections.ludwig.rawValue:
            sectionName = "Ludwig"
        default:
            return UITableViewCell()
        }
        loadAndConfigureCell(cell: cell, with: sectionName)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func loadAndConfigureCell(cell: CollectionViewTableViewCell, with sectionName: String) {
        APICaller.shared.getSnare(with: sectionName) { result in
            switch result {
            case .success(let titles):
                cell.configure(with: titles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, model: Item) {
        DispatchQueue.main.async { [weak self] in
            let vc = StoryboardScene.ItemPreviewViewController.initialScene.instantiate()
            vc.model = model
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
