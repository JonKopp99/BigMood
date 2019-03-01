//
//  moodTracker.swift
//  BigMood
//
//  Created by Jonathan Kopp on 2/27/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import Charts

class moodTracker: UIViewController{
    var backgroundImage = UIImageView()
    var pieChart = PieChartView()
    var moods = moodChart()
    var moodValues = [Int]()
    var theMoods = [String]()
    var greetingLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.7
        self.view.addSubview(backgroundImage)
        
//        let blur = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
//        blur.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.2)
//        self.view.addSubview(blur)
        
        
        greetingLabel.frame = CGRect(x: 10, y: 60, width: self.view.bounds.width - 20, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 40)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Mood Tracker"
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(greetingLabel)
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        getTheMoodValues()
        //moodValues = [1,2,3,4,5,6]
        setUpPieChart()
        //pieChart.update
    }
    
    func setUpPieChart()
    {
        if(theMoods.count > 0)
        {
        pieChart.frame = CGRect(x: 10, y: 80, width: self.view.bounds.width - 20, height: self.view.bounds.height / 1.5)
        pieChart.holeColor = .clear
        pieChart.backgroundColor = .clear
        pieChart.chartDescription?.textColor = UIColor.white
        pieChart.legend.textColor = UIColor.white
        pieChart.legend.font = UIFont(name: "AvenirNext-DemiBold", size: 12)!
        pieChart.chartDescription?.font = UIFont(name: "AvenirNext-DemiBold", size: 40)!
        pieChart.chartDescription?.xOffset = pieChart.frame.width / 2
        pieChart.chartDescription?.yOffset = pieChart.frame.height - 120
        pieChart.chartDescription?.textAlign = .center
        
        //theMoods = ["Happy","Bored","Frustrated","Angry","Lonely","Sad"]
        var datasets = [PieChartDataEntry]()
        var colors = getColorSet()
        var ctr = 0
        while(ctr < moodValues.count)
        {
            let data = PieChartDataEntry(value: Double(moodValues[ctr]), label: theMoods[ctr])
            datasets.append(data)
            colors[ctr] = colors[ctr].withAlphaComponent(0.5)
            ctr += 1
        }
        let dataSet = PieChartDataSet(values: datasets, label: "")
        dataSet.colors = colors
        dataSet.sliceSpace = 4
    
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        pFormatter.maximumFractionDigits = 0
        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter((DefaultValueFormatter(formatter: pFormatter)))
        pieChart.data = data
        pieChart.chartDescription?.text = ""
        pieChart.usePercentValuesEnabled = false
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.58
        pieChart.transparentCircleRadiusPercent = 0.61
        pieChart.drawHoleEnabled = true
        let l = pieChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        
        pieChart.notifyDataSetChanged()
        self.view.addSubview(pieChart)
        }
    }
    func getColorSet() -> [UIColor]
    {
        let colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        var theColors = [UIColor]()
        for i in theMoods
        {
            if(i == "Happy")
            {
                theColors.append(colors[0])
            }else if(i == "Bored")
            {
                theColors.append(colors[1])
            }else if(i == "Frustrated")
            {
                theColors.append(colors[2])
            }else if(i == "Angry")
            {
                theColors.append(colors[3])
            }else if(i == "Lonely")
            {
                theColors.append(colors[4])
            }else if(i == "Sad")
            {
                theColors.append(colors[5])
            }
        }
        return theColors
    }
    
    func getTheMoodValues()
    {
        let moodStrings = ["Happy","Bored","Frustrated","Angry","Lonely","Sad"]
        let userDefaults = Foundation.UserDefaults.standard
        var ctr = 0
        
        while(ctr < moodStrings.count)
        {
        let moodDict = (userDefaults.dictionary(forKey: moodStrings[ctr]) ?? [String : Int]())
            if(!moodDict.isEmpty)
            {
                for (key,value) in moodDict
                {
                    print(value)
                    let theValue = value as? Int
                    self.moodValues.append(theValue!)
                    self.theMoods.append(key)
                }
            }
            ctr += 1
        }
    }
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        let location = (sender.location(in: pieChart))
        if(location.y >= pieChart.frame.maxY - 100)
        {
            let animation = CATransition()
            animation.type = .push
            animation.duration = 0.6
            animation.subtype = .fromLeft
            self.view.window!.layer.add(animation, forKey: nil)
            
            self.dismiss(animated: false, completion: nil)
        }
    }
}

struct moodChart{
    //["Lonely","Sad","Angry","Happy","Frustrated","Bored"]
    var moodValues: [Int]?
    
}
