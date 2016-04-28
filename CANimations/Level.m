//
//  Level.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 25.04.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "Level.h"

@implementation Level

- (instancetype)initWithLevel:(NSInteger)level
{
    self = [super init];
    if (self) {
        self.number = level;
        self.identifier = [NSUUID UUID].UUIDString;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.number forKey:@"level"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.number = [aDecoder decodeIntegerForKey:@"level"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
    }
    return self;
}


@end
