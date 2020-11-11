//  CustomSplashVC.swift
//  Linxy
//  Copyright © 2019 tekzee. All rights reserved.

 //awkward
/*import UIKit
import AVFoundation

class CustomSplashVC: UIViewController,AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var imageCapture: UIImageView!
    
    var captureSession: AVCaptureSession!
    var imageOutput: AVCapturePhotoOutput!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
        imageOutput = AVCapturePhotoOutput()
        guard let device = AVCaptureDevice.default(for: .video) else { return  }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                if captureSession.canAddOutput(imageOutput) {
                    captureSession.addOutput(imageOutput)
                    captureSession.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
                    captureVideoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    captureVideoLayer.frame = cameraView.layer.frame
                    cameraView.layer.addSublayer(captureVideoLayer)
                }
            }
        } catch {
            
            print("error")
        }
    }
    @IBAction func captureImage(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            let settingsForMonitoring = AVCapturePhotoSettings()
        } else {
            
            // Fallback on earlier versions
        }
        
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        imageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    @available(iOS 11.0, *)
    @objc func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        let photData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photo.pixelBuffer as! CMSampleBuffer, previewPhotoSampleBuffer: <#T##CMSampleBuffer?#>)
    }
    
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            //let image = UIImage(data: photoData!)
            imageCapture.image = UIImage(data: photoData!)
            //UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        if #available(iOS 11.0, *) {
            let outputData = output.availableLivePhotoVideoCodecTypes
        } else {
            // Fallback on earlier versions
        }
        
    }
}


*/
/*   /*if navigationAction.navigationType == .linkActivated  {
 if let url = navigationAction.request.url,
 let host = url.host, !host.hasPrefix("http"),
 UIApplication.shared.canOpenURL(url) {
 print("\n The Clicked URL:==\(url)")
 //self.showLinksClicked(subURL: Utils.returnStringFor(value:url))
 decisionHandler(.allow)
 } else {
 print("Open it locally")
 decisionHandler(.allow)
 }
 } else {
 decisionHandler(.allow)
 } */*/
