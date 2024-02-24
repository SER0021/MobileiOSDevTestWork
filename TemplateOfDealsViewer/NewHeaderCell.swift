import UIKit

enum SortField {
    case instrument
    case price
    case amount
    case side
    case date
}

class NewHeaderCell: UITableViewHeaderFooterView {
    static let reuseIidentifier = "NewHeaderCell"
    
    let instrumentNameTitle = UIButton()
    let priceTitle = UIButton()
    let amountTitle = UIButton()
    let sideTitle = UIButton()
    let dateTitle = UIButton()
    
    
    private var instrumentSortUp = true
    private var priceSortUp = true
    private var amountSortUp = true
    private var sideSortUp = true
    private var dateSortUp = false
    
    var sortActionUp: ((SortField) -> Void)?
    var sortActionDown: ((SortField) -> Void)?
    
    let stackView = UIStackView()

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupButton(button: instrumentNameTitle, title: "Instrument", action: #selector(sortByInstrument))
        setupButton(button: priceTitle, title: "Price", action: #selector(sortByPrice))
        setupButton(button: amountTitle, title: "Amount", action: #selector(sortByAmount))
        setupButton(button: sideTitle, title: "Side", action: #selector(sortBySide))
        
        setupButton(button: dateTitle, title: "Sort by Date", action: #selector(sortByDate))
        dateTitle.setTitle("Sort by Date ▲", for: .normal)

        stackView.axis = .horizontal
        stackView.spacing = 19
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(instrumentNameTitle)
        stackView.addArrangedSubview(priceTitle)
        stackView.addArrangedSubview(amountTitle)
        stackView.addArrangedSubview(sideTitle)
        
        NSLayoutConstraint.activate([
            dateTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: dateTitle.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
    }
    
    private func setupButton(button: UIButton, title: String, action: Selector) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title + " ▼", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(button)
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    private func toggleSortDirection(for button: UIButton) {
        if button.title(for: .normal)?.contains("▲") ?? false {
            button.setTitle(button.title(for: .normal)?.replacingOccurrences(of: "▲", with: "▼"), for: .normal)
        } else {
            button.setTitle(button.title(for: .normal)?.replacingOccurrences(of: "▼", with: "▲"), for: .normal)
        }
    }

    @objc func sortByInstrument() {
        toggleSortDirection(for: instrumentNameTitle)
        instrumentSortUp ? sortAscending(field: .instrument) : sortDescending(field: .instrument)
        instrumentSortUp.toggle()
    }

    @objc func sortByPrice() {
        toggleSortDirection(for: priceTitle)
        priceSortUp ? sortAscending(field: .price) : sortDescending(field: .price)
        priceSortUp.toggle()
    }

    @objc func sortByAmount() {
        toggleSortDirection(for: amountTitle)
        amountSortUp ? sortAscending(field: .amount) : sortDescending(field: .amount)
        amountSortUp.toggle()
    }

    @objc func sortBySide() {
        toggleSortDirection(for: sideTitle)
        sideSortUp ? sortAscending(field: .side) : sortDescending(field: .side)
        sideSortUp.toggle()
    }
    
    @objc func sortByDate() {
        toggleSortDirection(for: dateTitle)
        dateSortUp ? sortAscending(field: .date) : sortDescending(field: .date)
        dateSortUp.toggle()
    }
    
    func sortAscending(field: SortField) {
        sortActionUp?(field)
    }
    
    func sortDescending(field: SortField) {
        sortActionDown?(field)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

