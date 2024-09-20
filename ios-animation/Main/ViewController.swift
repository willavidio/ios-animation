//
//  ViewController.swift
//  ios-animation
//
//  Created by Windy on 17/09/24.
//

import UIKit

final class ViewController: UIViewController {
    
    enum Section: Int, Hashable {
        case basic = 0
        case example
        
        var title: String {
            switch self {
            case .basic: "Basic Animation"
            case .example: "Example Animation"
            }
        }
    }
    
    enum AnimationType: String, Hashable, CaseIterable {
        case fadeInOut = "Fade In/Out"
        case scaling = "Scaling"
        case translation = "Translation"
        case rotation = "Rotation"
        case example1 = "Example 1"
        
        var destination: UIViewController {
            switch self {
            case .fadeInOut: FadeInOutViewController()
            case .scaling: ScaleViewController()
            case .translation: TranslationViewController()
            case .rotation: RotationViewController()
            case .example1: BasicCompositionViewController()
            }
        }
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnimationType>
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
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
        snapshot.appendSections([.basic, .example])
        snapshot.appendItems([.fadeInOut, .scaling, .translation, .rotation], toSection: .basic)
        snapshot.appendItems([.example1], toSection: .example)
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
        
        let dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: itemIdentifier
                )
            }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, _, indexPath in
            let section = Section(rawValue: indexPath.section)!
            var content = supplementaryView.defaultContentConfiguration()
            content.text = section.title
            supplementaryView.contentConfiguration = content
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        return dataSource
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = dataSource.snapshot(for: section).items[indexPath.item]
        let destination = item.destination
        destination.title = item.rawValue
        destination.view.backgroundColor = .systemBackground
        destination.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(destination, animated: true)
    }
}
