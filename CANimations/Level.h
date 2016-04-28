//
//  Level.h
//  CANimations
//
//  Created by Vladyslav Gamalii on 25.04.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject <NSCoding>

@property (strong, nonatomic) NSString *identifier;
@property (assign, nonatomic) NSInteger number;

- (instancetype)initWithLevel:(NSInteger)level;

@end
