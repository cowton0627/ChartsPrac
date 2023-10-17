//
//  ViewController.swift
//  ChartsPrac
//
//  Created by Chun-Li Cheng on 2023/7/31.
//

import UIKit
import DGCharts

class ViewController: UIViewController {
    
    private let lightVisionColor = #colorLiteral(red: 0.9098039216, green: 0.9450980392, blue: 0.9607843137, alpha: 1)
    private let visionColor = #colorLiteral(red: 0.5450980392, green: 0.7294117647, blue: 0.8078431373, alpha: 1)
    private let intermediateVisionColor = #colorLiteral(red: 0.4039215686, green: 0.7137254902, blue: 0.8470588235, alpha: 1)
    private let darkVisionColor = #colorLiteral(red: 0.1960784314, green: 0.568627451, blue: 0.7058823529, alpha: 1)
    private let customBlack = #colorLiteral(red: 0.137254902, green: 0.2, blue: 0.2470588235, alpha: 1)
    private let customWhite = #colorLiteral(red: 0.9803921569, green: 0.9882352941, blue: 0.9921568627, alpha: 1)
    private let lightGray = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
    private let darkGray = #colorLiteral(red: 0.6235294118, green: 0.6705882353, blue: 0.7019607843, alpha: 1)
    
    var charView: UIView!
    var roomLabel: UILabel!
    var lineChartView: LineChartView!

    // Not Using IBOutlet, not installed.
    @IBOutlet weak var bindingBtn: UIButton!
    @IBOutlet weak var anotherBindingBtn: UIButton!
    
    var airData: [AirData] = []
    func generateAirData() {
        let currentDate = Date()
        for hour in 0..<24 {
            let pm10 = Int.random(in: 3...10)
            let pm25 = Int.random(in: 1...10)
            let pm1 = Int.random(in: 5...10)
            let voc = Int.random(in: 1...5)
            
            let timestamp = Calendar.current.date(byAdding: .hour,
                                                  value: -hour,
                                                  to: currentDate)!
            
            airData.append(AirData(pm10: pm10, pm25: pm25, pm1: pm1,
                                   voc: voc, timestamp: timestamp))
        }
        airData.reverse()
    }
    
    var purifierData: [PurifierData] = []
    func generatePufifierData() {
        let currentDate = Date()
        for minute in stride(from: 0, to: 24, by: 1) { // 24 hours, every 1 hour
//        for minute in stride(from: 0, to: 24*60, by: 5) { // 24 hours, every 5 minutes
            // 隨機生成開或關的狀態
            let power = Bool.random() ? "on" : "off"
            
            // 從當前時間減去分鐘數來創建時間戳
            let timestamp = Calendar.current.date(byAdding: .minute,
                                                  value: -minute,
                                                  to: currentDate)!
            
            // 添加到數據數組
            purifierData.append(PurifierData(power: power, timestamp: timestamp))
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateAirData()
        generatePufifierData()
        makeLineChart()
        
    }
    
    private func makeLineChart() {
        // 創建 Chart，這裡是 Line Chart
        charView = UIView()
        charView.backgroundColor = .systemGray6
        charView.layer.masksToBounds = true
        charView.layer.cornerRadius = 20
        roomLabel = UILabel()
        roomLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        roomLabel.textColor = .black
        lineChartView = LineChartView()
        self.view.addSubview(charView)
        charView.addSubview(roomLabel)
        self.charView.addSubview(lineChartView)
//        self.view.addSubview(lineChartView)
        
        charView.translatesAutoresizingMaskIntoConstraints = false
        let viewSafeLayout = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            charView.leadingAnchor.constraint(
                equalTo: viewSafeLayout.leadingAnchor, constant: 35),
            charView.trailingAnchor.constraint(
                equalTo: viewSafeLayout.trailingAnchor, constant: -35),
            charView.topAnchor.constraint(
                equalTo: viewSafeLayout.topAnchor, constant: 32),
            charView.heightAnchor.constraint(equalToConstant: 181)
        ])
        
//        NSLayoutConstraint.activate([
//            charView.leadingAnchor.constraint(
//                equalTo: viewSafeLayout.leadingAnchor, constant: 10),
//            charView.trailingAnchor.constraint(
//                equalTo: viewSafeLayout.trailingAnchor, constant: -10),
//            charView.topAnchor.constraint(
//                equalTo: viewSafeLayout.topAnchor, constant: 32),
//            charView.heightAnchor.constraint(equalToConstant: 253.59)
//        ])
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(
                equalTo: charView.leadingAnchor, constant: 41),
            lineChartView.trailingAnchor.constraint(
                equalTo: charView.trailingAnchor, constant: -38),
            lineChartView.topAnchor.constraint(
                equalTo: charView.topAnchor, constant: 26),
            lineChartView.bottomAnchor.constraint(
                equalTo: charView.bottomAnchor, constant: -31)
        ])
        
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roomLabel.leadingAnchor.constraint(equalTo: charView.leadingAnchor, constant: 27),
            roomLabel.topAnchor.constraint(equalTo: charView.topAnchor, constant: 9),
            roomLabel.trailingAnchor.constraint(lessThanOrEqualTo: charView.trailingAnchor, constant: -8)
        ])
        
        roomLabel.text = "Living Room"
        
        // 生成隨機 Data，創建 Data Entry
        var dataEntries = [ChartDataEntry]()
        for (index, airDatum) in airData.enumerated() {
            let entry = ChartDataEntry.init(x: Double(index + 1), y: Double(airDatum.pm25))
            dataEntries.append(entry)
        }
        
