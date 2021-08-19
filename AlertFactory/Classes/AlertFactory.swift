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
    public var title = "Alert"

    /// Optional message for the alert. Set to `nil` to disable the message.
    public var message: String? = nil

    /// The label for the confirmation button.
    public var confirmLabel = "Ok"

    /// The style for the confirmation button.
    public var confirmStyle = UIAlertAction.Style.default

    /// The label for the cancel button.
    public var cancelLabel = "Cancel"

    /// The style for the cancel button.
    public var cancelStyle = UIAlertAction.Style.cancel

    /// The preferred UIAlertController style.
    public var preferredStyle = UIAlertController.Style.alert

    /// Placeholder text for the text field in `prompt(confirmAction:cancelAction:)`.
    public var placeholder = "Name"

    /// UITextContainerType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var textContentType = UITextContentType.name

    /// UITextAutocapitalizationType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var autocapitalizationType = UITextAutocapitalizationType.words

    /// UITextAutocorrectionType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var autocorrectionType = UITextAutocorrectionType.yes

    /// UITextSpellCheckingType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var spellCheckingType = UITextSpellCheckingType.yes

    /// UIKeyboardType for the text field in `prompt(confirmAction:cancelAction:)`.
    public var keyboardType = UIKeyboardType.default

    /**
     Show an alert that has `title`, `message` and two buttons for `confirmLabel` and `cancelLabel`.

     The confirm button will be `UIAlertAction.Style.default` and the cancel button will be `UIAlertAction.Style.cancel`.

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
     Show an alert that has `title`, `message` and one button for `confirmLabel`.

     The button will be `cancelStyle`.

     - Parameters:
     - confirmAction: optional callback for the confirm button action
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
     Show an alert that has `title`, `message` and two buttons for `confirmLabel` and `cancelLabel`, and a text field.

     The confirm button will be `UIAlertAction.Style.default` and the cancel button will be `UIAlertAction.Style.cancel`.

     - Parameters:
     - confirmAction: callback for the confirm button action
     - cancelAction: optional callback for the cancel button action
     */
    public func prompt(confirmAction: @escaping (String?) -> Void, cancelAction: @escaping () -> Void = {}) -> UIAlertController {
        let alert = UIAlertController(title: "Enter a name", message: "Please enter a name", preferredStyle: preferredStyle)

        let confirmAction = UIAlertAction(title: confirmLabel, style: confirmStyle) { [weak alert] _ in
            let value = alert?.textFields?[0].text
            confirmAction(value)
        }
        let cancelAction = UIAlertAction(title: cancelLabel, style: cancelStyle) { _ in cancelAction() }

        alert.addTextField { textField in
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
     Construct and show a prompt using `AlertFactory`.

     - Parameters:
     - title: the prompt alert title
     - message: optional message
     - placeholder: placeholder text for the text field
     - confirmAction: callback for the confirm button press
     - cancelAction: optional callback for the cancel button press
     */
    public func prompt(title: String, message: String?, placeholder: String, confirmAction: @escaping (String?) -> Void, cancelAction: @escaping () -> Void = {}) {
        let alertFactory = AlertFactory(title: title, message: message, placeholder: placeholder)
        let alert = alertFactory.prompt(confirmAction: confirmAction, cancelAction: cancelAction)
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
    public func confirm(title: String, message: String?, confirmAction: @escaping () -> Void, cancelAction: @escaping () -> Void = {}) {
        let alertFactory = AlertFactory(title: title, message: message)
        let alert = alertFactory.confirm(confirmAction: confirmAction, cancelAction: cancelAction)
        present(alert, animated: true, completion: nil)
    }

    /**
     Construct and show an alert using `AlertFactory`.

     - Parameters:
     - title: the alert title
     - message: optional message
     - confirmAction: callback for the confirm button press
     */
    public func alert(title: String, message: String?, confirmAction: @escaping () -> Void = {}) {
        let alertFactory = AlertFactory(title: title, message: message)
        let alert = alertFactory.alert(confirmAction: confirmAction)
        present(alert, animated: true, completion: nil)
    }
}
