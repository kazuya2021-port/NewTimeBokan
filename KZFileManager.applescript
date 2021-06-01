-- KZFileManager.applescript
-- testAS

--  Created by 内山 和也 on 11/03/26.
--  Copyright 2011 __MyCompanyName__. All rights reserved.

on run
	return me
end run

script KZFileManager
	-- 指定したパス(source)のファイルを指定した宛先(destination)にコピーします、コピーできれば1を返します
	on copy_to(_source, _dest)
		return (call method "kzcopyPath:toPath:" with parameters {_source, _dest})
	end copy_to
	
	-- 指定したパス(source)のファイルを指定した宛先(destination)に移動します。移動できれば1を返します
	on move_to(_source, _dest)
		return (call method "kzmovePath:toPath:" with parameters {_source, _dest})
	end move_to
	
	-- 指定したパスのファイルのリンクを指定した宛先に作ります。作成できれば1を返します
	on alias_to(_source, _dest)
		return (call method "kzcreateSymbolicLinkAtPath:pathContent:" with parameters {_dest, _source})
	end alias_to
	
	-- ファイルやフォルダの中身を比較して結果を返します。同じならば1を返します
	on is_equal_to(_source, _dest)
		return (call method "kzcontentsEqualAtPath:andPath:" with parameters {_source, _dest})
	end is_equal_to
	
	-- 指定したパス(_source)のファイルを削除します。削除できれば1を返します
	on remove_to(_source)
		return (call method "kzremoveFileAtPath:" with parameter _source)
	end remove_to
	
	-- ファイルが実際に存在しているか調べます。存在すれば1を返します
	on is_exists(_source)
		return (call method "kzfileExistsAtPath:" with parameter _source)
	end is_exists
	
	-- 指定したパスがディレクトリか調べます。ディレクトリなら1を返します
	on is_directory(_source, _islink)
		return (call method "kzIsDrectory:traverseLink:" with parameters {_source, _islink})
	end is_directory
	
	-- 指定したパスがファイルか調べます。ファイルなら1を返します
	on is_file(_source, _islink)
		return (call method "kzIsFile:traverseLink:" with parameters {_source, _islink})
	end is_file
	
	-- 指定したパスがエイリアスか調べます。エイリアスなら1を返します
	on is_alias(_source, _islink)
		return (call method "kzIsAlias:traverseLink:" with parameters {_source, _islink})
	end is_alias
	
	-- 指定したパスのファイルサイズを返します
	on file_size(_source, _islink)
		return (call method "kzGetFileSize:traverseLink:" with parameters {_source, _islink})
	end file_size
	
	-- 指定したパスのファイル修正日を返します
	on file_mod_date(_source, _islink)
		return (call method "kzGetFileModifiDate:traverseLink:" with parameters {_source, _islink})
	end file_mod_date
	
	-- 指定したパスのファイル作成日を返します
	on file_date(_source, _islink)
		return (call method "kzGetFileDate:traverseLink:" with parameters {_source, _islink})
	end file_date
	
	-- 指定したパスのファイルの種類を返します
	on file_kind(_source, _islink)
		return (call method "kzGetFileType:traverseLink:" with parameters {_source, _islink})
	end file_kind
	
	-- ファイルリスト
	on file_list(_source)
		return (call method "kzGetFileList:" with parameter _source)
	end file_list
	
	-- ファイルリスト(FullPath)
	on file_list_full(_source)
		return (call method "kzGetFileListFull:" with parameter _source)
	end file_list_full
	on make
		set a_class to me
		script Instance
			property parent : a_class
		end script
	end make
end script