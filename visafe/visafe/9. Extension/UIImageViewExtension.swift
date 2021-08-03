//
//  UIImageViewExtension.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/28/21.
//

import UIKit

extension UIImageView {
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.5
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func endRotate() {
        self.layer.removeAllAnimations()
    }
}

extension URL {

   /// Creates a QR code for the current URL in the given color.
   func qrImage(using color: UIColor, logo: UIImage? = nil) -> UIImage? {

      guard let tintedQRImage = qrImage?.tinted(using: color) else {
         return nil
      }

      guard let logo = logo?.cgImage else {
         return UIImage(ciImage: tintedQRImage)
      }

      guard let final = tintedQRImage.combined(with: CIImage(cgImage: logo)) else {
        return UIImage(ciImage: tintedQRImage)
      }

    return UIImage(ciImage: final)
  }

  /// Returns a black and white QR code for this URL.
  var qrImage: CIImage? {
    guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    let qrData = absoluteString.data(using: String.Encoding.ascii)
    qrFilter.setValue(qrData, forKey: "inputMessage")

    let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
    return qrFilter.outputImage?.transformed(by: qrTransform)
  }
}

extension CIImage {
  /// Inverts the colors and creates a transparent image by converting the mask to alpha.
  /// Input image should be black and white.
  var transparent: CIImage? {
     return inverted?.blackTransparent
  }

  /// Inverts the colors.
  var inverted: CIImage? {
      guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }

    invertedColorFilter.setValue(self, forKey: "inputImage")
    return invertedColorFilter.outputImage
  }

  /// Converts all black to transparent.
  var blackTransparent: CIImage? {
      guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
    blackTransparentFilter.setValue(self, forKey: "inputImage")
    return blackTransparentFilter.outputImage
  }

  /// Applies the given color as a tint color.
  func tinted(using color: UIColor) -> CIImage? {
     guard
        let transparentQRImage = transparent,
        let filter = CIFilter(name: "CIMultiplyCompositing"),
        let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

    let ciColor = CIColor(color: color)
    colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
    let colorImage = colorFilter.outputImage

    filter.setValue(colorImage, forKey: kCIInputImageKey)
    filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

    return filter.outputImage!
  }
}

extension CIImage {

  /// Combines the current image with the given image centered.
  func combined(with image: CIImage) -> CIImage? {
    guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
    let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
    combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
    combinedFilter.setValue(self, forKey: "inputBackgroundImage")
    return combinedFilter.outputImage!
  }
}
