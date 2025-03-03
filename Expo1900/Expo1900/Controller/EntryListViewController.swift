//
//  EntryListViewController.swift
//  Expo1900
//
//  Created by Marco, Soll, Yescoach. on 2021/07/13.
//

import UIKit

class EntryListViewController: UIViewController {
    
    // MARK: @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    private var entries = [Entry]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self
        
        if let data = fetchEntryData() {
            entries = data
        } else {
            print("JSON 데이터 불러오기 실패")
        }
    }
    
    // MARK: Functions
    private func fetchEntryData() -> [Entry]? {
        let jsonDecoder = JSONDecoder()
        let entryDataIdentifier = "items"
        
        guard let dataAsset = NSDataAsset(name: entryDataIdentifier) else {
            return nil
        }
        do {
            let decodedData = try jsonDecoder.decode([Entry].self, from: dataAsset.data)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension EntryListViewController: UITableViewDataSource {
    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EntryTableViewCell.registerID,
            for: indexPath
        ) as? EntryTableViewCell else {
            return UITableViewCell()
        }
        let entry = self.entries[indexPath.row]
        cell.entryTitleLabel.text = entry.name
        cell.entryDetailLabel.text = entry.shortDescription
        
        cell.heigthConstraint.constant = cell.entryTitleLabel.bounds.height + cell.entryDetailLabel.bounds.height
        cell.entryImageView.image = UIImage(named: entry.imageName ?? "")

        return cell
    }
}

extension EntryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = entries[indexPath.row]
        if let detailVC = EntryDetailViewController.updateModel(by: selectedEntry) {
            self.navigationController?.pushViewController(detailVC, animated: false)
        } else {
            print("detailVC 인스턴스 생성 실패")
        }
    }
}
