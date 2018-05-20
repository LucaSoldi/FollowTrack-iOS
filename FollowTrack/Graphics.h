//
//  Graphics.h
//  FollowTrack
//
//  Created by Luca Soldi on 14/02/18.
//  Copyright (c) 2018 CompanyName. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Graphics : NSObject

// iOS Controls Customization Outlets
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* logoTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* loginmailbuttonTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* facebooklogoTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* twitterlogoTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* nextlogoTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* googlelogoTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* followiconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* usericonTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* addTrackIconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* backimageTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* whatsappshareiconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* telegramshareiconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* settings_iconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* leadericonTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* followericonTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* successiconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* chaticonTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* aborticonTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* trackiconTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* positioniconTargets;

// Colors
+ (UIColor*)fillColor;
+ (UIColor*)fillColor2;

// Generated Images
+ (UIImage*)imageOfLogo;
+ (UIImage*)imageOfLoginmailbutton;
+ (UIImage*)imageOfFacebooklogo;
+ (UIImage*)imageOfTwitterlogo;
+ (UIImage*)imageOfNextlogo;
+ (UIImage*)imageOfGooglelogo;
+ (UIImage*)imageOfFollowicon;
+ (UIImage*)imageOfUsericon;
+ (UIImage*)imageOfAddTrackIcon;
+ (UIImage*)imageOfBackimage;
+ (UIImage*)imageOfWhatsappshareicon;
+ (UIImage*)imageOfTelegramshareicon;
+ (UIImage*)imageOfSettings_icon;
+ (UIImage*)imageOfLeadericon;
+ (UIImage*)imageOfFollowericon;
+ (UIImage*)imageOfSuccessicon;
+ (UIImage*)imageOfChaticon;
+ (UIImage*)imageOfAborticon;
+ (UIImage*)imageOfTrackicon;
+ (UIImage*)imageOfPositionicon;

@end
