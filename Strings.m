//
//  Strings.m
//  testAS
//
//  Created by 内山 和也 on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Strings.h"


@implementation NSApplication (ASKAStrings)
-(unsigned int)searchUnderbar:(NSString*)str
{
	for (unsigned int i=0; i<[str length]; i++) {
		if([str characterAtIndex:i] == '_'){
			return (i + 1);
		}
	}
	return 0;
}
-(NSRange)isInStr:(NSString*)str search:(NSString*)ser
{
	NSRange r = [str rangeOfString:ser];
	NSRange n = NSMakeRange(NSNotFound, 0);
	
	if (r.location == n.location) {
		return NSMakeRange(0, 0);
	} else {
		return r;
	}
}

-(NSString*)replaceString:(NSString*)str targ:(NSString*)targ rep:(NSString*)rep
{
	NSStringCompareOptions opt = NSBackwardsSearch;
	return [str stringByReplacingOccurrencesOfString:targ withString:rep options:opt range:NSMakeRange(0, [str length])];
}

// 文字列のiからjの範囲の文字列を返します
-(NSString*)kzsubstringToMidIndex:(NSString*)str aIndex:(unsigned int)i bIndex:(unsigned int)j
{
	return [str substringWithRange:NSMakeRange(i, j)];
}

// 文字列の先頭から指定した位置までの文字列を返します
-(NSString*)kzsubstringToIndex:(NSString*)str aIndex:(unsigned int)i
{
	return [str substringToIndex:i];
}

// 指定した位置から末尾までの文字列を返します
-(NSString*)kzsubstringFromIndex:(NSString*)str aIndex:(unsigned int)i
{
	return [str substringFromIndex:i];
}

// ファイルパスの最後の部分（／より後）を返します
-(NSString*)kzlastPathComponent:(NSString*)filePath
{
	return [filePath lastPathComponent];
}

// ファイルパスの最後の部分（／より後）を削除して返します
-(NSString*)kzstringByDeletingLastPathComponent:(NSString*)filePath
{
	return [filePath stringByDeletingLastPathComponent];
}

// 指定した文字をパスとみなして、パスをスタンダード化します
-(NSString*)kzstringByStandardizingPath:(NSString*)filePath
{
	return [filePath stringByStandardizingPath];
}

// 文字列から拡張子を取り除きます
-(NSString*)kzstringByDeletingPathExtension:(NSString*)filePath
{
	return [filePath stringByDeletingPathExtension];
}

// ファイルパスに拡張子を追加します
-(NSString*)kzstringByAppendingPathExtension:(NSString*)filePath fileExt:(NSString*)fileExt
{
	return [filePath stringByAppendingPathExtension:fileExt];
}

// 文字列を追加します（最後尾に／が付いていない場合は付加する）
-(NSString*)kzstringByAppendingPathComponent:(NSString*)filePath appendString:(NSString*)appendString
{
	return [filePath stringByAppendingPathComponent:appendString];
}

// ファイルパスの拡張子を返します
-(NSString*)kzpathExtension:(NSString*)filePath
{
	return [filePath pathExtension];
}

-(int)kzpathCountSlash:(NSString*)filePath
{
	NSArray *arr;
	arr = [filePath componentsSeparatedByString:@"/"];
	return [arr count] - 1;
}

-(NSString*)kzReadTextFile:(NSString*)filePath
{
	return [NSString stringWithContentsOfFile:filePath encoding:NSShiftJISStringEncoding error:nil];
}

-(NSArray*)kzSplit:(NSString*)str separator:(NSString*)sep
{
	return [str componentsSeparatedByString:sep];
}
@end