//        for i in 0..<60 {
//            let y = arc4random()%500
//            let entry = ChartDataEntry.init(x: Double(i+1), y: Double(y))
//            dataEntries.append(entry) }
        
        var dataEntriesTwo = [ChartDataEntry]()
        for (index, airDatum) in airData.enumerated() {
            let entry = ChartDataEntry.init(x: Double(index + 1), y: Double(airDatum.pm10))
            dataEntriesTwo.append(entry)
        }
        
//        for i in 0..<60 {
//            let y = arc4random()%300
//            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
//            dataEntriesTwo.append(entry) }
        
        var dataEntriesThree = [ChartDataEntry]()
        for (index, apDatum) in purifierData.enumerated() {
            var y = 0
            if apDatum.power == "on" {
                y = 18
            } else if apDatum.power == "off" {
                y = 16
            }
            let entry = ChartDataEntry.init(x: Double(index + 1), y: Double(y))
            dataEntriesThree.append(entry)
        }
        
        // 將 Data Entry 變成 Chart 的 DataSet；label 是下方標註
        let dataSet = LineChartDataSet(entries: dataEntries, label: "")
        let dataSetTwo = LineChartDataSet(entries: dataEntriesTwo, label: "")
        let dataSetThree = LineChartDataSet(entries: dataEntriesThree, label: "")
//        let dataSet = LineChartDataSet(entries: dataEntries, label: "PM2.5")
//        let dataSetTwo = LineChartDataSet(entries: dataEntriesTwo, label: "PM10")
//        let dataSetThree = LineChartDataSet(entries: dataEntriesThree, label: "Switch")
        dataSetThree.mode = .stepped
        
        // MARK: - 設定點顏色
        dataSet.drawCirclesEnabled = false
        dataSetTwo.drawCirclesEnabled = false
        dataSetThree.drawCirclesEnabled = false
//        dataSet.setCircleColor(NSUIColor.orange)
//        dataSet.circleColors = [NSUIColor.brown]  // 另種設定顏色
        // 設定在 5 才開始有空心效果
//        dataSet.circleRadius = 5
//        dataSet.drawCircleHoleEnabled = false
//        dataSet.circleHoleColor = NSUIColor.clear
//        dataSet.circleHoleRadius = 1
        
        // MARK: - 設定標亮顏色
        dataSet.highlightEnabled = false
        dataSetTwo.highlightEnabled = false
        dataSetThree.highlightEnabled = false
        
        dataSet.highlightColor = NSUIColor.blue
        dataSet.highlightLineWidth = CGFloat(3.0)
//        dataSet.drawVerticalHighlightIndicatorEnabled = false
//        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightLineDashLengths = [CGFloat(5.0), CGFloat(10.0)]    // 虛線效果
        
        // MARK: - 設定折線顏色 8BBACE;BDBDBD;23333F; 線寬
        let customColor = #colorLiteral(red: 0.137254902, green: 0.2, blue: 0.2470588235, alpha: 1).cgColor
        dataSet.setColor(NSUIColor(cgColor: customColor))
//        dataSet.lineDashLengths = [CGFloat(1.0), CGFloat(3.0), CGFloat(5.0)]
        
        dataSet.lineWidth = CGFloat(0.7)
        dataSetTwo.lineWidth = CGFloat(0.7)
//        dataSetThree.lineWidth = CGFloat(0.5)

