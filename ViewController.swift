//
//  ViewController.swift
//  AlamofireAPIs
//
//  Created by Admin on 3/7/19.
//  Copyright © 2019 charts. All rights reserved.
//



//SIGNUP HAS RESPONSE BUT STATUS CODE IS 400 ------   METHOD IS POST
//sendverificationmailAPI   HAS RESPONSE BUT STATUS CODE IS 400 ------   METHOD IS POST



import UIKit
import Alamofire

let kBaseURL = "http://olynk-99764.appspot.com/api/v1/"

let kAuth = "auth/"
let kSignup = "signup"
let kSendVarificationMail = "send-verification-mail"
let kCheckEmailVarification = "check-email-verification/"
let kChangePaswword = "change-password"
let kAttendeeEvents = "attendee-events/current"
let kEventAssociatesExist = "event-associates-exist/"
let kEventDetails = "event/"
let kEventAgendaList = "agendas/"
let kAttendeeAgendaList = "attendee-agenda/"
let kSpeakerList = "speaker-list/"
let kAttendeeList = "attendee-list/"
let kAwardsList = "award-list/"

let kTokenAuthUserName = "anudp619@gmail.com"
let kTokenAuthPassword = "admin@123"

let kUserName = "username"
let kPassword = "password"
let kName = "name"
let kEmail = "email"
let kOldPassword = "oldPassword"
let kNewPassword = "newPassword"

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authAPI(username: kTokenAuthUserName, password: kTokenAuthPassword)
    }
    
    
