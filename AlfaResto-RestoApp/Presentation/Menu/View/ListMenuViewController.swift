//
//  ListMenuViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 17/06/24.
//

import UIKit
import RxSwift

final class ListMenuViewController: UIViewController {
    
    @IBOutlet private weak var listMenuCollectionView: UICollectionView!
    @IBOutlet private weak var noMenuImageView: UIImageView!
    
    private let padding: CGFloat = 22.0
    private let dependencies = RestoAppDIContainer()
    private let disposeBag = DisposeBag()
    
    private lazy var menuViewModel = dependencies.makeMenuViewModel()
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getAllMenu()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

extension ListMenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuViewModel.menus?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListMenuItemCell.reuseID, for: indexPath) as? ListMenuItemCell,
              let menus = menuViewModel.menus
        else { return UICollectionViewCell() }
        do {
            try cell.configure(menu: menus.item(at: indexPath.row))
        } catch {
            print("Index out of range")
        }
        return cell
    }
}

extension ListMenuViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: padding, bottom: 10, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = listMenuCollectionView.frame.width
        let cellWidth = collectionViewWidth - (2 * padding)
        return CGSize(width: cellWidth, height: 120)
    }
}

private extension ListMenuViewController {
    
    func setup() {
        listMenuCollectionView.dataSource = self
        listMenuCollectionView.delegate = self
        
        hideNoMenuImage()
                
        setupNib()
        setupObserver()
    }
    
    func setupNib() {
        let nib = UINib(nibName: ListMenuItemCell.reuseID, bundle: nil)
        listMenuCollectionView.register(nib, forCellWithReuseIdentifier: ListMenuItemCell.reuseID)
    }
    
    func setupObserver() {
        menuViewModel.menuObservable.subscribe { [weak self] event in
            guard let self else { return }
            switch event {
            case .next(.success):
                self.listMenuCollectionView.reloadData()
                DispatchQueue.main.async {
                    self.hideNoMenuImage()
                }
            case .next(.failure(_)):
                hideNoMenuImage()
            default:
                break
            }
        }.disposed(by: self.disposeBag)
    }
    
    func hideNoMenuImage() {
        DispatchQueue.main.async {
            self.noMenuImageView.isHidden = ((self.menuViewModel.menus?.count ?? 0) != 0)
        }
    }
    
    func getAllMenu() {
        menuViewModel.getAllMenu()
    }
}
