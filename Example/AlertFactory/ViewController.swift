//
//  ViewController.swift
//  AlertFactory
//
//  Created by Thomas Harrison on 08/19/2021.
//  Copyright (c) 2021 Thomas Harrison. All rights reserved.
//

import AlertFactory
import UIKit

class ViewController: UIViewController {

    let useShorthand = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func alertButtonAction(_ sender: Any) {
        // Use the UIViewController extension for a single method version
        if useShorthand {
            self.alert(
                title: "Alert", message: "This is an alert",
                confirmAction: {
                    print("Alert was confirmed")
                })
        } else {
            var factory = AlertFactory(title: "Alert")
            factory.message = "You can pass options to AlertFactory.init or set them later"
            let alert = factory.alert(confirmAction: {
                print("Alert was confirmed")
            })
            present(alert, animated: true)
        }
    }

    @IBAction func confirmButtonAction(_ sender: Any) {
        if useShorthand {
            self.confirm(
                title: "Confirm", message: "This is a confirmation",
                confirmAction: {
                    print("Confirm was confirmed")
                },
                cancelAction: {
                    print("Confirm was canceled")
                })
        } else {
            let factory = AlertFactory(title: "Confirm", message: "This is a confirmation")
            let alert = factory.confirm(
                confirmAction: {
                    print("Confirm was confirmed")
                },
                cancelAction: {
                    print("Confirm was canceled")
                })
            present(alert, animated: true)
        }
    }

    @IBAction func promptButtonAction(_ sender: Any) {
        if useShorthand {
            self.prompt(
                title: "Prompt", message: "This is a prompt", placeholder: "Placeholder",
                confirmAction: { text in
                    if let text = text {
                        print("Prompt was confirmed with text", text)
                    }
                },
                cancelAction: {
                    print("Prompt was canceled")
                })
        } else {
            let factory = AlertFactory(title: "Prompt", message: "This is a prompt")
            let alert = factory.prompt(
                confirmAction: { text in
                    print("Prompt was confirmed with", text!)
                },
                cancelAction: {
                    print("Prompt was canceled")
                })
            present(alert, animated: true)
        }
    }

    @IBAction func promptWithDefaultButtonAction(_ sender: Any) {
        if useShorthand {
            self.prompt(
                title: "Prompt", message: "This is a prompt", placeholder: "Placeholder", defaultValue: "Default Text",
                confirmAction: { text in
                    if let text = text {
                        print("Prompt was confirmed with text", text)
                    }
                },
                cancelAction: {
                    print("Prompt was canceled")
                })
        } else {
            let factory = AlertFactory(title: "Prompt", message: "This is a prompt", defaultValue: "Default Text")
            let alert = factory.prompt(
                confirmAction: { text in
                    print("Prompt was confirmed with", text!)
                },
                cancelAction: {
                    print("Prompt was canceled")
                })
            present(alert, animated: true)
        }
    }

    @IBAction func selectAction(_ sender: Any) {
        let handler: (UIAlertAction) -> Void = { action in
            print("Selected \(action.title!)")
        }
        let actions = [
            UIAlertAction(title: "Apple", style: .default, handler: handler),
            UIAlertAction(title: "Peach", style: .default, handler: handler),
            UIAlertAction(title: "Pair", style: .default, handler: handler),
            UIAlertAction(title: "Banana", style: .default, handler: handler),
        ]

        if useShorthand {
            self.select(
                title: "Select a Fruit", message: "What is your favorite fruit?",
                actions: actions,
                cancelAction: {
                    print("Confirm was canceled")
                })
        } else {
            let factory = AlertFactory(title: "Select a Fruit", message: "What is your favorite fruit?")
            let alert = factory.select(
                actions: actions,
                cancelAction: {
                    print("Confirm was canceled")
                })
            present(alert, animated: true)
        }
    }
}
