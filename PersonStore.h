//
//  PersonStore.h
//  BWsim
//
//  Created by Carson Chow on 12/30/12.
//  Copyright (c) 2012 NIDDK, NIH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface PersonStore : NSObject
{
    NSMutableArray *allPersons;
}

+ (PersonStore *)sharedStore;

- (NSArray *)allPersons;
- (Person *)createPerson;

@end
