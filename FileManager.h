//
//  FileManager.h
//  testAS
//
//  Created by 内山 和也 on 11/03/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include <fts.h>

@interface NSApplication (ASKAFileManager)

// NSFileManager Applescript Wrapper
-(BOOL) kzcopyPath:(NSString *)source toPath:(NSString *)destination;
-(BOOL) kzmovePath:(NSString *)source toPath:(NSString *)destination;
-(BOOL) kzcreateSymbolicLinkAtPath:(NSString *)destination pathContent:(NSString *)source;
-(BOOL) kzcontentsEqualAtPath:(NSString *)source andPath:(NSString *)destination;
-(BOOL) kzremoveFileAtPath:(NSString *)fullPath;
-(BOOL) kzfileExistsAtPath:(NSString *)fullPath;

-(BOOL) kzIsDrectory:(NSString *)path traverseLink:(BOOL)flag;
-(BOOL) kzIsFile:(NSString *)path traverseLink:(BOOL)flag;
-(BOOL) kzIsAlias:(NSString *)path traverseLink:(BOOL)flag;
-(NSNumber*) kzGetFileSize:(NSString *)path traverseLink:(BOOL)flag;
-(NSString*) kzGetFileDate:(NSString *)path traverseLink:(BOOL)flag;
-(NSString*) kzGetFileModifiDate:(NSString *)path traverseLink:(BOOL)flag;
-(NSString*) kzGetFileType:(NSString *)path traverseLink:(BOOL)flag;
-(NSArray*) kzGetFileList:(NSString *)path;
-(NSArray*) kzGetFileListFull:(NSString *)path;
@end
