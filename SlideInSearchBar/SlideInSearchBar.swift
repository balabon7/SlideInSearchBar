//
//  SlideInSearchBar.swift
//  SlideInSearchBar
//
//  Created by Oleksandr Balabon on 24.06.2024.
//

import UIKit

// Custom search bar class
public class SlideInSearchBar: UIView, UITextFieldDelegate {
    
    // Placeholder elements
    private let iconView: UIImageView
    private let placeholderLabel: UILabel
    private let clearButton: UIButton
    
    // Text field
    private let textField: UITextField
    
    // Background view for the search bar
    private let backgroundView: UIView
    
    public var placeholderText: String? {
        didSet {
            self.placeholderLabel.text = self.placeholderText
        }
    }
    
    private var isEditingText: Bool = false
    
    public override init(frame: CGRect) {
        self.iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        self.placeholderLabel = UILabel()
        self.textField = UITextField()
        self.backgroundView = UIView()
        self.clearButton = UIButton(type: .system)
        
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Setup background view
        self.backgroundView.backgroundColor = .systemGray6
        self.backgroundView.layer.cornerRadius = 16
        // self.backgroundView.layer.borderWidth = 1
        // self.backgroundView.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundView.layer.masksToBounds = true
        
        // Setup placeholder label
        self.placeholderLabel.textColor = .lightGray
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        
        // Setup icon view
        self.iconView.tintColor = .lightGray
        
        // Setup text field
        self.textField.alpha = 1.0
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.textField.backgroundColor = .clear
        // self.textField.borderStyle = .none
        
        // Setup clear button
        self.clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        self.clearButton.tintColor = .gray
        self.clearButton.isHidden = true
        self.clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        // Add tap gesture to the placeholder
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        
        // Add subviews
        self.addSubview(self.backgroundView)
        self.addSubview(self.iconView)
        self.addSubview(self.placeholderLabel)
        self.addSubview(self.textField)
        self.addSubview(self.clearButton)
        
        // Add Done button to keyboard
        addDoneButtonOnKeyboard()
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.barStyle = .default
        doneToolbar.tintColor = .systemBlue
        
        self.textField.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        self.textField.resignFirstResponder()
    }
    
    @objc private func clearButtonTapped() {
        self.textField.text = ""
        self.updatePlaceholderVisibility()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Layout the background view
        self.backgroundView.frame = self.bounds
        
        // Center the placeholder elements when not editing
        if !self.isEditingText {
            let iconSize = self.iconView.bounds.size
            let labelSize = self.placeholderLabel.sizeThatFits(self.bounds.size)
            let totalWidth = iconSize.width + 5 + labelSize.width
            
            self.iconView.frame = CGRect(x: (self.bounds.width - totalWidth) / 2,
                                         y: (self.bounds.height - iconSize.height) / 2,
                                         width: iconSize.width,
                                         height: iconSize.height)
            
            self.placeholderLabel.frame = CGRect(x: self.iconView.frame.maxX + 8,
                                                 y: (self.bounds.height - labelSize.height) / 2,
                                                 width: labelSize.width,
                                                 height: labelSize.height)
        } else {
            // Align the placeholder to the left when editing
            let iconSize = self.iconView.bounds.size
            self.iconView.frame = CGRect(x: 16,
                                         y: (self.bounds.height - iconSize.height) / 2,
                                         width: iconSize.width,
                                         height: iconSize.height)
            
            let labelSize = self.placeholderLabel.sizeThatFits(self.bounds.size)
            self.placeholderLabel.frame = CGRect(x: self.iconView.frame.maxX + 8,
                                                 y: (self.bounds.height - labelSize.height) / 2,
                                                 width: min(labelSize.width, self.bounds.width - 50 - iconSize.width),
                                                 height: labelSize.height)
        }
        
        // Layout the text field with padding
        self.textField.frame = CGRect(x: self.iconView.frame.maxX + 8, y: 0, width: self.bounds.width - self.iconView.frame.maxX - 52, height: self.bounds.height)
        
        // Layout the clear button
        let buttonSize: CGFloat = 20
        self.clearButton.frame = CGRect(x: self.bounds.width - buttonSize - 16,
                                        y: (self.bounds.height - buttonSize) / 2,
                                        width: buttonSize,
                                        height: buttonSize)
    }
    
    @objc private func handleTap() {
        self.textField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Update the visibility of the placeholder and clear button
        self.updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        let isEmpty = self.textField.text?.isEmpty ?? true
        self.placeholderLabel.alpha = isEmpty ? 1.0 : 0.0
        self.clearButton.isHidden = isEmpty
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isEditingText = true
        UIView.animate(withDuration: 0.25) {
            self.layoutSubviews()
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmpty = textField.text?.isEmpty ?? true
        if isEmpty {
            self.isEditingText = false
        }
        UIView.animate(withDuration: 0.25) {
            self.updatePlaceholderVisibility()
            self.layoutSubviews()
        }
    }
}
