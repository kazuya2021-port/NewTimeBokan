//
//  Strings.h
//  testAS
//
//  Created by 内山 和也 on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface NSApplication (ASKAStrings)

// NSString Applescript Wrapper
-(unsigned int)searchUnderbar:(NSString*)str;
-(NSString*)kzsubstringToIndex:(NSString*)str aIndex:(unsigned int)i;
-(NSString*)kzsubstringFromIndex:(NSString*)str aIndex:(unsigned int)i;
-(NSString*)kzsubstringToMidIndex:(NSString*)str aIndex:(unsigned int)i bIndex:(unsigned int)j;
-(NSRange)isInStr:(NSString*)str search:(NSString*)ser;
-(NSString*)replaceString:(NSString*)str targ:(NSString*)targ rep:(NSString*)rep;

// NSString Applescript Wrapper(POSIXパス)
-(NSString*)kzlastPathComponent:(NSString*)filePath;
-(NSString*)kzstringByStandardizingPath:(NSString*)filePath;
-(NSString*)kzstringByDeletingPathExtension:(NSString*)filePath;
-(NSString*)kzstringByDeletingLastPathComponent:(NSString*)filePath;
-(NSString*)kzstringByAppendingPathExtension:(NSString*)filePath fileExt:(NSString*)fileExt;
-(NSString*)kzstringByAppendingPathComponent:(NSString*)filePath appendString:(NSString*)appendString;
-(NSString*)kzpathExtension:(NSString*)filePath;
-(NSString*)kzReadTextFile:(NSString*)filePath;
-(int)kzpathCountSlash:(NSString*)filePath;
@end
