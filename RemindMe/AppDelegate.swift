//
//  AppDelegate.swift
//  RemindMe
//
//  Created by Shubham Verma on 01/05/25.
//

import Cocoa
import AppKit
import Foundation


class AppDelegate: NSObject, NSApplicationDelegate {

    private var window: NSWindow!

    private var statusItem: NSStatusItem!
    
    var storedNumber: Int = 0

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        storedNumber = UserDefaults.standard.integer(forKey: "storedNumber")
        // Insert code here to initialize your application
//        window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0,width: 480,height: 270),
//            styleMask: [.miniaturizable, .closable, .resizable,. titled],
//            backing: .buffered, defer: false
//        )
//        window.center()
//        window.title = "No Storyboard Window"
//        window.makeKeyAndOrderFront(nil)
        
        //Status Item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button{
            button.image = numberRectangleImage(number: storedNumber)
        }
        
        setupMenus()
        
        scheduleDailyDecrement()
    }
    
    func setupMenus(){
        let menu = NSMenu()
        
        let one = NSMenuItem(title: "One", action: #selector(didTapOne), keyEquivalent: "1")
        menu.addItem(one)
        
        let two = NSMenuItem(title: "Two", action: #selector(didTapTwo), keyEquivalent: "2")
        menu.addItem(two)
        
        let setNumberItem = NSMenuItem(title: "Enter days ", action: #selector(setNumber), keyEquivalent: "")
        setNumberItem.target = self
        menu.addItem(setNumberItem)
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    func scheduleDailyDecrement(){
        let currentDate = Date()
        
        //next day
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: currentDate).addingTimeInterval(86400)
        
        //
        let timeInterval = midnight.timeIntervalSince(currentDate)
        
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(decreaseNumber), userInfo: nil, repeats: true)
    }
    
    @objc func decreaseNumber(){
        storedNumber -= 1
        statusItem.button?.image = numberRectangleImage(number: storedNumber)
        print("Number Updated")
        UserDefaults.standard.set(storedNumber, forKey: "storedNumber")
    }
    
    @objc func setNumber(){
        let alert = NSAlert()
        alert.messageText = "Enter days"
        alert.informativeText = "Reminder for days"
        alert.alertStyle = .informational
        
        let inputField = NSTextField(frame: NSRect(x: 0, y:0,  width: 200, height: 24))
        inputField.placeholderString = "Enter Number"
        alert.accessoryView = inputField
        
        alert.addButton(withTitle: "Ok")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        if response ==  .alertFirstButtonReturn{
            let inputText = inputField.stringValue
            if let number = Int(inputText){
                let newImage = numberRectangleImage(number: number)
                statusItem.button?.image = newImage
                UserDefaults.standard.set(number, forKey: "storedNumber")
            }
        }
        print(type(of: response))
    }
    
    private func changeStatusBarButton(number: Int){
        if let button = statusItem.button{
            button.image = numberRectangleImage(number: number, size: NSSize(width: 40, height: 30))
        }
    }
    
    @objc func didTapOne(){
        changeStatusBarButton(number: 1)
    }
    
    @objc func didTapTwo(){
        changeStatusBarButton(number: 2)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func numberRectangleImage(number: Int, size: NSSize = NSSize(width: 60, height: 30)) -> NSImage{
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        let rect = NSRect(origin: .zero, size: size)
        
        let rectPath = NSBezierPath(rect: rect)
        rectPath.fill()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let textAttributes: [NSAttributedString.Key : Any] = [
            .font: NSFont.systemFont(ofSize: size.height*0.4, weight: .bold),
            .foregroundColor: NSColor.white,
            .paragraphStyle: paragraphStyle
        ]
        
        let string = "Rem \(number)" as String
        let stringSize = string.size(withAttributes: textAttributes)
        let stringRect = NSRect(
            x: (size.width - stringSize.width)/2,
            y: (size.height - stringSize.height)/2,
            width: stringSize.width,
            height: stringSize.height
        )
        
        string.draw(in: stringRect, withAttributes: textAttributes)
        image.unlockFocus()
        
        return image
    }

}

