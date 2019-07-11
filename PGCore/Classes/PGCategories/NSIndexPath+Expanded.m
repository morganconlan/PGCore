//
//  NSIndexPath+Expanded.m
//  pgcore
//
//  Created by Morgan Conlan on 16/04/2015.
//  Copyright (c) 2015 Morgan Conlan. All rights reserved.
//

#import "NSIndexPath+Expanded.h"

@implementation NSIndexPath (Expanded)

- (NSUInteger)hash{

    char str[11];
    int row = self.row;
    int section = self.section;
    sprintf(str, "%d%d", section,row);

    unsigned int val = 0;
    char *p;
    int i;
    p = str;

    for(i = 0; p[i]; i++){

        if (i == 0) {

            val = (unsigned char)p[i] << CHAR_BIT;

        } else {

            val |= (unsigned char)p[i];
        }
    }

    return val;

}

@end
