/*
 * Copyright 2019 Coodly LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit

internal class RateBeerRenderView: UIView {

    override func draw(_ rect: CGRect) {
        drawRateBeerCanvas(frame: bounds)
    }
    
    private func drawRateBeerCanvas(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 649, height: 149), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 649, height: 149), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 649, y: resizedFrame.height / 149)
        
        
        //// Color Declarations
        let fillColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let fillColor2 = UIColor(red: 0.965, green: 0.800, blue: 0.153, alpha: 1.000)
        let fillColor3 = UIColor(red: 0.973, green: 0.847, blue: 0.302, alpha: 1.000)
        let fillColor4 = UIColor(red: 0.973, green: 0.847, blue: 0.298, alpha: 1.000)
        let fillColor5 = UIColor(red: 0.980, green: 0.902, blue: 0.506, alpha: 1.000)
        let fillColor6 = UIColor(red: 0.976, green: 0.902, blue: 0.494, alpha: 1.000)
        let fillColor7 = UIColor(red: 0.992, green: 0.949, blue: 0.729, alpha: 1.000)
        let fillColor8 = UIColor(red: 0.996, green: 0.953, blue: 0.737, alpha: 1.000)
        
        //// Group
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 33.7, y: 68.61))
        bezierPath.addLine(to: CGPoint(x: 27.84, y: 68.61))
        bezierPath.addLine(to: CGPoint(x: 27.84, y: 99.18))
        bezierPath.addLine(to: CGPoint(x: 33.7, y: 99.18))
        bezierPath.addCurve(to: CGPoint(x: 50.47, y: 83.82), controlPoint1: CGPoint(x: 43.31, y: 99.18), controlPoint2: CGPoint(x: 50.47, y: 91.89))
        bezierPath.addCurve(to: CGPoint(x: 33.7, y: 68.61), controlPoint1: CGPoint(x: 50.47, y: 75.9), controlPoint2: CGPoint(x: 44.45, y: 68.61))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 62.2, y: 148.85))
        bezierPath.addLine(to: CGPoint(x: 33.38, y: 114.24))
        bezierPath.addLine(to: CGPoint(x: 27.84, y: 114.24))
        bezierPath.addLine(to: CGPoint(x: 27.84, y: 131.62))
        bezierPath.addLine(to: CGPoint(x: 35.01, y: 131.62))
        bezierPath.addLine(to: CGPoint(x: 35.01, y: 146.67))
        bezierPath.addLine(to: CGPoint(x: 0, y: 146.67))
        bezierPath.addLine(to: CGPoint(x: 0, y: 131.62))
        bezierPath.addLine(to: CGPoint(x: 8.63, y: 131.62))
        bezierPath.addLine(to: CGPoint(x: 8.63, y: 68.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 68.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 53.55))
        bezierPath.addLine(to: CGPoint(x: 33.7, y: 53.55))
        bezierPath.addCurve(to: CGPoint(x: 70.01, y: 83.35), controlPoint1: CGPoint(x: 52.43, y: 53.55), controlPoint2: CGPoint(x: 70.01, y: 65.5))
        bezierPath.addCurve(to: CGPoint(x: 52.27, y: 109.73), controlPoint1: CGPoint(x: 70.01, y: 95.46), controlPoint2: CGPoint(x: 62.52, y: 105.08))
        bezierPath.addLine(to: CGPoint(x: 78.64, y: 139.69))
        bezierPath.addLine(to: CGPoint(x: 62.2, y: 148.85))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor.setFill()
        bezierPath.fill()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 109.08, y: 113.92))
        bezier2Path.addCurve(to: CGPoint(x: 94.77, y: 124.79), controlPoint1: CGPoint(x: 99.27, y: 113.92), controlPoint2: CGPoint(x: 94.77, y: 118.89))
        bezier2Path.addCurve(to: CGPoint(x: 104.74, y: 135.19), controlPoint1: CGPoint(x: 94.77, y: 131.93), controlPoint2: CGPoint(x: 100.08, y: 135.19))
        bezier2Path.addCurve(to: CGPoint(x: 118.24, y: 127.27), controlPoint1: CGPoint(x: 113.26, y: 135.19), controlPoint2: CGPoint(x: 118.24, y: 127.27))
        bezier2Path.addCurve(to: CGPoint(x: 117.12, y: 118.43), controlPoint1: CGPoint(x: 117.92, y: 125.41), controlPoint2: CGPoint(x: 117.28, y: 121.53))
        bezier2Path.addCurve(to: CGPoint(x: 116.96, y: 113.92), controlPoint1: CGPoint(x: 117.12, y: 117.34), controlPoint2: CGPoint(x: 116.96, y: 114.7))
        bezier2Path.addLine(to: CGPoint(x: 109.08, y: 113.92))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: 132.07, y: 148.84))
        bezier2Path.addCurve(to: CGPoint(x: 123.87, y: 139.69), controlPoint1: CGPoint(x: 131.11, y: 148.22), controlPoint2: CGPoint(x: 125.8, y: 142.48))
        bezier2Path.addCurve(to: CGPoint(x: 102.33, y: 148.69), controlPoint1: CGPoint(x: 122.1, y: 142.02), controlPoint2: CGPoint(x: 113.9, y: 148.69))
        bezier2Path.addCurve(to: CGPoint(x: 76.12, y: 125.41), controlPoint1: CGPoint(x: 86.73, y: 148.69), controlPoint2: CGPoint(x: 76.12, y: 139.53))
        bezier2Path.addCurve(to: CGPoint(x: 109.08, y: 101.66), controlPoint1: CGPoint(x: 76.12, y: 110.04), controlPoint2: CGPoint(x: 89.47, y: 101.66))
        bezier2Path.addLine(to: CGPoint(x: 116.96, y: 101.66))
        bezier2Path.addCurve(to: CGPoint(x: 105.87, y: 88.47), controlPoint1: CGPoint(x: 116.96, y: 93.44), controlPoint2: CGPoint(x: 113.42, y: 88.47))
        bezier2Path.addCurve(to: CGPoint(x: 91.72, y: 92.2), controlPoint1: CGPoint(x: 99.76, y: 88.47), controlPoint2: CGPoint(x: 94.13, y: 90.8))
        bezier2Path.addLine(to: CGPoint(x: 84.48, y: 79.63))
        bezier2Path.addCurve(to: CGPoint(x: 106.83, y: 73.26), controlPoint1: CGPoint(x: 87.22, y: 77.76), controlPoint2: CGPoint(x: 96.7, y: 73.26))
        bezier2Path.addCurve(to: CGPoint(x: 135.29, y: 100.89), controlPoint1: CGPoint(x: 126.29, y: 73.26), controlPoint2: CGPoint(x: 135.29, y: 85.06))
        bezier2Path.addLine(to: CGPoint(x: 135.29, y: 116.1))
        bezier2Path.addCurve(to: CGPoint(x: 147.51, y: 139.69), controlPoint1: CGPoint(x: 135.29, y: 126.34), controlPoint2: CGPoint(x: 139.15, y: 133.48))
        bezier2Path.addLine(to: CGPoint(x: 132.07, y: 148.84))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: 169, y: 91.57))
        bezier2Path.addLine(to: CGPoint(x: 169, y: 116.25))
        bezier2Path.addCurve(to: CGPoint(x: 181.38, y: 139.84), controlPoint1: CGPoint(x: 169, y: 126.5), controlPoint2: CGPoint(x: 172.91, y: 133.63))
        bezier2Path.addLine(to: CGPoint(x: 165.74, y: 149))
        bezier2Path.addCurve(to: CGPoint(x: 150.44, y: 116.25), controlPoint1: CGPoint(x: 155, y: 139.69), controlPoint2: CGPoint(x: 150.44, y: 130.22))
        bezier2Path.addLine(to: CGPoint(x: 150.44, y: 91.58))
        bezier2Path.addLine(to: CGPoint(x: 136.27, y: 91.58))
        bezier2Path.addLine(to: CGPoint(x: 136.27, y: 75.28))
        bezier2Path.addLine(to: CGPoint(x: 150.44, y: 75.28))
        bezier2Path.addLine(to: CGPoint(x: 150.44, y: 53.55))
        bezier2Path.addLine(to: CGPoint(x: 169, y: 53.55))
        bezier2Path.addLine(to: CGPoint(x: 169, y: 75.28))
        bezier2Path.addLine(to: CGPoint(x: 183.82, y: 75.28))
        bezier2Path.addLine(to: CGPoint(x: 183.82, y: 91.57))
        bezier2Path.addLine(to: CGPoint(x: 169, y: 91.57))
        bezier2Path.close()
        bezier2Path.usesEvenOddFillRule = true
        fillColor.setFill()
        bezier2Path.fill()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 215.75, y: 89.09))
        bezier3Path.addCurve(to: CGPoint(x: 201.63, y: 102.91), controlPoint1: CGPoint(x: 205.32, y: 89.09), controlPoint2: CGPoint(x: 202.27, y: 98.56))
        bezier3Path.addLine(to: CGPoint(x: 228.74, y: 102.91))
        bezier3Path.addCurve(to: CGPoint(x: 215.75, y: 89.09), controlPoint1: CGPoint(x: 228.74, y: 97.47), controlPoint2: CGPoint(x: 225.85, y: 89.09))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 245.57, y: 115.32))
        bezier3Path.addLine(to: CGPoint(x: 200.27, y: 115.32))
        bezier3Path.addCurve(to: CGPoint(x: 216.35, y: 132.86), controlPoint1: CGPoint(x: 200.92, y: 124.79), controlPoint2: CGPoint(x: 205.79, y: 132.86))
        bezier3Path.addCurve(to: CGPoint(x: 233.07, y: 125.1), controlPoint1: CGPoint(x: 225.28, y: 132.86), controlPoint2: CGPoint(x: 230.8, y: 127.27))
        bezier3Path.addLine(to: CGPoint(x: 245.41, y: 135.81))
        bezier3Path.addCurve(to: CGPoint(x: 215.37, y: 148.69), controlPoint1: CGPoint(x: 241.35, y: 139.69), controlPoint2: CGPoint(x: 230.96, y: 148.69))
        bezier3Path.addCurve(to: CGPoint(x: 181.28, y: 110.98), controlPoint1: CGPoint(x: 193.62, y: 148.69), controlPoint2: CGPoint(x: 181.28, y: 132.08))
        bezier3Path.addCurve(to: CGPoint(x: 215.37, y: 73.26), controlPoint1: CGPoint(x: 181.28, y: 91.27), controlPoint2: CGPoint(x: 193.94, y: 73.26))
        bezier3Path.addCurve(to: CGPoint(x: 246.87, y: 107.41), controlPoint1: CGPoint(x: 240.05, y: 73.26), controlPoint2: CGPoint(x: 246.87, y: 93.9))
        bezier3Path.addCurve(to: CGPoint(x: 245.57, y: 115.32), controlPoint1: CGPoint(x: 246.87, y: 110.35), controlPoint2: CGPoint(x: 246.38, y: 113.46))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 354.48, y: 89.09))
        bezier3Path.addCurve(to: CGPoint(x: 340.36, y: 102.91), controlPoint1: CGPoint(x: 344.05, y: 89.09), controlPoint2: CGPoint(x: 341, y: 98.56))
        bezier3Path.addLine(to: CGPoint(x: 367.48, y: 102.91))
        bezier3Path.addCurve(to: CGPoint(x: 354.48, y: 89.09), controlPoint1: CGPoint(x: 367.48, y: 97.47), controlPoint2: CGPoint(x: 364.59, y: 89.09))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 384.32, y: 115.32))
        bezier3Path.addLine(to: CGPoint(x: 339.56, y: 115.32))
        bezier3Path.addCurve(to: CGPoint(x: 355.44, y: 132.86), controlPoint1: CGPoint(x: 340.2, y: 124.79), controlPoint2: CGPoint(x: 345.01, y: 132.86))
        bezier3Path.addCurve(to: CGPoint(x: 371.97, y: 125.1), controlPoint1: CGPoint(x: 364.27, y: 132.86), controlPoint2: CGPoint(x: 369.72, y: 127.27))
        bezier3Path.addLine(to: CGPoint(x: 384.16, y: 135.81))
        bezier3Path.addCurve(to: CGPoint(x: 354.48, y: 148.69), controlPoint1: CGPoint(x: 380.15, y: 139.69), controlPoint2: CGPoint(x: 369.88, y: 148.69))
        bezier3Path.addCurve(to: CGPoint(x: 320.79, y: 110.98), controlPoint1: CGPoint(x: 332.98, y: 148.69), controlPoint2: CGPoint(x: 320.79, y: 132.08))
        bezier3Path.addCurve(to: CGPoint(x: 354.48, y: 73.26), controlPoint1: CGPoint(x: 320.79, y: 91.27), controlPoint2: CGPoint(x: 333.3, y: 73.26))
        bezier3Path.addCurve(to: CGPoint(x: 385.61, y: 107.41), controlPoint1: CGPoint(x: 378.87, y: 73.26), controlPoint2: CGPoint(x: 385.61, y: 93.9))
        bezier3Path.addCurve(to: CGPoint(x: 384.32, y: 115.32), controlPoint1: CGPoint(x: 385.61, y: 110.35), controlPoint2: CGPoint(x: 385.12, y: 113.46))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 421.59, y: 89.09))
        bezier3Path.addCurve(to: CGPoint(x: 407.48, y: 102.9), controlPoint1: CGPoint(x: 411.17, y: 89.09), controlPoint2: CGPoint(x: 408.12, y: 98.56))
        bezier3Path.addLine(to: CGPoint(x: 434.59, y: 102.9))
        bezier3Path.addCurve(to: CGPoint(x: 421.59, y: 89.09), controlPoint1: CGPoint(x: 434.59, y: 97.47), controlPoint2: CGPoint(x: 431.7, y: 89.09))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 451.44, y: 115.32))
        bezier3Path.addLine(to: CGPoint(x: 406.67, y: 115.32))
        bezier3Path.addCurve(to: CGPoint(x: 422.56, y: 132.86), controlPoint1: CGPoint(x: 407.31, y: 124.79), controlPoint2: CGPoint(x: 412.13, y: 132.86))
        bezier3Path.addCurve(to: CGPoint(x: 439.08, y: 125.1), controlPoint1: CGPoint(x: 431.38, y: 132.86), controlPoint2: CGPoint(x: 436.84, y: 127.27))
        bezier3Path.addLine(to: CGPoint(x: 451.27, y: 135.81))
        bezier3Path.addCurve(to: CGPoint(x: 421.59, y: 148.69), controlPoint1: CGPoint(x: 447.26, y: 139.69), controlPoint2: CGPoint(x: 437, y: 148.69))
        bezier3Path.addCurve(to: CGPoint(x: 387.9, y: 110.98), controlPoint1: CGPoint(x: 400.09, y: 148.69), controlPoint2: CGPoint(x: 387.9, y: 132.08))
        bezier3Path.addCurve(to: CGPoint(x: 421.59, y: 73.26), controlPoint1: CGPoint(x: 387.9, y: 91.27), controlPoint2: CGPoint(x: 400.42, y: 73.26))
        bezier3Path.addCurve(to: CGPoint(x: 452.72, y: 107.41), controlPoint1: CGPoint(x: 445.98, y: 73.26), controlPoint2: CGPoint(x: 452.72, y: 93.9))
        bezier3Path.addCurve(to: CGPoint(x: 451.44, y: 115.32), controlPoint1: CGPoint(x: 452.72, y: 110.35), controlPoint2: CGPoint(x: 452.24, y: 113.46))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 282.04, y: 105.7))
        bezier3Path.addLine(to: CGPoint(x: 275.46, y: 105.7))
        bezier3Path.addLine(to: CGPoint(x: 275.46, y: 131.62))
        bezier3Path.addLine(to: CGPoint(x: 282.52, y: 131.62))
        bezier3Path.addCurve(to: CGPoint(x: 299.7, y: 118.43), controlPoint1: CGPoint(x: 293.27, y: 131.62), controlPoint2: CGPoint(x: 299.7, y: 126.03))
        bezier3Path.addCurve(to: CGPoint(x: 282.04, y: 105.7), controlPoint1: CGPoint(x: 299.7, y: 110.35), controlPoint2: CGPoint(x: 292.95, y: 105.7))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 281.4, y: 68.61))
        bezier3Path.addLine(to: CGPoint(x: 275.46, y: 68.61))
        bezier3Path.addLine(to: CGPoint(x: 275.46, y: 90.8))
        bezier3Path.addLine(to: CGPoint(x: 281.23, y: 90.8))
        bezier3Path.addCurve(to: CGPoint(x: 296.16, y: 78.85), controlPoint1: CGPoint(x: 290.06, y: 90.8), controlPoint2: CGPoint(x: 296.16, y: 86.45))
        bezier3Path.addCurve(to: CGPoint(x: 281.4, y: 68.61), controlPoint1: CGPoint(x: 296.16, y: 73.11), controlPoint2: CGPoint(x: 291.67, y: 68.61))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 282.84, y: 146.67))
        bezier3Path.addLine(to: CGPoint(x: 247.84, y: 146.67))
        bezier3Path.addLine(to: CGPoint(x: 247.84, y: 131.62))
        bezier3Path.addLine(to: CGPoint(x: 256.35, y: 131.62))
        bezier3Path.addLine(to: CGPoint(x: 256.35, y: 68.61))
        bezier3Path.addLine(to: CGPoint(x: 247.84, y: 68.61))
        bezier3Path.addLine(to: CGPoint(x: 247.84, y: 53.55))
        bezier3Path.addLine(to: CGPoint(x: 281.23, y: 53.55))
        bezier3Path.addCurve(to: CGPoint(x: 314.79, y: 76.52), controlPoint1: CGPoint(x: 300.34, y: 53.55), controlPoint2: CGPoint(x: 314.79, y: 61))
        bezier3Path.addCurve(to: CGPoint(x: 300.34, y: 97.01), controlPoint1: CGPoint(x: 314.79, y: 85.83), controlPoint2: CGPoint(x: 309.33, y: 93.44))
        bezier3Path.addCurve(to: CGPoint(x: 318.8, y: 119.51), controlPoint1: CGPoint(x: 312.38, y: 100.11), controlPoint2: CGPoint(x: 318.8, y: 108.34))
        bezier3Path.addCurve(to: CGPoint(x: 282.84, y: 146.67), controlPoint1: CGPoint(x: 318.8, y: 136.58), controlPoint2: CGPoint(x: 303.39, y: 146.67))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 454.28, y: 80.57))
        bezier3Path.addLine(to: CGPoint(x: 469.81, y: 71.5))
        bezier3Path.addCurve(to: CGPoint(x: 476.63, y: 83.08), controlPoint1: CGPoint(x: 474.14, y: 75.06), controlPoint2: CGPoint(x: 475.82, y: 78.61))
        bezier3Path.addCurve(to: CGPoint(x: 497.82, y: 73.26), controlPoint1: CGPoint(x: 478.4, y: 81.37), controlPoint2: CGPoint(x: 486.15, y: 74.19))
        bezier3Path.addLine(to: CGPoint(x: 501.36, y: 91.27))
        bezier3Path.addCurve(to: CGPoint(x: 481.12, y: 102.44), controlPoint1: CGPoint(x: 490.91, y: 91.27), controlPoint2: CGPoint(x: 483.62, y: 99.07))
        bezier3Path.addLine(to: CGPoint(x: 481.1, y: 102.46))
        bezier3Path.addCurve(to: CGPoint(x: 480.37, y: 104.74), controlPoint1: CGPoint(x: 480.62, y: 103.12), controlPoint2: CGPoint(x: 480.37, y: 103.92))
        bezier3Path.addLine(to: CGPoint(x: 480.3, y: 132.24))
        bezier3Path.addLine(to: CGPoint(x: 488.34, y: 132.24))
        bezier3Path.addLine(to: CGPoint(x: 488.34, y: 146.67))
        bezier3Path.addLine(to: CGPoint(x: 453.78, y: 146.67))
        bezier3Path.addLine(to: CGPoint(x: 453.78, y: 132.24))
        bezier3Path.addLine(to: CGPoint(x: 461.82, y: 132.24))
        bezier3Path.addLine(to: CGPoint(x: 461.67, y: 105.93))
        bezier3Path.addCurve(to: CGPoint(x: 454.28, y: 80.57), controlPoint1: CGPoint(x: 461.67, y: 105.93), controlPoint2: CGPoint(x: 462.04, y: 91.15))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 633.19, y: 2.44))
        bezier3Path.addLine(to: CGPoint(x: 630.33, y: 2.44))
        bezier3Path.addLine(to: CGPoint(x: 630.33, y: 0.74))
        bezier3Path.addLine(to: CGPoint(x: 638.01, y: 0.74))
        bezier3Path.addLine(to: CGPoint(x: 638.01, y: 2.44))
        bezier3Path.addLine(to: CGPoint(x: 635.14, y: 2.44))
        bezier3Path.addLine(to: CGPoint(x: 635.14, y: 9.61))
        bezier3Path.addLine(to: CGPoint(x: 633.19, y: 9.61))
        bezier3Path.addLine(to: CGPoint(x: 633.19, y: 2.44))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: 642.66, y: 5.74))
        bezier3Path.addLine(to: CGPoint(x: 642.51, y: 5.53))
        bezier3Path.addCurve(to: CGPoint(x: 640.95, y: 3.21), controlPoint1: CGPoint(x: 641.98, y: 4.77), controlPoint2: CGPoint(x: 641.46, y: 3.99))
        bezier3Path.addLine(to: CGPoint(x: 641.34, y: 3.85))
        bezier3Path.addCurve(to: CGPoint(x: 641.36, y: 6.06), controlPoint1: CGPoint(x: 641.35, y: 4.49), controlPoint2: CGPoint(x: 641.36, y: 5.32))
        bezier3Path.addLine(to: CGPoint(x: 641.36, y: 9.61))
        bezier3Path.addLine(to: CGPoint(x: 639.49, y: 9.61))
        bezier3Path.addLine(to: CGPoint(x: 639.49, y: 0.74))
        bezier3Path.addLine(to: CGPoint(x: 641.36, y: 0.74))
        bezier3Path.addLine(to: CGPoint(x: 644, y: 4.49))
        bezier3Path.addLine(to: CGPoint(x: 646.63, y: 0.74))
        bezier3Path.addLine(to: CGPoint(x: 648.48, y: 0.74))
        bezier3Path.addLine(to: CGPoint(x: 648.48, y: 9.61))
        bezier3Path.addLine(to: CGPoint(x: 646.53, y: 9.61))
        bezier3Path.addLine(to: CGPoint(x: 646.53, y: 6.06))
        bezier3Path.addCurve(to: CGPoint(x: 646.56, y: 3.85), controlPoint1: CGPoint(x: 646.53, y: 5.32), controlPoint2: CGPoint(x: 646.55, y: 4.49))
        bezier3Path.addLine(to: CGPoint(x: 646.53, y: 3.84))
        bezier3Path.addLine(to: CGPoint(x: 646.2, y: 4.34))
        bezier3Path.addCurve(to: CGPoint(x: 644.46, y: 6.82), controlPoint1: CGPoint(x: 645.63, y: 5.18), controlPoint2: CGPoint(x: 645.05, y: 6))
        bezier3Path.addLine(to: CGPoint(x: 643.95, y: 7.56))
        bezier3Path.addLine(to: CGPoint(x: 642.66, y: 5.74))
        bezier3Path.close()
        bezier3Path.usesEvenOddFillRule = true
        fillColor.setFill()
        bezier3Path.fill()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 614.34, y: 2.29))
        bezier4Path.addCurve(to: CGPoint(x: 615.77, y: 3.42), controlPoint1: CGPoint(x: 615.1, y: 2.4), controlPoint2: CGPoint(x: 615.51, y: 2.64))
        bezier4Path.addCurve(to: CGPoint(x: 625.67, y: 38.22), controlPoint1: CGPoint(x: 619.56, y: 14.88), controlPoint2: CGPoint(x: 623.12, y: 26.4))
        bezier4Path.addCurve(to: CGPoint(x: 627.99, y: 59.08), controlPoint1: CGPoint(x: 627.15, y: 45.09), controlPoint2: CGPoint(x: 628.23, y: 52.03))
        bezier4Path.addCurve(to: CGPoint(x: 623.22, y: 82.5), controlPoint1: CGPoint(x: 627.71, y: 67.14), controlPoint2: CGPoint(x: 626.77, y: 75.17))
        bezier4Path.addCurve(to: CGPoint(x: 603.67, y: 104), controlPoint1: CGPoint(x: 618.86, y: 91.53), controlPoint2: CGPoint(x: 612.51, y: 99.03))
        bezier4Path.addCurve(to: CGPoint(x: 595.97, y: 113.12), controlPoint1: CGPoint(x: 597.36, y: 107.55), controlPoint2: CGPoint(x: 598.09, y: 107.74))
        bezier4Path.addCurve(to: CGPoint(x: 590.34, y: 128.88), controlPoint1: CGPoint(x: 593.92, y: 118.31), controlPoint2: CGPoint(x: 591.81, y: 123.49))
        bezier4Path.addCurve(to: CGPoint(x: 596.28, y: 138.85), controlPoint1: CGPoint(x: 588.96, y: 133.92), controlPoint2: CGPoint(x: 591.15, y: 137.51))
        bezier4Path.addCurve(to: CGPoint(x: 614.14, y: 143.43), controlPoint1: CGPoint(x: 602.23, y: 140.4), controlPoint2: CGPoint(x: 608.18, y: 141.91))
        bezier4Path.addCurve(to: CGPoint(x: 617.74, y: 144.32), controlPoint1: CGPoint(x: 615.34, y: 143.73), controlPoint2: CGPoint(x: 616.53, y: 144.04))
        bezier4Path.addCurve(to: CGPoint(x: 619.11, y: 145.51), controlPoint1: CGPoint(x: 618.42, y: 144.48), controlPoint2: CGPoint(x: 618.87, y: 144.85))
        bezier4Path.addCurve(to: CGPoint(x: 617.92, y: 147.47), controlPoint1: CGPoint(x: 619.52, y: 146.64), controlPoint2: CGPoint(x: 619.11, y: 147.33))
        bezier4Path.addCurve(to: CGPoint(x: 607.48, y: 148.18), controlPoint1: CGPoint(x: 614.45, y: 147.89), controlPoint2: CGPoint(x: 610.97, y: 148.04))
        bezier4Path.addCurve(to: CGPoint(x: 586.32, y: 148.68), controlPoint1: CGPoint(x: 600.43, y: 148.46), controlPoint2: CGPoint(x: 593.38, y: 148.65))
        bezier4Path.addCurve(to: CGPoint(x: 551.23, y: 147.66), controlPoint1: CGPoint(x: 574.62, y: 148.74), controlPoint2: CGPoint(x: 562.92, y: 148.45))
        bezier4Path.addCurve(to: CGPoint(x: 550.01, y: 147.51), controlPoint1: CGPoint(x: 550.82, y: 147.64), controlPoint2: CGPoint(x: 550.42, y: 147.52))
        bezier4Path.addCurve(to: CGPoint(x: 548.33, y: 146.27), controlPoint1: CGPoint(x: 549.15, y: 147.48), controlPoint2: CGPoint(x: 548.41, y: 147.32))
        bezier4Path.addCurve(to: CGPoint(x: 549.87, y: 144.33), controlPoint1: CGPoint(x: 548.25, y: 145.38), controlPoint2: CGPoint(x: 548.91, y: 144.57))
        bezier4Path.addCurve(to: CGPoint(x: 559.79, y: 141.82), controlPoint1: CGPoint(x: 553.18, y: 143.49), controlPoint2: CGPoint(x: 556.49, y: 142.67))
        bezier4Path.addCurve(to: CGPoint(x: 571.44, y: 138.8), controlPoint1: CGPoint(x: 563.68, y: 140.83), controlPoint2: CGPoint(x: 567.58, y: 139.89))
        bezier4Path.addCurve(to: CGPoint(x: 577.67, y: 132.95), controlPoint1: CGPoint(x: 574.47, y: 137.93), controlPoint2: CGPoint(x: 576.88, y: 136.26))
        bezier4Path.addCurve(to: CGPoint(x: 577.14, y: 128.31), controlPoint1: CGPoint(x: 578.06, y: 131.35), controlPoint2: CGPoint(x: 577.62, y: 129.81))
        bezier4Path.addCurve(to: CGPoint(x: 569.92, y: 108.81), controlPoint1: CGPoint(x: 575.03, y: 121.71), controlPoint2: CGPoint(x: 572.54, y: 115.23))
        bezier4Path.addCurve(to: CGPoint(x: 565.76, y: 105.03), controlPoint1: CGPoint(x: 569.16, y: 106.94), controlPoint2: CGPoint(x: 567.47, y: 105.95))
        bezier4Path.addCurve(to: CGPoint(x: 542.99, y: 79.16), controlPoint1: CGPoint(x: 554.97, y: 99.22), controlPoint2: CGPoint(x: 547.45, y: 90.47))
        bezier4Path.addCurve(to: CGPoint(x: 539.93, y: 64.32), controlPoint1: CGPoint(x: 541.13, y: 74.44), controlPoint2: CGPoint(x: 540.45, y: 69.37))
        bezier4Path.addCurve(to: CGPoint(x: 543.13, y: 32.91), controlPoint1: CGPoint(x: 538.81, y: 53.63), controlPoint2: CGPoint(x: 540.61, y: 43.23))
        bezier4Path.addCurve(to: CGPoint(x: 551.77, y: 3.58), controlPoint1: CGPoint(x: 545.55, y: 23), controlPoint2: CGPoint(x: 548.55, y: 13.26))
        bezier4Path.addCurve(to: CGPoint(x: 553.29, y: 2.27), controlPoint1: CGPoint(x: 552.03, y: 2.79), controlPoint2: CGPoint(x: 552.38, y: 2.39))
        bezier4Path.addCurve(to: CGPoint(x: 570.79, y: 0.93), controlPoint1: CGPoint(x: 559.1, y: 1.5), controlPoint2: CGPoint(x: 564.94, y: 1.18))
        bezier4Path.addCurve(to: CGPoint(x: 572.6, y: 0.85), controlPoint1: CGPoint(x: 571.39, y: 0.77), controlPoint2: CGPoint(x: 571.99, y: 0.89))
        bezier4Path.addLine(to: CGPoint(x: 574.6, y: 0.85))
        bezier4Path.addCurve(to: CGPoint(x: 577.34, y: 0.74), controlPoint1: CGPoint(x: 575.51, y: 0.78), controlPoint2: CGPoint(x: 576.44, y: 1))
        bezier4Path.addLine(to: CGPoint(x: 590.41, y: 0.74))
        bezier4Path.addCurve(to: CGPoint(x: 593.14, y: 0.85), controlPoint1: CGPoint(x: 591.31, y: 1), controlPoint2: CGPoint(x: 592.23, y: 0.78))
        bezier4Path.addLine(to: CGPoint(x: 595.13, y: 0.85))
        bezier4Path.addCurve(to: CGPoint(x: 596.74, y: 0.92), controlPoint1: CGPoint(x: 595.67, y: 0.89), controlPoint2: CGPoint(x: 596.21, y: 0.78))
        bezier4Path.addCurve(to: CGPoint(x: 614.34, y: 2.29), controlPoint1: CGPoint(x: 602.62, y: 1.19), controlPoint2: CGPoint(x: 608.5, y: 1.49))
        bezier4Path.close()
        bezier4Path.usesEvenOddFillRule = true
        fillColor2.setFill()
        bezier4Path.fill()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 593.13, y: 0.95))
        bezier5Path.addCurve(to: CGPoint(x: 590.41, y: 0.74), controlPoint1: CGPoint(x: 592.23, y: 0.87), controlPoint2: CGPoint(x: 591.29, y: 1.2))
        bezier5Path.addLine(to: CGPoint(x: 593.12, y: 0.74))
        bezier5Path.addLine(to: CGPoint(x: 593.19, y: 0.87))
        bezier5Path.addLine(to: CGPoint(x: 593.13, y: 0.95))
        bezier5Path.close()
        bezier5Path.usesEvenOddFillRule = true
        fillColor3.setFill()
        bezier5Path.fill()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 577.34, y: 0.74))
        bezier6Path.addCurve(to: CGPoint(x: 574.61, y: 0.93), controlPoint1: CGPoint(x: 576.46, y: 1.2), controlPoint2: CGPoint(x: 575.52, y: 0.89))
        bezier6Path.addLine(to: CGPoint(x: 574.57, y: 0.79))
        bezier6Path.addLine(to: CGPoint(x: 574.64, y: 0.74))
        bezier6Path.addLine(to: CGPoint(x: 577.34, y: 0.74))
        bezier6Path.close()
        bezier6Path.usesEvenOddFillRule = true
        fillColor4.setFill()
        bezier6Path.fill()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 593.13, y: 0.95))
        bezier7Path.addLine(to: CGPoint(x: 593.12, y: 0.74))
        bezier7Path.addLine(to: CGPoint(x: 595.15, y: 0.74))
        bezier7Path.addLine(to: CGPoint(x: 595.22, y: 0.87))
        bezier7Path.addLine(to: CGPoint(x: 595.16, y: 0.94))
        bezier7Path.addLine(to: CGPoint(x: 593.13, y: 0.95))
        bezier7Path.close()
        bezier7Path.usesEvenOddFillRule = true
        fillColor5.setFill()
        bezier7Path.fill()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 574.63, y: 0.74))
        bezier8Path.addLine(to: CGPoint(x: 574.61, y: 0.93))
        bezier8Path.addLine(to: CGPoint(x: 572.59, y: 0.92))
        bezier8Path.addLine(to: CGPoint(x: 572.54, y: 0.79))
        bezier8Path.addLine(to: CGPoint(x: 572.61, y: 0.74))
        bezier8Path.addLine(to: CGPoint(x: 574.63, y: 0.74))
        bezier8Path.close()
        bezier8Path.usesEvenOddFillRule = true
        fillColor6.setFill()
        bezier8Path.fill()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: 572.61, y: 0.74))
        bezier9Path.addLine(to: CGPoint(x: 572.59, y: 0.92))
        bezier9Path.addLine(to: CGPoint(x: 570.79, y: 0.93))
        bezier9Path.addLine(to: CGPoint(x: 570.8, y: 0.74))
        bezier9Path.addLine(to: CGPoint(x: 572.61, y: 0.74))
        bezier9Path.close()
        bezier9Path.usesEvenOddFillRule = true
        fillColor7.setFill()
        bezier9Path.fill()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: 595.16, y: 3.94))
        bezier10Path.addLine(to: CGPoint(x: 595.15, y: 3.74))
        bezier10Path.addLine(to: CGPoint(x: 596.72, y: 3.74))
        bezier10Path.addLine(to: CGPoint(x: 596.73, y: 3.92))
        bezier10Path.addLine(to: CGPoint(x: 595.16, y: 3.94))
        bezier10Path.close()
        bezier10Path.usesEvenOddFillRule = true
        fillColor8.setFill()
        bezier10Path.fill()
        
        
        
        
        //// Text Drawing
        let textRect = CGRect(x: 0, y: 0, width: 327, height: 54)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        let textFontAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .heavy),
            .foregroundColor: UIColor.black,
            .paragraphStyle: textStyle,
            ] as [NSAttributedString.Key: Any]
        
        "powered by".draw(in: textRect, withAttributes: textFontAttributes)
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(RateBeerResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