//MARK:- API CALLING -
    func authAPI(username : String , password : String) {
        let mainURL = "\(kBaseURL)\(kAuth)"
        var params = [String:String]()
        params[kUserName] = kTokenAuthUserName
        params[kPassword] = kTokenAuthPassword
       
        Alamofire.request(mainURL, method: .post, parameters: params).validate().responseJSON { response in
            guard response.result.isSuccess else {
                print(String(describing: response.result.error))
                return
            }
            
            if let authToken = response.result.value as? [String : AnyObject] {
                print(authToken)
                UserDefaults.standard.set(authToken["token"], forKey: "auth_token")
                
                //   self.signUpAPI(authToken: authToken["token"] as Any)
                //   self.checkEmailVerificationAPI(userId: (authToken["id"] as? NSNumber)!)
                //   self.sendverificationmailAPI(authToken: authToken["token"] as Any)
                //   self.changePasswordAPI(authToken: authToken["token"] as Any)
                //   self.attendeeEventsAPI(authToken: authToken["token"] as Any)
                //   self.eventAssociatesExistAPI(eventId: "1")
                //   self.getEventDetailsAPI(eventId: "1")
                //   self.getSpeakerListAPI(eventId: "1")
                //   self.getEventAgendaListAPI(eventId: "1")
                //   self.getMyScheduleListAPI(eventId: "1")
                //   self.getAttendeeListAPI(eventId: "1")
                self.getAwardsListAPI(eventId: "1")
            }
        }
    }
    
    
    func signUpAPI(authToken : Any) {
        var params = [String:AnyObject]()
        params[kName] = "anudp" as AnyObject
        params[kEmail] = kTokenAuthUserName as AnyObject
        params[kPassword] = kTokenAuthPassword as AnyObject
        
        post(params: params, url: kSignup) { (succeeded: Bool, Response: NSDictionary) in
            DispatchQueue.main.async {
                if(succeeded) {
                    print(Response)
                }
            }
        }
    }
    
    
    func checkEmailVerificationAPI(userId : NSNumber) {
        Get(url: "\(kCheckEmailVarification)\(userId)" as String) { (succeeded: Bool, Response: NSDictionary) in
            DispatchQueue.main.async {
                if(succeeded) {
                   // print(Response)
                    if let isVerifiedVal = Response["isVerified"] as? Bool {
                        if isVerifiedVal == true {
                            showAlertMessage(vc: self, messageStr: "This email is Varified")
                        } else{
                            print("not varified")
                        }
                    }
                }
            }
        }
    }
    
    func changePasswordAPI(authToken : Any) {
        var params = [String:AnyObject]()
        params[kOldPassword] = kTokenAuthUserName as AnyObject
        params[kNewPassword] = kTokenAuthPassword as AnyObject

        Put(params: params, url: kSignup) { (succeeded: Bool, Response: NSDictionary) in
            DispatchQueue.main.async {
                if(succeeded) {
                    print(Response)
                }
            }
        }
    }
    
    func sendverificationmailAPI(authToken : Any) {
        var params = [String:AnyObject]()
        params[kEmail] = kTokenAuthUserName as AnyObject
   
        post(params: params, url: kSendVarificationMail) { (succeeded: Bool, Response: NSDictionary) in
            DispatchQueue.main.async {
                if(succeeded) {
                  //  print(Response)
                    if let messageVal = Response["message"] as? String {
                        showAlertMessage(vc: self, messageStr: messageVal)
                    }
                }
            }
        }
    }
    
    
    func attendeeEventsAPI(authToken : Any) {
        Get(url: kAttendeeEvents) { (succeeded: Bool, Response: NSDictionary) in
            DispatchQueue.main.async {
                if(succeeded) {
                   // print(Response)
                    if let data = Response["data"] as? [[String:AnyObject]] {
                        let atendeeEventsModels = self.fillAtendeeEventsModel(arrEventsData: data)
                        print(atendeeEventsModels)
                    }
                }
            }
        }
    }

    
    func eventAssociatesExistAPI(eventId : String) {
        Get(url: "\(kEventAssociatesExist)\(eventId)") { (succeeded: Bool, Response: NSDictionary) in
            DispatchQueue.main.async {
                if(succeeded) {
                   // print(Response)
                    if let data = Response["data"] as? [String:AnyObject] {
                        let eventAssociatesExistModel = self.fillEventAssociatesExistModel(arrEventAssociatesExist: data)
                        print(eventAssociatesExistModel)
                   }
                }
            }
        }
    }
    
    
    func getEventDetailsAPI(eventId : String) {
        Get(url: "\(kEventDetails)\(eventId)") { (succeeded: Bool, Response: NSDictionary) in
            DispatchQueue.main.async {
                if(succeeded) {
                   //  print(Response)
                    let eventDetailModel = self.fillEventDetailModel(arrEventDetail: Response as! [String : AnyObject])
                    print(eventDetailModel)
                }
            }
        }
    }
    
    
    func getSpeakerListAPI(eventId : String) {
        Get(url: "\(kSpeakerList)\(eventId)") { (succeeded: Bool, Response: NSDictionary) in
            DispatchQueue.main.async {
                if(succeeded) {
                   //  print(Response)
                    if let data = Response["data"] as? [[String:AnyObject]] {
                        let speakerListModels = self.fillSpeakerListModel(arrSpeakerListData: data)
                        print(speakerListModels)
                    }
                }
            }
        }
    }
    
    
    func getEventAgendaListAPI(eventId : String) {
        GetAny(url: "\(kEventAgendaList)\(eventId)") { (succeeded: Bool, Response: Any) in
            DispatchQueue.main.async {
                if(succeeded) {
                   // print(Response)
                    if let agendaData:[[String:AnyObject]] = Response as? [[String : AnyObject]] {
                        let arrAgendaListModel = self.fillAgendaListModel(arrAgendaListData: agendaData)
                        print(arrAgendaListModel)
                    }
                }
            }
        }
    }
    
    
    func getMyScheduleListAPI(eventId : String) {
        GetAny(url: "\(kAttendeeAgendaList)\(eventId)") { (succeeded: Bool, Response: Any) in
            DispatchQueue.main.async {
                if(succeeded) {
                    // print(Response)
                    if let attendeeAgendaDataData:[[String:AnyObject]] = Response as? [[String : AnyObject]] {
                        let arrAttendeeAgendaListModel = self.fillAttendiAgendaListModel(arrAttendiAgendaListData: attendeeAgendaDataData)
                        print(arrAttendeeAgendaListModel)
                    }
                }
            }
        }
    }
    
    func getAttendeeListAPI(eventId : String) {
        GetAny(url: "\(kAttendeeList)\(eventId)") { (succeeded: Bool, Response: Any) in
            DispatchQueue.main.async {
                if(succeeded) {
                     //print(Response)
                    if let attendeeListData:[[String:AnyObject]] = Response as? [[String : AnyObject]] {
                        let arrAttendeeListModel = self.fillAttendeeListModel(arrAttendeeListData: attendeeListData)
                        print(arrAttendeeListModel)
                    }
                }
            }
        }
    }
    
    func getAwardsListAPI(eventId : String) {
        GetAny(url: "\(kAwardsList)\(eventId)") { (succeeded: Bool, Response: Any) in
            DispatchQueue.main.async {
                if(succeeded) {
                    print(Response)
                    if let attendeeListData:[[String:AnyObject]] = Response as? [[String : AnyObject]] {
                        let arrAttendeeListModel = self.fillAttendeeListModel(arrAttendeeListData: attendeeListData)
                        print(arrAttendeeListModel)
                    }
                }
            }
        }
    }
    
