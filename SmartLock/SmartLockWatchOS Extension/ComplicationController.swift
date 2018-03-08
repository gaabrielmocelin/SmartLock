//
//  ComplicationController.swift
//  SmartLockWatchOS Extension
//
//  Created by Rafael Cadaval on 08/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import WatchKit
import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        //let delegate = WKExtension.shared().delegate as! ExtensionDelegate  <<<< MIGHT NEED IT
        
        if complication.family == .modularSmall {
            let modularSmallSimpleImageComplicationTemplate = CLKComplicationTemplateModularSmallSimpleImage()
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: modularSmallSimpleImageComplicationTemplate)
            handler(timelineEntry)
        } else if complication.family == .circularSmall {
            let circularSmallSimpleImageComplicationTemplate = CLKComplicationTemplateCircularSmallSimpleImage()
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: circularSmallSimpleImageComplicationTemplate)
            handler(timelineEntry)
        } else {
            handler(nil)
        }
        
    }
    
}
