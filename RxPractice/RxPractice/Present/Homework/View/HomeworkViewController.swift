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
        let input = HomeworkViewModel.Input(tableViewCellTap: tableView.rx.itemSelected,
                                            searchBarReturnTap: searchBar.rx.searchButtonClicked,
                                            searchBarText: searchBar.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
        //tableView Datasource 변경 시
        output.tableDatasource
            .bind(to: tableView.rx.items(
                cellIdentifier: PersonTableViewCell.identifier,
                cellType: PersonTableViewCell.self)
            ) { row, element, cell in
                let processor = DownsamplingImageProcessor(size: cell.profileImageView.bounds.size)
                cell.profileImageView.kf.setImage(
                    with: URL(string: output.tableDatasource.value[row].profileImage),
                    placeholder: UIImage(named: "placeholderImage"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )
                cell.usernameLabel.text = output.tableDatasource.value[row].name
                cell.detailButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let title = output.tableDatasource.value[row].name
                        owner.navigationController?.pushViewController(DetailViewController(buttonTitle: title), animated: true)
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        //tableview cell 클릭 시
        output.tableViewCellTap
            .bind(with: self) { owner, indexPath in
                print(output.tableDatasource.value[indexPath.row])
                let data = output.tableDatasource.value[indexPath.row].name
                
                //collectionView 데이터 중복 방지
                if !output.collectionDatasource.value.contains(data) {
                    var dataSource = output.collectionDatasource.value
                    dataSource.append(data)
                    output.collectionDatasource.accept(dataSource)
                }
            }.disposed(by: disposeBag)
        
        
        //collectionView Datasource 변경 시
        output.collectionDatasource
            .bind(to: collectionView.rx.items(
                    cellIdentifier: UserCollectionViewCell.identifier,
                    cellType: UserCollectionViewCell.self))
        { index, model, cell in
            cell.configureCell(text: output.collectionDatasource.value[index])
        }.disposed(by: disposeBag)
        
        
        //searchBar 리턴 클릭 시
        //searchButtonClicked: 이는 searchBar 공백 시 동작하지 않음
            //.withLatestFrom(searchBar.rx.text.orEmpty) 를 사용해도 애초에 리턴 클릭 시 발생하는 이벤트 이기에 동작 못함
        output.searchBarReturnTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance) //1초 이후 동작 수행
            .bind(with: self) { owner, _ in
                let text = owner.searchBar.text ?? ""
                print("current text: \(text)")
                output.tableDatasource.accept(Person.dummy.filter {
                    $0.name.uppercased().contains(text.uppercased())
                })
            }.disposed(by: disposeBag)

        
        //MARK: - 필수과제 추가구현
        //+@ searchBar 공백 시
        output.searchBarText
            .bind(with: self) { owner, text in
                if text == "" {
                    output.tableDatasource.accept(Person.dummy)
                }
            }.disposed(by: disposeBag)
        
        /*
        //+@ 실시간 검색
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, searchText in
                print(searchText)ㅅ
                (searchText == "") ?
                owner.tableDatasource.accept(Person.dummy) :
                owner.tableDatasource.accept(owner.tableDatasource.value.filter {
                    $0.name.uppercased().contains(searchText.uppercased())
                })
            }.disposed(by: disposeBag)
        
        
        //+@ 서치바 리턴 시 테이블 뷰 데이터 소스 추가
        searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in
                let randomPerson = Person.randomImageEmailData()
                var dataSource = Person.dummy
         dataSource.insert(Person(name: owner.searchBar.text ?? "", email: randomPerson.email, profileImage: randomPerson.profileImage), at: 0)
                owner.tableDatasource.accept(dataSource)
                owner.searchBar.text = "" //추가 되면 serarchBar text 초기화
            }.disposed(by: disposeBag)
         */
        
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }

}

