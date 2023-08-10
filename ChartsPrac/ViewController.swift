//
//  ViewController.swift
//  ChartsPrac
//
//  Created by Chun-Li Cheng on 2023/7/31.
//

import UIKit
import DGCharts

class ViewController: UIViewController {
    var lineChartView: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeLineChartFromEX()
        
    }
    
    private func makeLineChartFromEX() {
        // 創建折線圖
        lineChartView = LineChartView()
        self.view.addSubview(lineChartView)
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        let viewSafeLayout = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(
                equalTo: viewSafeLayout.leadingAnchor, constant: 44),
            lineChartView.trailingAnchor.constraint(
                equalTo: viewSafeLayout.trailingAnchor, constant: -44),
            lineChartView.topAnchor.constraint(
                equalTo: viewSafeLayout.topAnchor, constant: 32),
            lineChartView.heightAnchor.constraint(equalToConstant: 250)
        ])
         
        // 生成隨機數據，創建數據入口
        var dataEntries = [ChartDataEntry]()
        for i in 0..<20 {
            let y = arc4random()%50
            let entry = ChartDataEntry.init(x: Double(i+1), y: Double(y))
            dataEntries.append(entry)
        }
        
        var dataEntriesTwo = [ChartDataEntry]()
        for i in 0..<20 {
            let y = arc4random()%100
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            dataEntriesTwo.append(entry)
        }
        
        // 將數據入口變成折線圖的數據組（DataSet)；label 是下方標注
        let dataSet = LineChartDataSet(entries: dataEntries, label: "圖3")
        
        // MARK: - 設定點顏色
        dataSet.drawCirclesEnabled = false
//        dataSet.setCircleColor(NSUIColor.orange)
//        dataSet.circleColors = [NSUIColor.brown]  // 另種設定顏色
        // 設定在 5 才開始有空心效果
//        dataSet.circleRadius = 5
//        dataSet.drawCircleHoleEnabled = false
//        dataSet.circleHoleColor = NSUIColor.clear
//        dataSet.circleHoleRadius = 1
        
        // MARK: - 設定標亮顏色
//        dataSet.highlightEnabled = false
        dataSet.highlightColor = NSUIColor.blue
        dataSet.highlightLineWidth = CGFloat(3.0)
//        dataSet.drawVerticalHighlightIndicatorEnabled = false
//        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightLineDashLengths = [CGFloat(5.0), CGFloat(10.0)]    // 虛線效果
        
        // MARK: - 設定折線顏色 8BBACE;BDBDBD;23333F;
        let customColor = #colorLiteral(red: 0.137254902, green: 0.2, blue: 0.2470588235, alpha: 1).cgColor
        dataSet.setColor(NSUIColor(cgColor: customColor))
//        dataSet.lineDashLengths = [CGFloat(1.0), CGFloat(3.0), CGFloat(5.0)]
        dataSet.lineWidth = CGFloat(0.5)
//        dataSet.setColors(NSUIColor.yellow, NSUIColor.red)
//        dataSet.isDrawLineWithGradientEnabled = true
//        dataSet.gradientPositions = [CGFloat(20.0), CGFloat(80.0)]
        
        // MARK: - 設定數據顏色
        dataSet.drawValuesEnabled = false
        dataSet.valueLabelAngle = CGFloat(90.0)
        dataSet.valueColors = [NSUIColor.red, NSUIColor.brown, NSUIColor.green]
//        dataSet.valueTextColor = NSUIColor.magenta
        dataSet.valueFont = UIFont.systemFont(ofSize: 10)
//        dataSet.mode = .linear
        
//        let dataSetTwo = LineChartDataSet(entries: dataEntriesTwo, label: "圖2")
        
        // 將數據 Set 給折線圖數據
        let chartData = LineChartData(dataSets: [dataSet])
//        chartData.setValueTextColor(NSUIColor.systemBlue)
        
        
//        let chartData = LineChartData(dataSets: [chartDataSet, chartDataSetTwo])
 
        
        // 設置折線圖數據
        lineChartView.data = chartData
//        lineChartView.xAxis.axisMaximum = 100
        
        // MARK: - lineChartView 的背景顏色
        lineChartView.drawGridBackgroundEnabled = true
//        lineChartView.backgroundColor = #colorLiteral(red: 0.5450980392, green: 0.7294117647, blue: 0.8078431373, alpha: 1).withAlphaComponent(0.3)
        lineChartView.gridBackgroundColor = #colorLiteral(red: 0.5450980392, green: 0.7294117647, blue: 0.8078431373, alpha: 1).withAlphaComponent(0.6)
        
        // MARK: - lineChartView 的邊框顏色
        lineChartView.drawBordersEnabled = true
//        lineChartView.borderColor = .green
//        lineChartView.borderLineWidth = 10

        
//        lineChartView.noDataText = "數據取回中"
//        lineChartView.chartDescription.text = "隨機數據呈現"
//        lineChartView.chartDescription.textColor = UIColor.red
        
//        lineChartView.doubleTapToZoomEnabled = true
//        lineChartView.dragEnabled = true
        
//        lineChartView.setVisibleXRange(minXRange: 0, maxXRange: 50)
//        lineChartView.setVisibleXRangeMinimum(lineChartView.chartXMin)
//        lineChartView.setVisibleYRangeMinimum(lineChartView.chartYMin, axis: )
        
        // 顏色方格取消
        lineChartView.legend.form = .empty
        
        
    }
    
    
    


}

