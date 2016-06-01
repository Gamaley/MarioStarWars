//
//  SampleTableViewCell.h
//  CANimations
//
//  Created by Vladyslav Gamalii on 01.06.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"

@interface SampleTableViewCell : UITableViewCell

@property (strong, nonatomic) Sample *sampleObject;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *title;

+ (NSString *)reuseIdentifier;

@end
