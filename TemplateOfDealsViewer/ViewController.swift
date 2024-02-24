import UIKit

class ViewController: UIViewController {
  private let server = Server()
  private var model: [Deal] = []
    
  private var isAscending = true
    
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Deals"
    
    tableView.register(UINib(nibName: DealCell.reuseIidentifier, bundle: nil), forCellReuseIdentifier: DealCell.reuseIidentifier)
      tableView.register(NewHeaderCell.self, forHeaderFooterViewReuseIdentifier: NewHeaderCell.reuseIidentifier)

    tableView.dataSource = self
    tableView.delegate = self
    
    server.subscribeToDeals { deals in
      self.model.append(contentsOf: deals)
      self.tableView.reloadData()
    }
      
    sortAscending(field: .date)
  }
    
    // сортировка по возрастанию
    func sortAscending(field: SortField) {
        switch field {
        case .instrument:
            model.sort { $0.instrumentName < $1.instrumentName }
            tableView.reloadData()
        case .price:
            model.sort { $0.price < $1.price }
            tableView.reloadData()
        case .amount:
            model.sort { $0.amount < $1.amount }
            tableView.reloadData()
        case .side:
            model.sort { $0.side < $1.side }
            tableView.reloadData()
        case .date:
            model.sort { $0.dateModifier < $1.dateModifier }
            tableView.reloadData()
        }
    }
    // сортировка по убыванию
    func sortDescending(field: SortField) {
        switch field {
        case .instrument:
            model.sort { $0.instrumentName > $1.instrumentName }
            tableView.reloadData()
        case .price:
            model.sort { $0.price > $1.price }
            tableView.reloadData()
        case .amount:
            model.sort { $0.amount > $1.amount }
            tableView.reloadData()
        case .side:
            model.sort { $0.side > $1.side }
            tableView.reloadData()
        case .date:
            model.sort { $0.dateModifier > $1.dateModifier }
            tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      model.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: DealCell.reuseIidentifier, for: indexPath) as! DealCell
    
    let deal = model[indexPath.row]
    
    cell.dateLabel.text = deal.dateModifier.formatted(.dateTime)
      
    cell.instrumentNameLabel.text = deal.instrumentName
    cell.priceLabel.text = String(format: "%.2f", deal.price)
    cell.amountLabel.text = String(format: "%.0f", deal.amount)
      
    switch deal.side {
      case .sell:
          cell.sideLabel.text = "Sell"
          cell.sideLabel.textColor = UIColor.red
      case .buy:
          cell.sideLabel.text = "Buy"
          cell.sideLabel.textColor = UIColor.green
      }
      
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewHeaderCell.reuseIidentifier) as? NewHeaderCell else {
          return nil
      }
      
      headerView.sortActionUp = { field in
          self.sortAscending(field: field)
      }
      
      headerView.sortActionDown = { field in
          self.sortDescending(field: field)
      }
      return headerView
  }
}

