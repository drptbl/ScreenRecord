//
//  ViewController.swift
//  ScreenRecordSample
//
//  Created by Ueoka Kazuya on 2016/09/04.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import ScreenRecord
import MediaPlayer

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

class ViewController: UIViewController {

    enum Constants {
        static let recordButtonSize: CGSize = CGSize(width: 80.0, height: 80.0)
    }

    lazy var drawableView: DrawableView = {
        let drawableView: DrawableView = DrawableView()
        drawableView.backgroundColor = UIColor.whiteColor()
        return drawableView
    }()
    @IBOutlet weak var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.insertSubview(self.drawableView, atIndex: 0)

        self.recordButton.layer.cornerRadius = Constants.recordButtonSize.width / 2.0
        self.recordButton.layer.masksToBounds = true

        ScreenRecord.shared.clearCaches()
        ScreenRecord.shared.delegate = self
        ScreenRecord.shared.frameRate = ScreenRecord.Framerate.f30
        // Do any additional setup after loading the view, typically from a nib.
    }

    var didLayouted: Bool = false
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.drawableView.frame = self.view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private var isRecording: Bool = false {
        didSet {
            if self.isRecording {
                self.recordButton.setTitle("Stop", forState: UIControlState.Normal)
            } else {
                self.recordButton.setTitle("Record", forState: UIControlState.Normal)
            }
        }
    }
    @IBAction func recordButtonTapped(sender: UIButton) {
        if !self.isRecording {
            ScreenRecord.shared.start()
        } else {
            ScreenRecord.shared.stop()
        }
    }
}

extension ViewController: ScreenRecorderDelegate {
    func screenRecordDidStart(screenRecord: ScreenRecord) {
        print(#function)

        self.isRecording = true
    }

    func screenRecordDidStop(screenRecord: ScreenRecord) {
        print(#function)
    }

    func screenRecordDidCompletion(screenRecord: ScreenRecord, url: NSURL?) {
        print(#function, url)

        self.isRecording = false

        guard let url = url else {
            return
        }

        let mediaPlayerViewController: MPMoviePlayerViewController = MPMoviePlayerViewController(contentURL: url)
        self.presentViewController(mediaPlayerViewController, animated: true, completion: nil)
    }

    func screenRecord(screenRecord: ScreenRecord, didFailed error: ScreenRecord.Error) {
        print(#function)

        print(error)

        self.isRecording = false
    }
}
