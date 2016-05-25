//
//  TimeConverter.m
//  TimerApp
//
//  Created by Boris Filipović on 1/2/15.
//  Copyright (c) 2015 Boris Filipović. All rights reserved.
//

#import "TimeConverter.h"

@implementation TimeConverter

-(NSString *)convertTime:(int)paramTime
{
    if (paramTime < 60) {
        // Less than minute.
        return [NSString stringWithFormat:@"%is", paramTime];
    } else if(paramTime < 3600) {
        // Less than 1 hour.
        int seconds;
        int minutes;
        
        seconds = fmod(paramTime, 60); // Calculate seconds.
        minutes = paramTime/60; // Calculate minutes.
        
        return [NSString stringWithFormat:@"%im : %is", minutes, seconds];
    } else if (paramTime < 86400){
        // Les than day
        int seconds;
        int minutes;
        int days;
        
        seconds = fmod(paramTime, 60); // Calculate seconds.
        minutes = paramTime/60; // Calculate minutes.
        days = paramTime/3600; //Calculate days.
        
        return [NSString stringWithFormat:@"%id : %im : %is", days, minutes, seconds];
    }
    
    return @"error";
}

@end
