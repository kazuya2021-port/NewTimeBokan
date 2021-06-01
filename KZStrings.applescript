-- KZStrings.applescript
-- testAS

--  Created by 内山 和也 on 11/03/26.
--  Copyright 2011 __MyCompanyName__. All rights reserved.

on run
	return me
end run

script KZString
	on search_underbar(_str)
		return (call method "searchUnderbar:" with parameter _str)
	end search_underbar
	
	-- 文字列の先頭から指定した位置までの文字列を返します
	on left_str(_str, _pos)
		return (call method "kzsubstringToIndex:aIndex:" with parameters {_str, _pos})
	end left_str
	
	-- 指定した位置から末尾までの文字列を返します
	on right_str(_str, _pos)
		return (call method "kzsubstringFromIndex:aIndex:" with parameters {_str, _pos})
	end right_str
	
	-- 指定した位置から末尾までの文字列を返します
	on mid_str(_str, _pos1, _pos2)
		return (call method "kzsubstringToMidIndex:aIndex:bIndex:" with parameters {_str, _pos1, _pos2})
	end mid_str
	
	on searchStr(_str, _ser)
		return (call method "isInStr:search:" with parameters {_str, _ser})
	end searchStr
	
	on repstr(_str, _targ, _rep)
		return (call method "replaceString:targ:rep:" with parameters {_str, _targ, _rep})
	end repstr
	-- 引数の数字(文字列)を先頭に0を入れた数字に変換
	on padd_num(keta, num)
		set num to num as string
		set numlength to length of num
		
		if numlength is equal to keta then
			return num as string
		end if
		
		if numlength is less than keta then
			set num to num as string
			set zero to ""
			repeat (keta - numlength) times
				set zero to "0" & zero
			end repeat
			set num to zero & num
			return num
		end if
		
		if numlength is greater than keta then
			return num as string
		end if
	end padd_num
	
	on split(_str, _sep)
		return (call method "kzSplit:separator:" with parameters {_str, _sep})
	end split
	
	on make
		set a_class to me
		script Instance
			property parent : a_class
		end script
	end make
end script

script KZPathString
	property parent : KZString
	-- アクセサ
	on set_path(__path)
		set my _path to POSIX path of __path
	end set_path
	
	-- ファイルパスの最後の部分（／より後）を返します
	on last_item(_str)
		if _str is "" then
			return (call method "kzlastPathComponent:" with parameter my _path)
		else
			return (call method "kzlastPathComponent:" with parameter _str)
		end if
	end last_item
	
	-- ファイルパスの最後の部分（／より後）を削除して返します
	on trim_last_item(_str)
		if _str is "" then
			return (call method "kzstringByDeletingLastPathComponent:" with parameter my _path)
		else
			return (call method "kzstringByDeletingLastPathComponent:" with parameter _str)
		end if
	end trim_last_item
	
	-- 指定した文字をパスとみなして、パスをスタンダード化します
	on flat_path(_str)
		if _str is "" then
			return (call method "kzstringByStandardizingPath:" with parameter my _path)
		else
			return (call method "kzstringByStandardizingPath:" with parameter _str)
		end if
	end flat_path
	
	-- 文字列から拡張子を取り除きます
	on trim_ext(_str)
		if _str is "" then
			return (call method "kzstringByDeletingPathExtension:" with parameter my _path)
		else
			return (call method "kzstringByDeletingPathExtension:" with parameter _str)
		end if
	end trim_ext
	
	-- ファイルパスに拡張子を追加します
	on add_ext(_str, _ext)
		if _str is "" then
			return (call method "kzstringByAppendingPathExtension:fileExt:" with parameters {my _path, _ext})
		else
			return (call method "kzstringByAppendingPathExtension:fileExt:" with parameters {_str, _ext})
		end if
	end add_ext
	
	-- 文字列を追加します（最後尾に／が付いていない場合は付加する）
	on add_str(_str1, _str2)
		if _str1 is "" then
			return (call method "kzstringByAppendingPathComponent:appendString:" with parameters {my _path, _str2})
		else
			return (call method "kzstringByAppendingPathComponent:appendString:" with parameters {_str1, _str2})
		end if
	end add_str
	
	-- ファイルパスの拡張子を返します
	on path_ext(_str)
		if _str is "" then
			return (call method "kzpathExtension:" with parameter my _path)
		else
			return (call method "kzpathExtension:" with parameter _str)
		end if
	end path_ext
	
	-- パスのスラッシュの数を数える
	on count_slash(_str)
		if _str is "" then
			return (call method "kzpathCountSlash:" with parameter my _path)
		else
			return (call method "kzpathCountSlash:" with parameter _str)
		end if
	end count_slash
	
	-- 指定したテキストファイルを読み込む
	on read_text(_str)
		if _str is "" then
			return (call method "kzReadTextFile:" with parameter my _path)
		else
			return (call method "kzReadTextFile:" with parameter _str)
		end if
	end read_text
	on make
		set self to continue make
		script SubClassInstance
			property parent : self
			property _path : "/"
		end script
	end make
end script