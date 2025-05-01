//
//  main.swift
//  RemindMe
//
//  Created by Shubham Verma on 01/05/25.
//
import Cocoa

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc,CommandLine.unsafeArgv)
