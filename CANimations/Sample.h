//
//  Sample.h
//  CANimations
//
//  Created by Vladyslav Gamalii on 31.05.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Sample : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSString *publishDate;
@property (assign, nonatomic) double price;

@end
