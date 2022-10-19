//
//  ViewController.swift
//  CombileDemo
//
//  Created by Genusys Inc on 10/19/22.
//

import UIKit
import Combine

class TVC:UITableViewCell{
    
    static let identifire = "tvc"
    private let btn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemPink
        btn.setTitle("Button", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    let actions = PassthroughSubject<String,Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(btn)
        btn.addTarget(self, action: #selector(onTappedBtn), for: .touchUpInside)
    }
    
    @objc func onTappedBtn(){
        actions.send("Helo world")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        btn.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 6)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class ViewController: UIViewController {

    private let tableView:UITableView = {
        let tbl = UITableView()
        tbl.register(TVC.self, forCellReuseIdentifier: TVC.identifire)
        return tbl
    }()
    
    private var observers = [AnyCancellable]()
    
    private var models = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        APICaller.shared.fetchCompanies()
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion:{ completion in
            switch completion{
            case .finished:
                print("finished")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, receiveValue: {[weak self] responsedata in
            self?.models = responsedata
            self?.tableView.reloadData()
        }).store(in: &observers)

    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TVC.identifire, for: indexPath) as! TVC
                
        cell.actions.sink { str in
            print(str)
        }.store(in: &observers)
        
        return cell
    }
    
    
}
