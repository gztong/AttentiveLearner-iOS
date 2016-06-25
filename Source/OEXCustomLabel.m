//
//  OEXCustomLabel.m
//  edXVideoLocker
//
//  Created by Rahul Varma on 09/06/14.
//  Copyright (c) 2014 edX. All rights reserved.
//

#import "OEXCustomLabel.h"

@implementation OEXCustomLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        // set custom font to labels through code
        self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0];
    }

    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        // set custom font to labels in storyboard

        switch(self.tag)
        {
            case 106:   //You will be redirected to the edX.org Sign up page.
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 107:   //https://courses.edx.org/register
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 108:   //Or Sign In With
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.font.pointSize];
                break;
            case 109:   //Sign In Title
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.font.pointSize];
                break;

            case 201:   // Rareview - Username
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 202:   // Rareview - Email
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 203:   // Rareview - MY COURSE
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 204:   // Rareview - MY VIDEOS
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 205:   // Rareview - settings
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 206:   // Rareview - download
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 207:   // Rareview - Version
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 301:   // FrontView Course - Title
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.font.pointSize];
                break;

            case 302:   // FrontView Course - Sub-Title
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 304:   // FrontView Course - starting
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 401:   // TabView Course (Level -1) - TabName
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 402:   // TabView Course (Level -1) - LAST ACCESSED
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.font.pointSize];
                break;

            case 403:   // TabView Course (Level -1) - LAST ACCESSED VALUE
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.font.pointSize];
                break;

            case 404:   // TabView Course (Level -1) - Course Name
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 405:   // TabView Course (Level -1) - Course Count
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.font.pointSize];
                break;

            case 501:   // Generic TabView - Title
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.font.pointSize];
                break;

            case 502:   // Generic TabView - Time
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 503:   // Generic TabView - Size
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 601:   // Course Video List View - Title
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.font.pointSize];
                break;

            case 602:   // Course Video List View - Time
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 603:   // Course Video List View - Size
                self.font = [UIFont fontWithName:@"OpenSans" size:self.font.pointSize];
                break;

            case 701:   // Course Video Download Screen Video title - Size
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0f];
                break;

            case 702:   // Course Video Download Screen Video course title - Size
                self.font = [UIFont fontWithName:@"OpenSans" size:15.0f];
                break;

            case 703:   // Course Video Download Screen Video section title - Size
                self.font = [UIFont fontWithName:@"OpenSans" size:12.0f];
                break;

            case 801:   //Download view Controller
                self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20.0f];

            case 802:   //Download view Controller
                self.font = [UIFont fontWithName:@"OpenSans" size:16.0f];
            default:
                break;
        }
    }
    return self;
}

@end
