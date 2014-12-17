//
//  TextureSpliter.m
//  TextureSpliter
//
//  Created by wang haibo on 13-3-19.
//  Copyright (c) 2013年 wang haibo. All rights reserved.
//

#import "TextureSpliter.h"

@implementation TextureSpliter
-(id)initWithPlistAndOutputDir : (NSString*)plistFile outputDir : (NSString*) outputdir{
    if(self = [super init])
    {
        _plistDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistFile];
        if(_plistDictionary == nil)
        {
            NSLog(@"plist file is not exist!");
            return nil;
        }
        _outputdir = outputdir;
        [[NSFileManager defaultManager] createDirectoryAtPath:outputdir withIntermediateDirectories:NO attributes:nil error:nil];
        
        NSDictionary* metadata = [_plistDictionary objectForKey:@"metadata"];
        if(metadata != nil)
        {
            NSDictionary* target = [metadata objectForKey:@"target"];
            if(target != nil)
            {
                NSString* textureFileName = [target valueForKey:@"textureFileName"];
                NSString* extensionName = [target valueForKey:@"textureFileExtension"];
                _srcTextureFileName = [textureFileName stringByAppendingString:extensionName];
                if(![[NSFileManager defaultManager] fileExistsAtPath:_srcTextureFileName])
                {
                    NSLog(@"source image file %@ is not exist!", _srcTextureFileName);
                    return nil;
                }
            }
        }
        _frames = [_plistDictionary objectForKey:@"frames"];
    }
    return self;
}

-(void)startSplit{
    
    NSData *data = [NSData dataWithContentsOfFile: _srcTextureFileName];
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(data),  NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    NSEnumerator  *e  =  [_frames  keyEnumerator];
    for  (NSString  *filename  in  e)  {
        NSDictionary* frame = [_frames  objectForKey:filename];
        if(frame != nil)
        {
            NSString* strRect = [frame valueForKey:@"textureRect"];
            if(strRect != nil)
            {
                NSRect rect = NSRectFromString(strRect);
                CGImageRef small = CGImageCreateWithImageInRect(imageRef, NSRectToCGRect(rect));
                if(small != nil)
                {
                    NSImage* image = [[NSImage alloc] initWithCGImage:small size:rect.size];
                    [image lockFocus];
                    //先设置 下面一个实例
                    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc]initWithFocusedViewRect:NSMakeRect(0, 0, rect.size.width, rect.size.height)];
                    [image unlockFocus];
                    //再设置后面要用到得 props属性
                    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
                    //之后 转化为NSData 以便存到文件中
                    NSData *imageData = [bits representationUsingType:NSPNGFileType properties:imageProps];
                    //设定好文件路径后进行存储就ok了
                    
                    NSString* fullFileName = [_outputdir stringByAppendingFormat:@"/%@", filename];
                    [imageData writeToFile:fullFileName atomically:NO];
                }
            }
        }
    }
}
@end
