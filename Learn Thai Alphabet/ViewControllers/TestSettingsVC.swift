//
//  TestSettingsVC.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/15/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

protocol TestSettingsProtocol: class {
    func settingsChanged()
}

class TestSettingsVC: UIViewController {
    
    let layoutPicker        = UIPickerView()
    let layoutBox           = UIView()
    let layoutBoxLabel      = UILabel()
    let timerPicker         = UIPickerView()
    let timerBox            = UIView()
    let timerLabel          = UILabel()

    var layouts: [String]   = ["2 X 2", "3 X 3", "4 X 4", "5 X 4", "5 X 5", "6 X 5", "6 X 6", "7 X 6"]
    let minutes             = Array(0...5)
    let seconds: [Int]      = Array(0...59)
    
    var selectedLayout      = ""
    var selectedMinutes     = 0
    var selectedSeconds     = 0
    var settingsChange      = false
    
    var originalLayout: String?
    var originalTime: Int?
    
    weak var delegate: TestSettingsProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.3573735952, blue: 0.4782596231, alpha: 1)
        navigationItem.title = "Settings"
        setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        originalLayout  = selectedLayout
        originalTime    = selectedMinutes * 60 + selectedSeconds
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let timer =  selectedMinutes * 60 + selectedSeconds
        if timer != originalTime || selectedLayout != originalLayout {
            delegate.settingsChanged()
        }
    }

    
    func setupView() {
        layoutBox.addSubview(layoutBoxLabel)
        layoutBox.backgroundColor       = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 0.5)
        layoutBox.layer.borderColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layoutBox.layer.borderWidth     = 2.0
        layoutBox.layer.cornerRadius    = 15
        
        layoutBoxLabel.text             = "Grid Layout"
        layoutBoxLabel.textColor        = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        layoutPicker.layer.borderWidth  = 2.0
        layoutPicker.layer.borderColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layoutPicker.backgroundColor    = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layoutPicker.tintColor          = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        timerBox.addSubview(timerLabel)
        timerBox.backgroundColor        = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 0.5)
        timerBox.layer.borderColor      = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timerBox.layer.borderWidth      = 2.0
        timerBox.layer.cornerRadius     = 15

        timerLabel.text                 = "Timer"
        timerLabel.textColor            = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        timerPicker.layer.borderWidth   = 2.0
        timerPicker.layer.borderColor   = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timerPicker.backgroundColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timerPicker.tintColor           = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        layoutPicker.translatesAutoresizingMaskIntoConstraints = false
        layoutBox.translatesAutoresizingMaskIntoConstraints = false
        layoutBoxLabel.translatesAutoresizingMaskIntoConstraints = false
        timerPicker.translatesAutoresizingMaskIntoConstraints = false
        timerBox.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        layoutPicker.delegate           = self
        layoutPicker.dataSource         = self
        timerPicker.delegate            = self
        timerPicker.dataSource          = self
        
        if let layoutIndexInt = layouts.firstIndex(of: selectedLayout) { layoutPicker.selectRow(layoutIndexInt, inComponent: 0, animated: false) }
        timerPicker.selectRow(selectedMinutes, inComponent: 0, animated: false)
        timerPicker.selectRow(selectedSeconds, inComponent: 1, animated: false)
        
        view.addSubviews(views: layoutPicker, layoutBox, timerPicker, timerBox)
        
        NSLayoutConstraint.activate([
            layoutBoxLabel.leadingAnchor.constraint(equalTo: layoutBox.leadingAnchor, constant: 8),
            layoutBoxLabel.topAnchor.constraint(equalTo: layoutBox.topAnchor, constant: 15),
            
            layoutBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            layoutBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            layoutBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            layoutBox.heightAnchor.constraint(equalToConstant: 50),
            
            layoutPicker.topAnchor.constraint(equalTo: layoutBox.bottomAnchor, constant: -2),
            layoutPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            layoutPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            layoutPicker.heightAnchor.constraint(equalToConstant: 150),
            
            timerBox.topAnchor.constraint(equalTo: layoutPicker.bottomAnchor, constant: 10),
            timerBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            timerBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            timerBox.heightAnchor.constraint(equalToConstant: 50),
            
            timerPicker.topAnchor.constraint(equalTo: timerBox.bottomAnchor, constant: -2),
            timerPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timerPicker.heightAnchor.constraint(equalToConstant: 150),
            
            timerLabel.leadingAnchor.constraint(equalTo: timerBox.leadingAnchor, constant: 8),
            timerLabel.topAnchor.constraint(equalTo: timerBox.topAnchor, constant: 15)
        ])
    }
}

extension TestSettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case timerPicker: return 2
        default: return 1
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case timerPicker:
            if component == 0 { return minutes.count }
            if component == 1 { return seconds.count }
            return 0
        case layoutPicker: return layouts.count
        default: return 0
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case timerPicker:
            if component == 0 { return String(format: "%02d", minutes[row]) }
            if component == 1 { return String(format: ":%02d", seconds[row])}
            return ""
        case layoutPicker: return layouts[row]
        default: return ""
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case timerPicker:
            if component == 0 { selectedMinutes = Int(minutes[row]) }
            if component == 1 { selectedSeconds = Int(seconds[row])}
        case layoutPicker: selectedLayout = layouts[row]
        default: break
        }
    }
}
