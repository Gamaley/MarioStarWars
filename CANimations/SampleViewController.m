//
//  SampleViewController.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 01.06.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "SampleViewController.h"


@interface SampleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI
{
    self.titleLabel.text = self.sampleObject.title;
    self.authorLabel.text = self.sampleObject.author;
    self.genreLabel.text = self.sampleObject.genre;
    self.publishDateLabel.text = self.sampleObject.publishDate;
    self.descriptionTextView.text = self.sampleObject.info;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f$",self.sampleObject.price];
}

@end
