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
    var resetTrakerButton = UIButton()
    var resetView = UIView()
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
        
        
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
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
        let backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-undo-52"), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        resetTrakerButton.frame = CGRect(x: self.view.bounds.width / 2  - 100, y: pieChart.frame.maxY + 20, width: 200, height: 40.0)
        resetTrakerButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        resetTrakerButton.setTitle("Reset", for: .normal)
        resetTrakerButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        resetTrakerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resetTrakerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        resetTrakerButton.layer.cornerRadius = 20
        resetTrakerButton.layer.borderWidth = 2
        resetTrakerButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        resetTrakerButton.addTarget(self, action:#selector(self.resetPressed), for: .touchUpInside)
        if(!moodValues.isEmpty)
        {
            self.view.addSubview(resetTrakerButton)
        }
    }
    @objc func resetPressed()
    {
        resetView.frame = CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 100)
        resetView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.view.bounds.width - 20, height: 60))
        label.numberOfLines = 2
        label.text = "Press reset to clear your \n Mood Tracker."
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .clear
        resetView.addSubview(label)
        let b = UIButton()
        b.frame = CGRect(x: self.view.bounds.width / 2  - 152.5, y: label.frame.maxY, width: 150, height: 40.0)
        b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b.setTitle("Reset", for: .normal)
        b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 2
        b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b.addTarget(self, action:#selector(self.yesReset), for: .touchUpInside)
        self.resetView.addSubview(b)
        
        let b2 = UIButton()
        b2.frame = CGRect(x: self.view.bounds.width / 2 + 2.5, y: label.frame.maxY, width: 150, height: 40.0)
        b2.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b2.setTitle("Cancel", for: .normal)
        b2.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b2.titleLabel?.adjustsFontSizeToFitWidth = true
        b2.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b2.layer.cornerRadius = 20
        b2.layer.borderWidth = 2
        b2.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b2.addTarget(self, action:#selector(self.noReset), for: .touchUpInside)
        self.resetView.addSubview(b2)
        self.view.addSubview(resetView)
        resetView.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.pieChart.frame = CGRect(x: 10, y: 180, width: self.view.bounds.width - 20, height: self.view.bounds.height / 1.5)
            self.resetTrakerButton.alpha = 0.0
            self.resetView.alpha = 1.0
            })
        //print("Reset Pressed")
        
        
    }
    
    @objc func yesReset()
    {
        
        resetView.removeFromSuperview()
        resetView = UIView()
        let moodStrings = ["Happy","Bored","Frustrated","Angry","Lonely","Stressed","Anxious","Sad","Depressed"]
        let userDefaults = Foundation.UserDefaults.standard
        var ctr = 0
        
        while(ctr < moodStrings.count)
        {
            userDefaults.set([moodStrings[ctr], 0], forKey: moodStrings[ctr])
            ctr += 1
        }
        
        pieChart.removeFromSuperview()
        noDataView()
    }
    @objc func noReset()
    {
        
        resetView.removeFromSuperview()
        resetView = UIView()
        moveBack()
    }
    func moveBack()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.pieChart.frame = CGRect(x: 10, y: 80, width: self.view.bounds.width - 20, height: self.view.bounds.height / 1.5)
            self.resetTrakerButton.alpha = 1.0
            })
    }
    @objc func backButtonPressed()
    {
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
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
            colors[ctr] = colors[ctr].withAlphaComponent(0.8)
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
        }else{
            noDataView()
        }
    }
    
    func noDataView()
    {
        let label = UILabel(frame: CGRect(x: 10, y: greetingLabel.frame.maxY + 20, width: self.view.bounds.width - 20, height: 100))
        label.numberOfLines = 2
        label.text = "No mood data to load."
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .clear
        self.view.addSubview(label)
    }
    func getColorSet() -> [UIColor]
    {
        //["Happy","Bored","Frustrated","Angry","Lonely","Stressed","Anxious","Sad","Depressed"]
        //let colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1),#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1),#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1),#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1),#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)]
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
            }else if(i == "Stressed")
            {
                theColors.append(colors[5])
            }else if(i == "Anxious")
            {
                theColors.append(colors[6])
            }else if(i == "Sad")
            {
                theColors.append(colors[7])
            }else if(i == "Depressed")
            {
                theColors.append(colors[8])
            }
        }
        return theColors
    }
    
    func getTheMoodValues()
    {
        let moodStrings = ["Happy","Bored","Frustrated","Angry","Lonely","Stressed","Anxious","Sad","Depressed"]
        let userDefaults = Foundation.UserDefaults.standard
        var ctr = 0
        
        while(ctr < moodStrings.count)
        {
        let moodDict = (userDefaults.dictionary(forKey: moodStrings[ctr]) ?? [String : Int]())
            if(!moodDict.isEmpty)
            {
                for (key,value) in moodDict
                {
                    //print(value)
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
            animation.type = .fade
            animation.duration = 0.4
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
