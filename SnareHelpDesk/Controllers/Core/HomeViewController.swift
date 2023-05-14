//
//  ViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit
import SkeletonView

enum Sections: Int {
    case Yamaha = 0
    case Pearl = 1
    case Tama = 2
    case DW = 3
    case Ludwig = 4
}

class HomeViewController: UIViewController {

    private let sectionTitles: [String] = ["Yamaha", "Pearl", "Tama","DW","Ludwig"]

    @IBOutlet private weak var homeTableView: UITableView!{
        didSet{
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
        cell.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cell.activityIndicatorView.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        cell.delegate = self
        cell.activityIndicatorView.startAnimating()
        switch indexPath.section {
        case Sections.Yamaha.rawValue:
            APICaller.shared.getSnare(with: "Yamaha"){ result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Pearl.rawValue:
            APICaller.shared.getSnare(with: "Pearl") { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Tama.rawValue:
            APICaller.shared.getSnare(with: "Tama") { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.DW.rawValue:
            APICaller.shared.getSnare(with: "DW") { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Ludwig.rawValue:
            APICaller.shared.getSnare(with: "Ludwig") { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        default:
            return UITableViewCell()

        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
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