//MARK:- MODEL FILL UP -
    
    func fillAtendeeEventsModel(arrEventsData : [[String:AnyObject]]) -> [EventDataModel] {
        var arrAtendeeEventsDataModel = [EventDataModel]()
        for eventData in arrEventsData {
            let tempEventDataModel = EventDataModel()
            
            if let eventTitleVal = eventData["eventTitle"] as? String {
                tempEventDataModel.eventTitle = eventTitleVal
            } else{
                tempEventDataModel.eventTitle = ""
            }
            
            if let eventCityVal = eventData["city"] as? String {
                tempEventDataModel.city = eventCityVal
            } else{
                tempEventDataModel.city = ""
            }
            
            if let eventIdVal = eventData["eventId"] as? String {
                tempEventDataModel.eventId = eventIdVal
            } else{
                tempEventDataModel.eventId = ""
            }
            
            if let eventStartDateTimeVal = eventData["startDateTime"] as? String {
                tempEventDataModel.startDateTime = eventStartDateTimeVal
            } else{
                tempEventDataModel.startDateTime = ""
            }
            
            if let eventLogoVal = eventData["eventLogo"] as? String {
                tempEventDataModel.eventLogo = eventLogoVal
            } else{
                tempEventDataModel.eventLogo = ""
            }
            
            if let eventStateVal = eventData["state"] as? String {
                tempEventDataModel.state = eventStateVal
            } else{
                tempEventDataModel.state = ""
            }
            
            arrAtendeeEventsDataModel.append(tempEventDataModel)
        }
        return arrAtendeeEventsDataModel
    }
    
    
    func fillEventAssociatesExistModel(arrEventAssociatesExist : [String:AnyObject]) -> [EventAssociatesExitsDataModel] {
        var arrEventAssociatesExistModel = [EventAssociatesExitsDataModel]()
        let tempEventAssociatesExistData = EventAssociatesExitsDataModel()
        
        if let hasAgendaVal = arrEventAssociatesExist["hasAgenda"] as? Bool {
            tempEventAssociatesExistData.hasAgenda = hasAgendaVal
        } else{
            tempEventAssociatesExistData.hasAgenda = false
        }
        
        if let hasAttendeesVal = arrEventAssociatesExist["hasAttendees"] as? Bool {
            tempEventAssociatesExistData.hasAttendees = hasAttendeesVal
        } else{
            tempEventAssociatesExistData.hasAttendees = false
        }
        
        if let hasAwardsVal = arrEventAssociatesExist["hasAwards"] as? Bool {
            tempEventAssociatesExistData.hasAwards = hasAwardsVal
        } else{
            tempEventAssociatesExistData.hasAwards = false
        }
        
        if let hasCheckInVal = arrEventAssociatesExist["hasCheckIn"] as? Bool {
            tempEventAssociatesExistData.hasCheckIn = hasCheckInVal
        } else{
            tempEventAssociatesExistData.hasCheckIn = false
        }
        
        if let hasEmergencyVal = arrEventAssociatesExist["hasEmergency"] as? Bool {
            tempEventAssociatesExistData.hasEmergency = hasEmergencyVal
        } else{
            tempEventAssociatesExistData.hasEmergency = false
        }
        
        if let hasEventMapVal = arrEventAssociatesExist["hasEventMap"] as? Bool {
            tempEventAssociatesExistData.hasEventMap = hasEventMapVal
        } else{
            tempEventAssociatesExistData.hasEventMap = false
        }
        
        if let hasExpoVal = arrEventAssociatesExist["hasExpo"] as? Bool {
            tempEventAssociatesExistData.hasExpo = hasExpoVal
        } else{
            tempEventAssociatesExistData.hasExpo = false
        }
        
        if let hasFaqVal = arrEventAssociatesExist["hasFaq"] as? Bool {
            tempEventAssociatesExistData.hasFaq = hasFaqVal
        } else{
            tempEventAssociatesExistData.hasFaq = false
        }
        
        if let hasSocialVal = arrEventAssociatesExist["hasSocial"] as? Bool {
            tempEventAssociatesExistData.hasSocial = hasSocialVal
        } else{
            tempEventAssociatesExistData.hasSocial = false
        }
        
        if let hasSpeakersVal = arrEventAssociatesExist["hasSpeakers"] as? Bool {
            tempEventAssociatesExistData.hasSpeakers = hasSpeakersVal
        } else{
            tempEventAssociatesExistData.hasSpeakers = false
        }
        
        if let hasSponsorsVal = arrEventAssociatesExist["hasSponsors"] as? Bool {
            tempEventAssociatesExistData.hasSponsors = hasSponsorsVal
        } else{
            tempEventAssociatesExistData.hasSponsors = false
        }
        
        if let hasSurveyVal = arrEventAssociatesExist["hasSurvey"] as? Bool {
            tempEventAssociatesExistData.hasSurvey = hasSurveyVal
        } else{
            tempEventAssociatesExistData.hasSurvey = false
        }
        
        arrEventAssociatesExistModel.append(tempEventAssociatesExistData)
        
        return arrEventAssociatesExistModel
    }
    
    
     func fillEventDetailModel(arrEventDetail : [String:AnyObject]) -> [EventDetailDataModel] {
        var arrEventDetailModel = [EventDetailDataModel]()
        let tempEventDetailData = EventDetailDataModel()
        
        if let cityVal = arrEventDetail["city"] as? String {
           tempEventDetailData.city = cityVal
        } else{
             tempEventDetailData.city = ""
        }
        
        if let countryVal = arrEventDetail["country"] as? String {
            tempEventDetailData.country = countryVal
        } else{
            tempEventDetailData.country = ""
        }
        
        if let createdAtVal = arrEventDetail["createdAt"] as? String {
            tempEventDetailData.createdAt = createdAtVal
        } else{
            tempEventDetailData.createdAt = ""
        }
        
        if let descriptionVal = arrEventDetail["description"] as? String {
            tempEventDetailData.descriptionData = descriptionVal
        } else{
            tempEventDetailData.descriptionData = ""
        }
        
        if let endDateTimeVal = arrEventDetail["endDateTime"] as? String {
            tempEventDetailData.endDateTime = endDateTimeVal
        } else{
            tempEventDetailData.endDateTime = ""
        }
        
        if let eventBudgetVal = arrEventDetail["eventBudget"] as? NSNumber {
            tempEventDetailData.eventBudget = eventBudgetVal
        } else{
            tempEventDetailData.eventBudget = 0
        }
        
        if let eventIdVal = arrEventDetail["eventId"] as? NSNumber {
            tempEventDetailData.eventId = eventIdVal
        } else{
            tempEventDetailData.eventId = 0
        }
        
        if let eventLogoVal = arrEventDetail["eventLogo"] as? String {
            tempEventDetailData.eventLogo = eventLogoVal
        } else{
            tempEventDetailData.eventLogo = ""
        }
        
        if let eventTitleVal = arrEventDetail["eventTitle"] as? String {
            tempEventDetailData.eventTitle = eventTitleVal
        } else{
            tempEventDetailData.eventTitle = ""
        }
        
        if let eventTypeVal = arrEventDetail["eventType"] as? String {
            tempEventDetailData.eventType = eventTypeVal
        } else{
            tempEventDetailData.eventType = ""
        }
        
        if let linkOnFbVal = arrEventDetail["linkOnFb"] as? String {
            tempEventDetailData.linkOnFb = linkOnFbVal
        } else{
            tempEventDetailData.linkOnFb = ""
        }
        
        if let linkOnInstagramVal = arrEventDetail["linkOnInstagram"] as? String {
            tempEventDetailData.linkOnInstagram = linkOnInstagramVal
        } else{
            tempEventDetailData.linkOnInstagram = ""
        }
        
        if let linkOnLinkedinVal = arrEventDetail["linkOnLinkedin"] as? String {
            tempEventDetailData.linkOnLinkedin = linkOnLinkedinVal
        } else{
            tempEventDetailData.linkOnLinkedin = ""
        }
        
        if let linkOnTwitterVal = arrEventDetail["linkOnTwitter"] as? String {
            tempEventDetailData.linkOnTwitter = linkOnTwitterVal
        } else{
            tempEventDetailData.linkOnTwitter = ""
        }
        
        if let locationMapUrlVal = arrEventDetail["locationMapUrl"] as? String {
            tempEventDetailData.locationMapUrl = locationMapUrlVal
        } else{
            tempEventDetailData.locationMapUrl = ""
        }
        
        if let numberOfGuestsVal = arrEventDetail["numberOfGuests"] as? NSNumber {
            tempEventDetailData.numberOfGuests = numberOfGuestsVal
        } else{
            tempEventDetailData.numberOfGuests = 0
        }
        
        if let startDateTimeVal = arrEventDetail["startDateTime"] as? String {
            tempEventDetailData.startDateTime = startDateTimeVal
        } else{
            tempEventDetailData.startDateTime = ""
        }
        
        if let stateVal = arrEventDetail["state"] as? String {
            tempEventDetailData.state = stateVal
        } else{
            tempEventDetailData.state = ""
        }
        
        if let statusVal = arrEventDetail["status"] as? String {
            tempEventDetailData.status = statusVal
        } else{
            tempEventDetailData.status = ""
        }
        
        if let streetVal = arrEventDetail["street"] as? String {
            tempEventDetailData.street = streetVal
        } else{
            tempEventDetailData.street = ""
        }
        
        if let surveyUrlVal = arrEventDetail["surveyUrl"] as? String {
            tempEventDetailData.surveyUrl = surveyUrlVal
        } else{
            tempEventDetailData.surveyUrl = ""
        }
        
        if let ticketTypeVal = arrEventDetail["ticketType"] as? String {
            tempEventDetailData.ticketType = ticketTypeVal
        } else{
            tempEventDetailData.ticketType = ""
        }
        
        if let websiteUrlVal = arrEventDetail["websiteUrl"] as? String {
            tempEventDetailData.websiteUrl = websiteUrlVal
        } else{
            tempEventDetailData.websiteUrl = ""
        }
        
        if let zipCodeVal = arrEventDetail["zipCode"] as? NSNumber {
            tempEventDetailData.zipCode = zipCodeVal
        } else{
            tempEventDetailData.zipCode = 0
        }
        
        arrEventDetailModel.append(tempEventDetailData)
        return arrEventDetailModel
    }
    
    
    
    func fillSpeakerListModel(arrSpeakerListData : [[String:AnyObject]]) -> [SpeakerListDataModel] {
        var arrSpeakerListDataModel = [SpeakerListDataModel]()
        for SpeakerList in arrSpeakerListData {
            let tempSpeakerListDataModel = SpeakerListDataModel()
            
            if let companyNameVal = SpeakerList["companyName"] as? String {
                tempSpeakerListDataModel.companyName = companyNameVal
            } else{
                tempSpeakerListDataModel.companyName = ""
            }
            
            if let departmentVal = SpeakerList["department"] as? String {
                tempSpeakerListDataModel.department = departmentVal
            } else{
                tempSpeakerListDataModel.department = ""
            }
            
            if let designationVal = SpeakerList["designation"] as? String {
                tempSpeakerListDataModel.designation = designationVal
            } else{
                tempSpeakerListDataModel.designation = ""
            }
            
            if let industryVal = SpeakerList["industry"] as? String {
                tempSpeakerListDataModel.industry = industryVal
            } else{
                tempSpeakerListDataModel.industry = ""
            }
            
            if let linkedinUrlVal = SpeakerList["linkedinUrl"] as? String {
                tempSpeakerListDataModel.linkedinUrl = linkedinUrlVal
            } else{
                tempSpeakerListDataModel.linkedinUrl = ""
            }
            
            if let photoUrlVal = SpeakerList["photoUrl"] as? String {
                tempSpeakerListDataModel.photoUrl = photoUrlVal
            } else{
                tempSpeakerListDataModel.photoUrl = ""
            }
            
            if let speakerNameVal = SpeakerList["speakerName"] as? String {
                tempSpeakerListDataModel.speakerName = speakerNameVal
            } else{
                tempSpeakerListDataModel.speakerName = ""
            }
            
            if let speakerIdVal = SpeakerList["speakerId"] as? NSNumber {
                tempSpeakerListDataModel.speakerId = speakerIdVal
            } else{
                tempSpeakerListDataModel.speakerId = 0
            }
            arrSpeakerListDataModel.append(tempSpeakerListDataModel)
        }
        return arrSpeakerListDataModel
    }
    
    
    func fillAgendaListModel(arrAgendaListData : [[String:AnyObject]]) -> [AgendaListDataModel] {
        var arrAgendaListDataModel = [AgendaListDataModel]()
        for agendaList in arrAgendaListData {
            let tempAgendaListDataModel = AgendaListDataModel()
            
            if let endDateTimeVal = agendaList["endDateTime"] as? String {
                tempAgendaListDataModel.endDateTime = endDateTimeVal
            } else{
                tempAgendaListDataModel.endDateTime = ""
            }
            
            if let startDateTimeVal = agendaList["startDateTime"] as? String {
                tempAgendaListDataModel.startDateTime = startDateTimeVal
            } else{
                tempAgendaListDataModel.startDateTime = ""
            }
            
            if let itemDescriptionVal = agendaList["itemDescription"] as? String {
                tempAgendaListDataModel.itemDescription = itemDescriptionVal
            } else{
                tempAgendaListDataModel.itemDescription = ""
            }
            
            if let itemLocationVal = agendaList["itemLocation"] as? String {
                tempAgendaListDataModel.itemLocation = itemLocationVal
            } else{
                tempAgendaListDataModel.itemLocation = ""
            }
            
            if let itemTitleVal = agendaList["itemTitle"] as? String {
                tempAgendaListDataModel.itemTitle = itemTitleVal
            } else{
                tempAgendaListDataModel.itemTitle = ""
            }
           
            if let isInAttendeeScheduleVal = agendaList["isInAttendeeSchedule"] as? Bool {
                tempAgendaListDataModel.isInAttendeeSchedule = isInAttendeeScheduleVal
            } else{
                tempAgendaListDataModel.isInAttendeeSchedule = false
            }
            
            if let agendaIdVal = agendaList["agendaId"] as? NSNumber {
                tempAgendaListDataModel.agendaId = agendaIdVal
            } else{
                tempAgendaListDataModel.agendaId = 0
            }
            
            
            if let speakersVal = agendaList["speakers"] as? [[String:AnyObject]] {
                for data in speakersVal {
                    let arrTempSpeaker = speakersModel()
                   // print(data)
                    
                    if let speakerIdVal = data["speakerId"] as? NSNumber {
                        arrTempSpeaker.speakerId = speakerIdVal
                    } else{
                        arrTempSpeaker.speakerId = 0
                    }
                    
                    if let speakerNameVal = data["speakerName"] as? String {
                        arrTempSpeaker.speakerName = speakerNameVal
                    } else{
                        arrTempSpeaker.speakerName = ""
                    }
                    
                    tempAgendaListDataModel.speakers?.append(arrTempSpeaker)
                }
            }
            
            arrAgendaListDataModel.append(tempAgendaListDataModel)
        }
        return arrAgendaListDataModel
    }
    
    
    func fillAttendiAgendaListModel(arrAttendiAgendaListData : [[String:AnyObject]]) -> [AgendaListDataModel] {
        var arrAttendeeAgendaListDataModel = [AgendaListDataModel]()
        for attendeeAgendaList in arrAttendiAgendaListData {
            let tempAttendeeAgendaListDataModel = AgendaListDataModel()
            
            if let endDateTimeVal = attendeeAgendaList["endDateTime"] as? String {
                tempAttendeeAgendaListDataModel.endDateTime = endDateTimeVal
            } else{
                tempAttendeeAgendaListDataModel.endDateTime = ""
            }
            
            if let startDateTimeVal = attendeeAgendaList["startDateTime"] as? String {
                tempAttendeeAgendaListDataModel.startDateTime = startDateTimeVal
            } else{
                tempAttendeeAgendaListDataModel.startDateTime = ""
            }
            
            if let itemDescriptionVal = attendeeAgendaList["itemDescription"] as? String {
                tempAttendeeAgendaListDataModel.itemDescription = itemDescriptionVal
            } else{
                tempAttendeeAgendaListDataModel.itemDescription = ""
            }
            
            if let itemLocationVal = attendeeAgendaList["itemLocation"] as? String {
                tempAttendeeAgendaListDataModel.itemLocation = itemLocationVal
            } else{
                tempAttendeeAgendaListDataModel.itemLocation = ""
            }
            
            if let itemTitleVal = attendeeAgendaList["itemTitle"] as? String {
                tempAttendeeAgendaListDataModel.itemTitle = itemTitleVal
            } else{
                tempAttendeeAgendaListDataModel.itemTitle = ""
            }
            
            if let isInAttendeeScheduleVal = attendeeAgendaList["isInAttendeeSchedule"] as? Bool {
                tempAttendeeAgendaListDataModel.isInAttendeeSchedule = isInAttendeeScheduleVal
            } else{
                tempAttendeeAgendaListDataModel.isInAttendeeSchedule = false
            }
            
            if let agendaIdVal = attendeeAgendaList["agendaId"] as? NSNumber {
                tempAttendeeAgendaListDataModel.agendaId = agendaIdVal
            } else{
                tempAttendeeAgendaListDataModel.agendaId = 0
            }
            
            
            if let speakersVal = attendeeAgendaList["speakers"] as? [[String:AnyObject]] {
                for data in speakersVal {
                    let arrTempSpeaker = speakersModel()
                    // print(data)
                    
                    if let speakerIdVal = data["speakerId"] as? NSNumber {
                        arrTempSpeaker.speakerId = speakerIdVal
                    } else{
                        arrTempSpeaker.speakerId = 0
                    }
                    
                    if let speakerNameVal = data["speakerName"] as? String {
                        arrTempSpeaker.speakerName = speakerNameVal
                    } else{
                        arrTempSpeaker.speakerName = ""
                    }
                    
                    tempAttendeeAgendaListDataModel.speakers?.append(arrTempSpeaker)
                }
            }
            
            arrAttendeeAgendaListDataModel.append(tempAttendeeAgendaListDataModel)
        }
        return arrAttendeeAgendaListDataModel
    }
    
    
    
    func fillAttendeeListModel(arrAttendeeListData : [[String:AnyObject]]) -> [AttendeeListDataModel] {
        var arrAttendeeListDataModel = [AttendeeListDataModel]()
        for attendeeList in arrAttendeeListData {
            let tempAttendeeListDataModel = AttendeeListDataModel()
            
            if let attendeeNameVal = attendeeList["attendeeName"] as? String {
                tempAttendeeListDataModel.attendeeName = attendeeNameVal
            } else{
                tempAttendeeListDataModel.attendeeName = ""
            }
            
            if let companyNameVal = attendeeList["companyName"] as? String {
                tempAttendeeListDataModel.companyName = companyNameVal
            } else{
                tempAttendeeListDataModel.companyName = ""
            }
            
            if let departmentVal = attendeeList["department"] as? String {
                tempAttendeeListDataModel.department = departmentVal
            } else{
                tempAttendeeListDataModel.department = ""
            }
            
            if let designationVal = attendeeList["designation"] as? String {
                tempAttendeeListDataModel.designation = designationVal
            } else{
                tempAttendeeListDataModel.designation = ""
            }
            
            if let industryVal = attendeeList["industry"] as? String {
                tempAttendeeListDataModel.industry = industryVal
            } else{
                tempAttendeeListDataModel.industry = ""
            }
            
            if let photoUrlVal = attendeeList["photoUrl"] as? String {
                tempAttendeeListDataModel.photoUrl = photoUrlVal
            } else{
                tempAttendeeListDataModel.photoUrl = ""
            }
            
            if let attendeeIdVal = attendeeList["attendeeId"] as? NSNumber {
                tempAttendeeListDataModel.attendeeId = attendeeIdVal
            } else{
                tempAttendeeListDataModel.attendeeId = 0
            }
            
            arrAttendeeListDataModel.append(tempAttendeeListDataModel)
        }
        return arrAttendeeListDataModel
    }
    
    
    
//    func fillAwardsListModel(arrAwardsListData : [[String:AnyObject]]) -> [AwardsListDataModel] {
//        var arrAttendeeListDataModel = [AwardsListDataModel]()
//        for attendeeList in arrAttendeeListData {
//            let tempAttendeeListDataModel = AwardsListDataModel()
//            
//            if let attendeeNameVal = attendeeList["attendeeName"] as? String {
//                tempAttendeeListDataModel.attendeeName = attendeeNameVal
//            } else{
//                tempAttendeeListDataModel.attendeeName = ""
//            }
//        }
//    }
    
}

