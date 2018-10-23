//
//  TableController.swift
//  hINF
//
//  Created by Tanel Teemusk on 29/08/2017.
//  Copyright © 2017 Tanel Teemusk. All rights reserved.
//  Base class for tableviews

import UIKit

class TableController: UIViewController  {

    var tableData: [TableSectionData] = []
    
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    var customTableView: Bool = false
    
    var tap: UITapGestureRecognizer?

    func registerCell(identifier: CellsIdentifier){
        self.tableView.register(UINib(nibName: identifier.rawValue,
                                      bundle: Bundle.main),
                                forCellReuseIdentifier: identifier.rawValue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.keyboardDismissMode = .onDrag
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !customTableView {
            self.tableView.frame = self.view.bounds
        }
    }

    //MARK: - Keyboard Show and Hide Methods
    @objc dynamic func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo! as! [String: AnyObject]
        let kbSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        var contentInsets = self.tableView.contentInset
        contentInsets.bottom = kbSize.height

        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets

        var aRect = self.tableView.frame
        aRect.size.height -= kbSize.height

        let tap = UITapGestureRecognizer(target: self, action: #selector(TableController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.tap = tap
    }

    @objc dynamic func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo! as! [String: AnyObject]
        let kbSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        var contentInsets = self.tableView.contentInset
        contentInsets.bottom = kbSize.height

        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        if let tap = self.tap {
            self.view.removeGestureRecognizer(tap)
        }
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    deinit {
        print("-- \(self) deinit")
        NotificationCenter.default.removeObserver(self)
        self.tableView.gestureRecognizers?.removeAll()
    }

}

extension TableController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableDataItem = tableData[(indexPath as NSIndexPath).section].cells[(indexPath as NSIndexPath).row]
        var cell = UITableViewCell()
        if let registeredCell = tableView.dequeueReusableCell(
            withIdentifier: tableDataItem.identifier.rawValue) as? TableViewCell {
            registeredCell.id = tableDataItem.id
            if let data = tableDataItem.data {
                registeredCell.populate(data: data)
            }
            cell = registeredCell
        } else {
            cell.textLabel?.text = "\(tableDataItem.identifier) Please register your cell. make sure you extend TableViewCell"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    //Headers when necessary
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let headerName = tableData[section].header {
            return headerName
        }
        return nil
    }

    //HEADER
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionHeader = tableData[section].headerView {
            return sectionHeader
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionHeader = tableData[section].headerView {
            return sectionHeader.frame.height
        }
        if tableData[section].header != nil {
            return 40
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }

    //FOOTER
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let sectionFooter = tableData[section].footerView {
            return sectionFooter
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footer = tableData[section].footerView {
            return footer.frame.height
        }
        return CGFloat.leastNormalMagnitude
    }

}
