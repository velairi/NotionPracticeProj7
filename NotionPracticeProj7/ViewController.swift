//
//  ViewController.swift
//  NotionPracticeProj7
//
//  Created by Valerie Don on 9/26/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Views

    lazy var searchField: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.placeholder = "Search Notion..."
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "searchCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    // MARK: - Attributes

    var objects: [NotionObject] = []

    // MARK: - Lifecycle

    override func loadView() {
        let view = UIView(frame: .zero)
        view.backgroundColor = .lightGray
        view.addSubview(collectionView)
        view.addSubview(searchField)
        self.view = view
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchField.heightAnchor.constraint(equalToConstant: 42),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }

    @objc
    func editingChanged(_ textfield: UITextField) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(debounce),
            object: nil
        )
        perform(#selector(debounce), with: nil, afterDelay: 1)
    }

    @objc
    func debounce() {
        guard let query = searchField.text else { return }
        let searchRequest = SearchRequest(query: query, sort: Sort(direction: .ascending, timestamp: "last_edited_time"))
        NotionAPI.search(searchRequest).execute(forResponse: SearchResults.self) { [weak self] result in
            switch result {
            case .success(let searchResult):
                DispatchQueue.main.async {
                    self?.objects = searchResult.results
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                break
            }
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: UIScreen.main.coordinateSpace.bounds.width,
            height: 56
        )
    }
}

extension ViewController: UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let searchCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "searchCell",
                for: indexPath
            ) as? SearchCell
            else {
                fatalError("Must dequeue SearchCell")
        }
        searchCell.model = objects[indexPath.row]
        return searchCell
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        objects.count
    }
}
