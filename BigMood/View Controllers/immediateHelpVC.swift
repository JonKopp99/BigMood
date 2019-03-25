//
//  immediateHelpVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/21/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class immediateHelpVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var backgroundImage = UIImageView()
    var greetingLabel = UILabel()
    var moodTB = UITableView()
    var orgs = [organization]()
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.7
        self.view.addSubview(backgroundImage)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Immediate Help."
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(greetingLabel)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-undo-52"), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        moodTB.dataSource = self
        moodTB.delegate = self
        moodTB.backgroundColor = .clear
        moodTB.register(helpCell.self, forCellReuseIdentifier: "helpCell")
        moodTB.frame = CGRect(x: 0, y: greetingLabel.frame.maxY + 5, width: self.view.bounds.width, height: self.view.bounds.height - (self.greetingLabel.frame.maxY + 10))
        moodTB.separatorStyle = .none
        getTheOrganizations()
        self.view.addSubview(moodTB)
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
    
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orgs.count
    }
    func getTheOrganizations()
    {
        orgs.append(organization(name: "National Suicide Prevention Lifeline", contact: "1-800-799-8255",desc: "The National Suicide Prevention Lifeline provides emotional support and resources to people who are contemplating suicide or experiencing emotional distress. This free and confidential service is provided by a national network of local crisis centers aiming to raise suicide awareness and improve crisis response services."))
        orgs.append(organization(name: "Advanced Recovery Systems", contact: "855-789-9197",desc: "Get answers to your questions from the admissions team at Advanced Recovery Systems. Our mission is to give people and their families the knowledge, resources and tools they need to overcome addiction. Call our 24-hour hotline to learn about evidence-based treatment options for drug and alcohol addiction, eating disorders and co-occurring mental health disorders. We can connect you with a treatment center and answer your questions about admissions, costs, insurance and other important topics."))
        orgs.append(organization(name: "Substance Abuse and Health Services", contact: "1-800-662-4357",desc: "The Substance Abuse and Mental Health Services Administration’s helpline offers information in English and Spanish to people facing addiction, substance abuse problems and mental health concerns. Callers from the United States and U.S. territories can get free help finding nearby physicians and treatment centers specializing in addiction and mental health disorders."))
        orgs.append(organization(name: "National Alliance on Mental Illness", contact: "1-800-950-6264",desc: "The National Alliance on Mental Illness HelpLine offers free and confidential assistance to people with mental health disorders, their family members and their caregivers. The advocacy group provides information about mental health conditions and refers callers to nearby treatment and support services."))
        orgs.append(organization(name: "The Trevor Lifeline", contact: "866-488-7386",desc: "The Trevor Project is a national organization that provides crisis intervention and suicide prevention services to LGBTQ+ people 13 to 24 years old. The Trevor Lifeline offers immediate help to those in crisis. Individuals can also receive assistance via TrevorText by texting “Trevor” to 202-304-1200. The text-based support service is available Monday through Friday from 3 p.m. to 10 p.m. EST."))
        orgs.append(organization(name: "LGBT National Hotline", contact: "888-843-4564",desc: "The Lesbian, Gay, Bisexual and Transgender National Hotline offers one-on-one support, information and local resources to members of the LGBTQ+ community. The free and confidential hotline helps callers of all ages with mental health problems, coming-out concerns, relationship problems, bullying and more. You can also call to find LGBT-friendly support groups, religious organizations and sports leagues."))
        moodTB.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theOrg = orgs[indexPath.row]
        let vc = OrganizationDescription()
        vc.theDesc = theOrg.desc
        vc.orgName = theOrg.name
        let animation = CATransition()
        animation.type = .fade
        animation.subtype = .fromBottom
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        self.present(vc, animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "helpCell") as! helpCell
        cell.contact.text = orgs[indexPath.row].contact
        cell.theOrganization.text = orgs[indexPath.row].name
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

struct organization{
    var name = String()
    var contact = String()
    var desc = String()
}
