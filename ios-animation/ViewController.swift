//
//  ViewController.swift
//  ios-animation
//
//  Created by Windy on 17/09/24.
//

import UIKit

final class ViewController: UIViewController {
    
    enum Section: Hashable {
        case main
    }
    
    enum AnimationType: String, Hashable, CaseIterable {
        case fadeIn = "Fade In/Out"
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnimationType>
    
    private lazy var collectionView: UICollectionView = {
        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        populate()
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor) ])
    }
    
    private func populate() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnimationType>()
        snapshot.appendSections([.main])
        snapshot.appendItems(AnimationType.allCases)
        dataSource.apply(snapshot)
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<
            UICollectionViewListCell,
            AnimationType
        > { cell, _, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.rawValue.capitalized
            cell.contentConfiguration = content
        }

        return DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
