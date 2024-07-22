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
    
    private lazy var menuVM = dependencies.makeListMenuViewModel()
    
    static var storyboardID: String {
        String(describing: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        noMenuImageView.isHidden = true
    }
    
    @IBAction func addMenuButtonPressed(_ sender: UIButton) {
        let addMenuStoryboard = UIStoryboard(name: AddMenuViewController.storyboardID, bundle: nil)
        if let addMenuVC = addMenuStoryboard.instantiateViewController(withIdentifier: AddMenuViewController.storyboardID) as? AddMenuViewController {
            navigationController?.pushViewController(addMenuVC, animated: true)
        }
    }
}

extension ListMenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuVM.menus?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListMenuItemCell.reuseID, for: indexPath) as? ListMenuItemCell,
              let menus = menuVM.menus
        else { return listMenuCollectionView.dequeueReusableCell(withReuseIdentifier: listMenuCollectionView.defaultIdentifier, for: indexPath) }
        do {
            try cell.configure(menu: menus.item(at: indexPath.row))
            cell.didEditTapped = { [weak self] in
                guard let self else { return }
                try goToEditPage(vc: self, indexPath: indexPath, menus: menus)
            }
        } catch {
            debugPrint("Index out of range")
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
                
        getAllMenu()

        setupNib()
        setupObserver()
    }
    
    func setupNib() {
        let nib = UINib(nibName: ListMenuItemCell.reuseID, bundle: nil)
        
        listMenuCollectionView.registerBaseCell()
        listMenuCollectionView.register(nib, forCellWithReuseIdentifier: ListMenuItemCell.reuseID)
    }
    
    func setupObserver() {
        menuVM.menuObservable.subscribe { [weak self] event in
            guard let self else { return }
            switch event {
            case .next(.success):
                DispatchQueue.main.async {
                    self.listMenuCollectionView.reloadData()
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
        self.noMenuImageView.isHidden = ((self.menuVM.menus?.count ?? 0) != 0)
    }
    
    func getAllMenu() {
        menuVM.getAllMenu()
    }
    
    func goToEditPage(vc: UIViewController, indexPath: IndexPath, menus: [Menu]) throws {
        let editMenuStoryboard = UIStoryboard(name: EditMenuViewController.storyboardID, bundle: nil)
        
        if let editMenuVC = editMenuStoryboard.instantiateViewController(withIdentifier: EditMenuViewController.storyboardID) as? EditMenuViewController {
            editMenuVC.menu = try menus.item(at: indexPath.row)
            self.navigationController?.pushViewController(editMenuVC, animated: true)
        }
    }
}
