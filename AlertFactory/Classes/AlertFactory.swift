//
//  AlertFactory.swift
//  AlertFactory
//
//  Created by Thomas Harrison on 8/19/21.
//

import UIKit
import os

/// Create and show alerts to the user.
public struct AlertFactory {
    /// Title for the alert.
    public var title: String?

    /// Optional message for the alert. Set to `nil` to disable the message.
    public var message: String?

    /// The label for the confirmation button.
    public var confirmLabel: String

    /// The style for the confirmation button.
    public var confirmStyle: UIAlertAction.Style

    /// The label for the cancel button.
    public var cancelLabel: String

    /// The style for the cancel button.
    public var cancelStyle: UIAlertAction.Style

    /// The preferred UIAlertController style.
    public var preferredStyle: UIAlertController.Style

    /// Placeholder text for the text field in `prompt(confirmAction:cancelAction:)`.
    public var placeholder: String

    /// Default value for the text field in `prompt(confirmAction:cancelAction:)`.
    public var defaultValue: String?

    /// UITextContainerType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var textContentType: UITextContentType

    /// UITextAutocapitalizationType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var autocapitalizationType: UITextAutocapitalizationType

    /// UITextAutocorrectionType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var autocorrectionType: UITextAutocorrectionType

    /// UITextSpellCheckingType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var spellCheckingType: UITextSpellCheckingType

    /// UIKeyboardType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var keyboardType: UIKeyboardType

    /// Member-wise initializer with defaults.
    public init(
        title: String? = nil, message: String? = nil, confirmLabel: String = "Ok", confirmStyle: UIAlertAction.Style = UIAlertAction.Style.default, cancelLabel: String = "Cancel",
        cancelStyle: UIAlertAction.Style = UIAlertAction.Style.cancel, preferredStyle: UIAlertController.Style = UIAlertController.Style.alert, placeholder: String = "Name", defaultValue: String? = nil,
        textContentType: UITextContentType = UITextContentType.name,
        autocapitalizationType: UITextAutocapitalizationType = UITextAutocapitalizationType.words, autocorrectionType: UITextAutocorrectionType = UITextAutocorrectionType.yes,
        spellCheckingType: UITextSpellCheckingType = UITextSpellCheckingType.yes, keyboardType: UIKeyboardType = UIKeyboardType.default
    ) {
        self.title = title
        self.message = message
        self.confirmLabel = confirmLabel
        self.confirmStyle = confirmStyle
        self.cancelLabel = cancelLabel
        self.cancelStyle = cancelStyle
        self.preferredStyle = preferredStyle
        self.placeholder = placeholder
        self.defaultValue = defaultValue
        self.textContentType = textContentType
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.spellCheckingType = spellCheckingType
        self.keyboardType = keyboardType
    }