//        dataSet.setColors(NSUIColor.yellow, NSUIColor.red)
//        dataSet.isDrawLineWithGradientEnabled = true
//        dataSet.gradientPositions = [CGFloat(20.0), CGFloat(80.0)]
        
        dataSetTwo.setColor(NSUIColor(cgColor: UIColor.brown.cgColor))
        dataSetThree.setColor(NSUIColor(cgColor: darkVisionColor.cgColor))
        
        // MARK: - 設定數據顏色
        dataSet.drawValuesEnabled = false
        dataSetTwo.drawValuesEnabled = false
        dataSetThree.drawValuesEnabled = false
        
        dataSet.valueLabelAngle = CGFloat(90.0)
        dataSet.valueColors = [NSUIColor.red, NSUIColor.brown, NSUIColor.green]
//        dataSet.valueTextColor = NSUIColor.magenta
        dataSet.valueFont = UIFont.systemFont(ofSize: 10)
//        dataSet.mode = .linear
        
//        let dataSetTwo = LineChartDataSet(entries: dataEntriesTwo, label: "圖2")
        
        // 將 Data Set 給 Chart
        let chartData = LineChartData(dataSets: [dataSet, dataSetTwo, dataSetThree])
//        chartData.setValueTextColor(NSUIColor.systemBlue)

        lineChartView.data = chartData
//        lineChartView.xAxis.axisMaximum = 100
        
        // MARK: - lineChartView 的背景顏色
        lineChartView.drawGridBackgroundEnabled = true
//        lineChartView.backgroundColor = #colorLiteral(red: 0.5450980392, green: 0.7294117647, blue: 0.8078431373, alpha: 1).withAlphaComponent(0.3)
        lineChartView.gridBackgroundColor = lightVisionColor.withAlphaComponent(0.6)
        
        // MARK: - lineChartView 的邊框顏色
//        lineChartView.drawBordersEnabled = true
//        lineChartView.borderColor = .clear
//        lineChartView.borderLineWidth = 10

        
//        lineChartView.noDataText = "數據取回中"
//        lineChartView.chartDescription.text = "隨機數據呈現"
//        lineChartView.chartDescription.textColor = UIColor.red
        
        
//        lineChartView.setVisibleXRange(minXRange: 0, maxXRange: 50)
//        lineChartView.setVisibleXRangeMinimum(lineChartView.chartXMin)
//        lineChartView.setVisibleYRangeMinimum(lineChartView.chartYMin, axis: )
        
        // 顏色方格取消
        lineChartView.legend.form = .empty
        
        // MARK: - User Interaction
        lineChartView.doubleTapToZoomEnabled = true
        lineChartView.scaleYEnabled = false
        lineChartView.dragEnabled = true
//        lineChartView.dragDecelerationEnabled = true     //拖拽后是否有惯性效果
//        lineChartView.dragDecelerationFrictionCoef = 0.1 //拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
        
        
        
        // 不顯示座標軸數據
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
//        lineChartView.xAxis.drawLabelsEnabled = false
        
        // 將 X 軸上方數據放到下方
        lineChartView.xAxis.labelPosition = .bottom
        
        // 不顯示框線
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        
//        lineChartView.xAxis.drawGridLinesEnabled = true
        
        // 不顯示 Y 格線
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        // 將 Y 格線變成虛線
        lineChartView.xAxis.gridLineDashLengths = [5.0, 5.0]

        // 設置左側 Y 軸的網格線為虛線
//        lineChartView.leftAxis.gridLineDashPhase = 0.0
//        lineChartView.leftAxis.gridLineDashLengths = [5.0, 5.0]
        // 設置右側 Y 軸的網格線為虛線
//        lineChartView.rightAxis.gridLineDashPhase = 0.0
//        lineChartView.rightAxis.gridLineDashLengths = [5.0, 5.0]

        // 去掉圖表的背景顏色和格線
//        lineChartView.drawGridBackgroundEnabled = false
//        lineChartView.gridBackgroundColor = NSUIColor.clear
        
        // 去掉圖表的邊框
//        lineChartView.drawBordersEnabled = false

        

    
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        view.addSubview(button)
//        button.center = view.center
//        button.backgroundColor = .orange
        
        
//        let maxValue = Int.max
//        let overflowedValue = maxValue &+ 1
//        print(overflowedValue)
    }
    
    @objc func buttonTapped() {
        print("Button was tapped!")
    }
    
    
    
    @IBAction func bindingBtnTapped(_ sender: UIButton) {
//        bindingBtn.isSelected.toggle()
//        isSelected.value.toggle()
    }
    
    @IBAction func anotherBtnTapped(_ sender: UIButton) {
//        isChanged.value.toggle()
    }
    
    
}

