//
//  SampleTableViewCell.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 01.06.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "SampleTableViewCell.h"

@interface SampleTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;

@end

@implementation SampleTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (void)setName:(NSString *)name
{
    self.authorNameLabel.text = name;
}

- (void)setTitle:(NSString *)title
{
    self.bookTitleLabel.text = title;
}

@end