    /**
     Show an alert that has `title`, `message` and one button for `confirmLabel`.

     The button will be `cancelStyle`.

     - Parameter confirmAction: optional callback for the confirm button action
     */
    public func alert(confirmAction: @escaping () -> Void = {}) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle)

        let confirmAction = UIAlertAction(title: confirmLabel, style: cancelStyle) { _ in confirmAction() }
        alert.addAction(confirmAction)

        return alert
    }

    /**
     Show an alert that has `title`, `message` and two buttons for `confirmLabel` and `cancelLabel`.

     The confirm button will be `confirmStyle` and the cancel button will be `cancelStyle`.

     - Parameters:
        - confirmAction: callback for the confirm button action
        - cancelAction: optional callback for the cancel button action
     */
    public func confirm(confirmAction: @escaping () -> Void, cancelAction: @escaping () -> Void = {}) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        let confirmAction = UIAlertAction(title: confirmLabel, style: confirmStyle) { _ in confirmAction() }
        let cancelAction = UIAlertAction(title: cancelLabel, style: cancelStyle) { _ in cancelAction() }

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        return alert
    }

    /**
     Shows an alert with multiple actions and a cancel action.

     This is typically used with `preferredStyle = .actionSheet`

     - Parameters:
        - actions: the action buttons to select from
        - cancelAction: optional callback for the cancel button action
     */
    public func select(_ actions: [UIAlertAction], cancelAction: @escaping () -> Void = {}) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        for action in actions {
            alert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: cancelLabel, style: cancelStyle) { _ in cancelAction() }
        alert.addAction(cancelAction)

        return alert
    }

    /**
     Show an alert that has `title`, `message` and two buttons for `confirmLabel` and `cancelLabel`, and a text field.

     The confirm button will be `confirmStyle` and the cancel button will be `cancelStyle`.

     - Parameters:
        - confirmAction: callback for the confirm button action
        - cancelAction: optional callback for the cancel button action
     */
    public func prompt(confirmAction: @escaping (String?) -> Void, cancelAction: @escaping () -> Void = {}) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        let confirmAction = UIAlertAction(title: confirmLabel, style: confirmStyle) { [weak alert] _ in
            let value = alert?.textFields?[0].text
            confirmAction(value)
        }
        let cancelAction = UIAlertAction(title: cancelLabel, style: cancelStyle) { _ in cancelAction() }

        alert.addTextField { textField in
            textField.text = self.defaultValue
            textField.placeholder = self.placeholder
            textField.textContentType = self.textContentType
            textField.autocapitalizationType = self.autocapitalizationType
            textField.autocorrectionType = self.autocorrectionType
            textField.spellCheckingType = self.spellCheckingType
            textField.keyboardType = self.keyboardType
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        return alert
    }
}

extension UIViewController {

    /**
     Construct and show an alert using `AlertFactory`.

     - Parameters:
        - title: the alert title
        - message: optional message
        - confirmAction: callback for the confirm button press
     */
    public func alert(title: String?, message: String?, confirmAction: @escaping () -> Void = {}) {
        let alertFactory = AlertFactory(title: title, message: message)
        let alert = alertFactory.alert(confirmAction: confirmAction)
        present(alert, animated: true, completion: nil)
    }

    /**
     Construct and show a confirmation using `AlertFactory`.

     - Parameters:
        - title: the confirm alert title
        - message: optional message
        - confirmAction: callback for the confirm button press
        - cancelAction: optional callback for the cancel button press
     */
    public func confirm(title: String?, message: String?, confirmAction: @escaping () -> Void, cancelAction: @escaping () -> Void = {}) {
        let alertFactory = AlertFactory(title: title, message: message)
        let alert = alertFactory.confirm(confirmAction: confirmAction, cancelAction: cancelAction)
        present(alert, animated: true, completion: nil)
    }

    /**
     Construct and show a select using `AlertFactory`.

     - Parameters:
        - title: the alert title
        - message: optional message
        - actions: the action buttons to select from
        - cancelAction: callback for the cancel button press
     */
    public func select(title: String?, message: String?, actions: [UIAlertAction], cancelAction: @escaping () -> Void = {}) {
        let alertFactory = AlertFactory(title: title, message: message)
        let alert = alertFactory.select(actions, cancelAction: cancelAction)
        present(alert, animated: true, completion: nil)
    }

    /**
     Construct and show a prompt using `AlertFactory`.

     - Parameters:
        - title: the prompt alert title
        - message: optional message
        - placeholder: placeholder text for the text field
        - defaultValue: optional default text
        - confirmAction: callback for the confirm button press
        - cancelAction: optional callback for the cancel button press
     */
    public func prompt(title: String?, message: String?, placeholder: String, defaultValue: String? = nil, confirmAction: @escaping (String?) -> Void, cancelAction: @escaping () -> Void = {}) {
        let alertFactory = AlertFactory(title: title, message: message, placeholder: placeholder, defaultValue: defaultValue)
        let alert = alertFactory.prompt(confirmAction: confirmAction, cancelAction: cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
