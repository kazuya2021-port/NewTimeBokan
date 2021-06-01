//
//  FileManager.m
//  testAS
//
//  Created by 内山 和也 on 11/03/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileManager.h"


@implementation NSApplication (ASKAFileManager)

// 指定したパス(source)のファイルを指定した宛先(destination)にコピーします、コピーできればYESを返します
-(BOOL) kzcopyPath:(NSString *)source toPath:(NSString *)destination
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	return [myFile copyItemAtPath:source toPath:destination error:nil];
}

// 指定したパス(source)のファイルを指定した宛先(destination)に移動します。移動できればYESを返します
-(BOOL) kzmovePath:(NSString *)source toPath:(NSString *)destination
{
	return [[NSFileManager defaultManager] moveItemAtPath:source toPath:destination error:nil];
}

// 指定したパスのファイルのリンクを指定した宛先に作ります。作成できればYESを返します
-(BOOL) kzcreateSymbolicLinkAtPath:(NSString *)destination pathContent:(NSString *)source
{
	return [[NSFileManager defaultManager] linkItemAtPath:source toPath:destination error:nil];
}

// ファイルやフォルダの中身を比較して結果を返します
-(BOOL) kzcontentsEqualAtPath:(NSString *)source andPath:(NSString *)destination
{
	return [[NSFileManager defaultManager] contentsEqualAtPath:source andPath:destination];
}

// 指定したパス(path)のファイルを削除します。削除できればYESを返します
-(BOOL) kzremoveFileAtPath:(NSString *)fullPath
{
	return [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
}

// ファイルが実際に存在しているか調べます
-(BOOL) kzfileExistsAtPath:(NSString *)fullPath
{
	return [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
}

-(BOOL) kzIsDrectory:(NSString *)path traverseLink:(BOOL)flag
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSDictionary* attr = [myFile attributesOfItemAtPath:path error:nil];
	NSString* a = [attr valueForKey:NSFileType];
	if([a isEqualToString:@"NSFileTypeDirectory"])
		return YES;
	else
		return FALSE;
}

-(BOOL) kzIsFile:(NSString *)path traverseLink:(BOOL)flag
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSDictionary* attr = [myFile attributesOfItemAtPath:path error:nil];
	NSString* a = [attr valueForKey:NSFileType];
	if([a isEqualToString:@"NSFileTypeRegular"])
		return YES;
	else
		return FALSE;
}

-(BOOL) kzIsAlias:(NSString *)path traverseLink:(BOOL)flag
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSDictionary* attr = [myFile attributesOfItemAtPath:path error:nil];
	NSString* a = [attr valueForKey:NSFileType];
	if([a isEqualToString:@"NSFileTypeSymbolicLink"])
		return YES;
	else
		return FALSE;
}

-(NSNumber*) kzGetFileSize:(NSString *)path traverseLink:(BOOL)flag
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSDictionary* attr = [myFile attributesOfItemAtPath:path error:nil];
	return [attr valueForKey:NSFileSize];
}

-(NSString*) kzGetFileDate:(NSString *)path traverseLink:(BOOL)flag
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSDictionary* attr = [myFile attributesOfItemAtPath:path error:nil];
	NSDate* dt = [attr objectForKey:NSFileCreationDate];
	NSDateFormatter* form = [[NSDateFormatter alloc]init];
	[form setDateFormat:@"yyyy年MM月dd日(EEE) H:mm:ss"];
	NSString* ret = [form stringFromDate:dt];
	[form release];
	return ret;
}

-(NSString*) kzGetFileModifiDate:(NSString *)path traverseLink:(BOOL)flag
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSDictionary* attr = [myFile attributesOfItemAtPath:path error:nil];
	NSDate* dt = [attr objectForKey:NSFileModificationDate];
	NSDateFormatter* form = [[NSDateFormatter alloc]init];
	[form setDateFormat:@"yyyy年MM月dd日(EEE) H:mm:ss"];
	NSString* ret = [form stringFromDate:dt];
	[form release];
	return ret;
}

-(NSString*) kzGetFileType:(NSString *)path traverseLink:(BOOL)flag
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSDictionary* attr = [myFile attributesOfItemAtPath:path error:nil];
	NSMutableString* res = [[NSMutableString alloc]initWithCapacity:1];
	
	OSType creater = [[attr valueForKey:NSFileHFSCreatorCode] unsignedLongValue];
	OSType type = [[attr valueForKey:NSFileHFSTypeCode] unsignedLongValue];
	
	if([[path pathExtension]isEqualToString:@""]){
		// ディレクトリ
		OSType typeFol = 'fold';
		OSType createrFol = 'MACS';
		LSCopyKindStringForTypeInfo(typeFol, createrFol,(CFStringRef)[path pathExtension], (CFStringRef*)&res);
	}else{
		if(type){
			LSCopyKindStringForTypeInfo(type, creater,(CFStringRef)[path pathExtension], (CFStringRef*)&res);
		}else{
			LSCopyKindStringForTypeInfo(kLSUnknownType, kLSUnknownCreator,(CFStringRef)[path pathExtension], (CFStringRef*)&res);
		}		
	}
	return [res autorelease];
}

-(NSArray*) kzGetFileList:(NSString *)path
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSArray *fileList = [myFile subpathsOfDirectoryAtPath:path error:nil];
	//NSLog(@"fileList:%@",fileList);
	NSMutableArray *ret = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	for(int i=0; i<[fileList count]; i++){
		NSString *file = [fileList objectAtIndex:i];
		if([file characterAtIndex:0] == '.') continue;
		[ret addObject:file];
	}
	return ret;
}

-(NSArray*) kzGetFileListFull:(NSString *)path
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSArray *fileList = [myFile subpathsOfDirectoryAtPath:path error:nil];
	NSMutableArray *ret = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	for(int i=0; i<[fileList count]; i++){
		NSString *file = [fileList objectAtIndex:i];
		if([file characterAtIndex:0] == '.') continue;
		
		[ret addObject:[path stringByAppendingPathComponent:file]];
	}
	return ret;
}
@end
