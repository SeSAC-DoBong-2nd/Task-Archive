//
//  HomeworkViewController.swift
//  RxSwift
//
//  Created by Jack on 1/30/25.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher
import SnapKit

final class HomeworkViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel: HomeworkViewModel
    private let disposeBag = DisposeBag()
    private lazy var tableDatasource = BehaviorRelay(value: viewModel.tableViewDatasource)
    private lazy var collectionDatasource = BehaviorRelay(value: viewModel.collectionViewDatasource)
    
    
    //MARK: - UI Properties
    private let tableView = UITableView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let searchBar = UISearchBar()
    
    //MARK: - Init
    init(viewModel: HomeworkViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
         
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        //tableView Datasource 변경 시
        tableDatasource
            .bind(to: tableView.rx.items(
                cellIdentifier: PersonTableViewCell.identifier,
                cellType: PersonTableViewCell.self)
            ) {row, element, cell in
                let processor = DownsamplingImageProcessor(size: cell.profileImageView.bounds.size)
                cell.profileImageView.kf.setImage(
                    with: URL(string: self.tableDatasource.value[row].profileImage),
                    placeholder: UIImage(named: "placeholderImage"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )
                cell.usernameLabel.text = self.tableDatasource.value[row].name
                cell.detailButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let title = owner.tableDatasource.value[row].name
                        owner.navigationController?.pushViewController(DetailViewController(buttonTitle: title), animated: true)
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        //tableview cell 클릭 시
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                print(owner.tableDatasource.value[indexPath.row])
                let data = owner.tableDatasource.value[indexPath.row].name
                if !owner.viewModel.collectionViewDatasource.contains(data) { //collectionView 데이터 중복 방지
                    owner.viewModel.collectionViewDatasource.append(data)
                    owner.collectionDatasource.accept(owner.viewModel.collectionViewDatasource)
                }
            }.disposed(by: disposeBag)
        
        
        //collectionView Datasource 변경 시
        collectionDatasource
            .bind(to: collectionView.rx.items(
                    cellIdentifier: UserCollectionViewCell.identifier,
                    cellType: UserCollectionViewCell.self))
        { index, model, cell in
            cell.configureCell(text: self.collectionDatasource.value[index])
        }.disposed(by: disposeBag)
        
        
        //searchBar 리턴 클릭 시
        searchBar.rx.searchButtonClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance) //1초 이후 동작 수행
            .bind(with: self) { owner, _ in
                let text = owner.searchBar.text ?? ""
                (text == "") ?
                owner.tableDatasource.accept(owner.viewModel.tableViewDatasource) :
                owner.tableDatasource.accept(owner.tableDatasource.value.filter {
                    $0.name.uppercased().contains(text.uppercased())
                })
            }.disposed(by: disposeBag)
        
        
        
        let input = HomeworkViewModel.Input()
        
        let output = viewModel.transform(input: )
        
        
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }

}
 
private extension HomeworkViewController {
    
    //필수과제 추가구현
    func additionalBind() {
        //+@ 실시간 검색
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, searchText in
                print(searchText)
                (searchText == "") ?
                owner.tableDatasource.accept(owner.viewModel.tableViewDatasource) :
                owner.tableDatasource.accept(owner.tableDatasource.value.filter {
                    $0.name.uppercased().contains(searchText.uppercased())
                })
            }.disposed(by: disposeBag)
        
        
        //+@ 서치바 리턴 시 테이블 뷰 데이터 소스 추가
        searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in
                let randomPerson = Person.randomImageEmailData()
                owner.viewModel.tableViewDatasource.insert(Person(name: owner.searchBar.text ?? "", email: randomPerson.email, profileImage: randomPerson.profileImage), at: 0)
                owner.tableDatasource.accept(owner.viewModel.tableViewDatasource)
                owner.searchBar.text = "" //추가 되면 serarchBar text 초기화
            }.disposed(by: disposeBag)
    }
    
}
