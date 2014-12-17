//
//  TextureSpliter.h
//  TextureSpliter
//
//  Created by wang haibo on 13-3-19.
//  Copyright (c) 2013年 wang haibo. All rights reserved.
//
#import <CoreFoundation/CoreFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AppKit/AppKit.h>
@interface TextureSpliter : NSObject
{
    NSDictionary*   _plistDictionary;
    NSString*       _outputdir;
    
    NSString*       _srcTextureFileName;
    
    NSDictionary*   _frames;
}
-(id)initWithPlistAndOutputDir : (NSString*)plistFile outputDir : (NSString*) outputdir;
-(void) startSplit;
@end
