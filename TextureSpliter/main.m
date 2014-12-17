//
//  main.m
//  TextureSpliter
//
//  Created by wang haibo on 13-3-19.
//  Copyright (c) 2013年 wang haibo. All rights reserved.
//

#import "TextureSpliter.h"
int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if(argc != 3)
        {
            NSLog(@"Usage: TextureSpliter [plistfile] [outputdir]");
            return 0;
        }
        TextureSpliter* spliter = [[TextureSpliter alloc] initWithPlistAndOutputDir:[NSString stringWithUTF8String:argv[1]] outputDir:[NSString stringWithUTF8String:argv[2]]];
        if(spliter != nil)
        {
            [spliter startSplit];
        }
    }
    return 0;
}

