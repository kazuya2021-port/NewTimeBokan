-- ??????.applescript
-- ??????

--  Created by ????? on 12/01/10.
--  Copyright 2012 __MyCompanyName__. All rights reserved.

(*======================================*)
(* Load Scripts *)
(*======================================*)
on import(a_name)
	set pwd to system attribute "PWD"
	if pwd is "" or pwd is ((path to startup disk)'s POSIX path) then
		-- プロジェクトのフルパス
		set pwd to "/Users/uchiyamakazuya/Desktop/タイムぼかん/"
	else
		set pwd to pwd & "/"
	end if
	return run script POSIX file (pwd & a_name & ".applescript")
end import

(*======================================*)
(* Local Variable *)
(*======================================*)
property CommonDialog : import("CommonDialog")
property KZStrings : import("KZStrings")
property KZFileManager : import("KZFileManager")
property Ddlg : KZAlertDLG of CommonDialog

property g_cur_file : ""
property g_cur_path : ""
property g_jpeg_high : 0
property g_jpeg_width : 0
property ruler_chged : false

(*======================================*)
(* Custum *)
(*======================================*)
on getIndexMenu(titleSyu)
	
	if (titleSyu is "怪コミック用設定") or (titleSyu is "繰り返しぼかし(2400)") then
		return 1
	else if (titleSyu is "怪コミック(TIFF-本文)設定") or (titleSyu is "繰り返しぼかし(1200)") then
		return 2
	else if (titleSyu is "怪コミック(TIFF-付き物)設定") or (titleSyu is "TIFFぼかし") then
		return 3
	else if (titleSyu is "富士見文庫用設定") or (titleSyu is "リサイズ") then
		return 4
	else if (titleSyu is "富士見コミック用設定") or (titleSyu is "サムネイル作成") then
		return 5
	else if (titleSyu is "コミックサムネイル設定") or (titleSyu is "グレーTo２値") then
		return 6
	else if (titleSyu is "PDFラスタライズ設定") or (titleSyu is "B6変形用処理") then
		return 7
	else if (titleSyu is "電撃口絵(4面)") or (titleSyu is "電撃4面") then
		return 8
	else if (titleSyu is "電撃口絵(巻折)") or (titleSyu is "電撃巻折") then
		return 9
	else if (titleSyu is "電撃カバー") or (titleSyu is "電撃カバー") then
		return 10
	else if (titleSyu is "角川ルビー用設定") or (titleSyu is "角度変更2032") then
		return 11
	else
		return 1
	end if
end getIndexMenu
on choose menu item theObject
	set cur_type to title of theObject
	
	set w to tab view item "graphic" of tab view "tab" of window "MainWin"
	set mf to matrix "mat" of w
	set mc to matrix "ma" of w
	
	set jcell to cell "jpg" of mf
	set tcell to cell "tif" of mf
	set rcell to cell "rgb" of mc
	set gcell to cell "gray" of mc
	
	if name of theObject is "patterns" then
		
		if cur_type is "コミックサムネイル設定" then
			set contents of text field "rasterdpi" of w to 300
			set contents of text field "todpi" of w to 72
			set contents of button "anti" of w to true
			set current menu item of popup button "process" of w to menu item (my getIndexMenu("サムネイル作成")) of popup button "process" of w
			set enabled of text field "jpgwidth" of w to false
			set enabled of text field "jpgheight" of w to false
			set enabled of button "sharp_f" of w to false
			set enabled of button "sharp_m" of w to false
			set enabled of button "sharp_p" of w to false
			set enabled of button "prof" of w to false
			set enabled of mf to false
			set enabled of mc to false
			
		else if cur_type is "PDFラスタライズ設定" then
			set contents of text field "rasterdpi" of w to 2400
			set contents of button "anti" of w to false
			set current menu item of popup button "process" of w to menu item (my getIndexMenu("グレーTo２値")) of popup button "process" of w
			set enabled of text field "todpi" of w to false
			set enabled of text field "jpgwidth" of w to false
			set enabled of text field "jpgheight" of w to false
			set enabled of button "sharp_f" of w to false
			set enabled of button "sharp_m" of w to false
			set enabled of button "sharp_p" of w to false
			set enabled of button "prof" of w to false
			set enabled of mf to false
			set enabled of mc to true
			set state of rcell to off state
			set state of gcell to on state
			set current cell of mc to gcell
			
		else
			set enabled of text field "todpi" of w to true
			set enabled of text field "jpgwidth" of w to true
			set enabled of text field "jpgheight" of w to true
			set enabled of button "sharp_f" of w to true
			set enabled of button "sharp_m" of w to true
			set enabled of button "sharp_p" of w to true
			set enabled of button "prof" of w to true
			set enabled of mf to true
			set enabled of mc to true
			
			if cur_type is "怪コミック用設定" then
				set contents of text field "rasterdpi" of w to 1200
				set contents of text field "jpgwidth" of w to 1125
				set contents of text field "jpgheight" of w to 1600
				set contents of text field "todpi" of w to 300
				set contents of button "sharp_p" of w to true
				set contents of button "sharp_m" of w to false
				set contents of button "sharp_f" of w to false
				set contents of button "anti" of w to true
				set contents of button "prof" of w to true
				set state of tcell to off state
				set state of jcell to on state
				set current cell of mf to jcell
				set state of rcell to on state
				set state of gcell to off state
				set current cell of mc to rcell
				set current menu item of popup button "process" of w to menu item (my getIndexMenu("繰り返しぼかし(1200)")) of popup button "process" of w
				
			else if cur_type is "怪コミック(TIFF-本文)設定" then
				set contents of text field "rasterdpi" of w to 1200
				set contents of text field "jpgwidth" of w to 2250
				set contents of text field "jpgheight" of w to 3200
				set contents of text field "todpi" of w to 600
				set contents of button "sharp_p" of w to true
				set contents of button "sharp_m" of w to false
				set contents of button "sharp_f" of w to false
				set contents of button "anti" of w to true
				set contents of button "prof" of w to true
				set state of tcell to on state
				set state of jcell to off state
				set current cell of mf to tcell
				set state of rcell to on state
				set state of gcell to off state
				set current cell of mc to rcell
				set current menu item of popup button "process" of w to menu item (my getIndexMenu("TIFFぼかし")) of popup button "process" of w
				
			else if cur_type is "怪コミック(TIFF-付き物)設定" then
				set contents of text field "rasterdpi" of w to 300
				set contents of text field "jpgwidth" of w to 2250
				set contents of text field "jpgheight" of w to 3200
				set contents of text field "todpi" of w to 300
				set contents of button "sharp_p" of w to false
				set contents of button "sharp_m" of w to false
				set contents of button "sharp_f" of w to false
				set contents of button "anti" of w to true
				set contents of button "prof" of w to true
				set state of tcell to on state
				set state of jcell to off state
				set current cell of mf to tcell
				set state of rcell to on state
				set state of gcell to off state
				set current cell of mc to rcell
				set current menu item of popup button "process" of w to menu item (my getIndexMenu("リサイズ")) of popup button "process" of w
				
			else if cur_type is "富士見文庫用設定" then
				set contents of text field "rasterdpi" of w to 1200
				set contents of text field "jpgwidth" of w to 1135
				set contents of text field "jpgheight" of w to 1600
				set contents of text field "todpi" of w to 72
				set contents of button "sharp_p" of w to false
				set contents of button "sharp_m" of w to true
				set contents of button "sharp_f" of w to false
				set contents of button "anti" of w to true
				set contents of button "prof" of w to false
				set state of tcell to off state
				set state of jcell to on state
				set current cell of mf to jcell
				set state of rcell to on state
				set state of gcell to off state
				set current cell of mc to gcell
				set current menu item of popup button "process" of w to menu item (my getIndexMenu("繰り返しぼかし(1200)")) of popup button "process" of w
				
			else if cur_type is "富士見コミック用設定" then
				set contents of text field "rasterdpi" of w to 1200
				set contents of text field "jpgwidth" of w to 722
				set contents of text field "jpgheight" of w to 1024
				set contents of text field "todpi" of w to 72
				set contents of button "sharp_p" of w to true
				set contents of button "sharp_m" of w to false
				set contents of button "sharp_f" of w to false
				set contents of button "anti" of w to true
				set contents of button "prof" of w to false
				set state of tcell to off state
				set state of jcell to on state
				set current cell of mf to jcell
				set state of rcell to on state
				set state of gcell to off state
				set current cell of mc to rcell
				set current menu item of popup button "process" of w to menu item (my getIndexMenu("B6変形用処理")) of popup button "process" of w
			else if cur_type is "電撃口絵(4面)" then
				set contents of text field "rasterdpi" of w to 350
				set contents of text field "jpgwidth" of w to 2250
				set contents of text field "jpgheight" of w to 3200
				set contents of text field "todpi" of w to 72
				set contents of button "sharp_p" of w to false
				set contents of button "sharp_m" of w to true
				set contents of button "sharp_f" of w to false
				set contents of button "anti" of w to true
				set contents of button "prof" of w to false
				set state of tcell to on state
				set state of jcell to off state
				set current cell of mf to tcell
				set state of rcell to on state
				set state of gcell to off state
				set current cell of mc to rcell
				set current menu item of popup button "process" of w to menu item (my getIndexMenu("電撃4面")) of popup button "process" of w
			else if cur_type is "電撃口絵(巻折)" then
				set contents of text field "rasterdpi" of w to 350
				set contents of text field "jpgwidth" of w to 2250
				set contents of text field "jpgheight" of w to 3200
				set contents of text field "todpi" of w to 72
				set contents of button "sharp_p" of w to false
				set contents of button "sharp_m" of w to true
				set contents of button "sharp_f" of w to false
				set contents of button "anti" of w to true
				set contents of button "prof" of w to false
				set state of tcell to on state
				set state of jcell to off state
				set current cell of mf to tcell
				set state of rcell to on state
				set state of gcell to off state
				set current cell of mc to rcell
				set current menu item of popup button "process" of w to menu item (my getIndexMenu("電撃巻折")) of popup button "process" of w
			else if cur_type is "電撃カバー" then
				set contents of text field "rasterdpi" of w to 350
				set contents of text field "jpgwidth" of w to 2250
				set contents of text field "jpgheight" of w to 3200
				set contents of text field "todpi" of w to 72
				set contents of button "sharp_p" of w to false
				set contents of button "sharp_m" of w to true
				set contents of button "sharp_f" of w to false
				set contents of button "anti" of w to true
				set contents of button "prof" of w to false
				set state of tcell to on state
				set state of jcell to off state
				set current cell of mf to tcell
				set state of rcell to on state
				set state of gcell to off state
				set current cell of mc to rcell
				set current menu item of popup button "process" of w to menu item (my getIndexMenu("電撃カバー")) of popup button "process" of w
			else if cur_type is "角川ルビー用設定" then
				set contents of text field "rasterdpi" of w to 2032
				set contents of text field "jpgwidth" of w to 846
				set contents of text field "jpgheight" of w to 1200
				set contents of text field "todpi" of w to 72
				set contents of button "sharp_p" of w to false
				set contents of button "sharp_m" of w to false
				set contents of button "sharp_f" of w to false
				set contents of button "anti" of w to true
				set contents of button "prof" of w to false
				set state of tcell to off state
				set state of jcell to on state
				set current cell of mf to jcell
				set state of rcell to on state
				set state of gcell to off state
				set current cell of mc to gcell
				set current menu item of popup button "process" of w to menu item (my getIndexMenu("角度変更2032")) of popup button "process" of w
			end if
		end if
	else if name of theObject is "process" then
		set pro_type to title of theObject
		if pro_type is "繰り返しぼかし(1200)" then
			set contents of text field "rasterdpi" of w to 1200
			
		else if pro_type is "繰り返しぼかし(2400)" then
			set contents of text field "rasterdpi" of w to 2400
			
		end if
	end if
	
end choose menu item
on clicked theObject
	set w to tab view item "graphic" of tab view "tab" of window "MainWin"
	if name of theObject is "go" then
		set isSharp_P to contents of button "sharp_p" of w
		set isSharp_M to contents of button "sharp_m" of w
		set isSharp_F to contents of button "sharp_f" of w
		set isAnti to contents of button "anti" of w
		set isEmbed to contents of button "prof" of w
		set colMode to name of current cell of matrix "ma" of w
		set savType to name of current cell of matrix "mat" of w
		set tv to table view "files" of scroll view "files" of w
		set datasource to data source of tv
		set filenameList to contents of data cell 1 of every data row of datasource
		set filepathList to contents of data cell 2 of every data row of datasource
		set g_jpeg_high to (contents of text field "jpgheight" of w) as integer
		set g_jpeg_width to (contents of text field "jpgwidth" of w) as integer
		set rasterdpi to (contents of text field "rasterdpi" of w) as integer
		set todpi to (contents of text field "todpi" of w) as integer
		set patterns to title of current menu item of popup button "patterns" of w
		set process to title of current menu item of popup button "process" of w
		--set curnum to (contents of text field "curnum" of w) as integer
		
		set kzPath to make KZPathString of KZStrings
		
		set innameList to {}
		
		set workdir to (POSIX path of (path to me) as Unicode text)
		set workdir to workdir & "Contents/Resources/"
		-- 書類フォルダ検索
		tell application "Finder"
			set AsavePath to (path to documents folder)
			set strSavePath to (POSIX path of AsavePath) as string
			set newFolderName to kzPath's last_item(item 1 of filepathList) & "_処理済み"
			
			if not (exists folder newFolderName of AsavePath) then
				make folder at AsavePath with properties {name:newFolderName}
			end if
			set savePath to strSavePath & newFolderName
			
		end tell
		
		-- PhotoShopタイムアウト
		with timeout of (1 * 60 * 60) seconds
			set a to count of filenameList
			
			if ruler_chged is false then
				my ChangeRulerToPXL()
				set ruler_chged to true
			end if
			
			repeat with i from 1 to a
				set g_cur_path to (item i of filepathList)
				set g_cur_file to (item i of filenameList)
				tell application "Adobe Photoshop CS5.1"
					set display dialogs to never
					
					if (process is not "サムネイル作成") and (process is not "グレーTo２値") and (process is not "電撃4面") and (process is not "電撃巻折") and (process is not "電撃カバー") then
						my open_image(kzPath, rasterdpi, isAnti, colMode)
						
						set currentDocument to (a reference to document 1)
						tell currentDocument
							-- アクティブ
							activate
							
							-- レイヤー統合
							flatten
							
							if process is "繰り返しぼかし(1200)" then
								if rasterdpi is not 1200 then
									display dialog "1200dpiでラスタライズしてください"
									exit repeat
								end if
								set ret to my kaiComic(rasterdpi, todpi)
								if ret is false then
									display dialog "kaiComic:その他のエラー"
									exit repeat
								end if
								
							else if process is "繰り返しぼかし(2400)" then
								if rasterdpi is not 2400 then
									display dialog "2400dpiでラスタライズしてください"
									exit repeat
								end if
								set ret to my fijimiComic(rasterdpi)
								if ret is false then
									display dialog "fijimiComic:その他のエラー"
									exit repeat
								end if
								
							else if process is "リサイズ" then
								set ret to my resize(todpi)
								if ret is false then
									display dialog "resize:その他のエラー"
									exit repeat
								end if
							else if process is "TIFFぼかし" then
								set ret to my tiffBokasi(todpi)
								if ret is false then
									display dialog "tiffBokasi:その他のエラー"
									exit repeat
								end if
								
							else if process is "B6変形用処理" then
								set ret to my b6henkei(rasterdpi, todpi)
								if ret is false then
									display dialog "b6henkei:その他のエラー"
									exit repeat
								end if
								
							else if process is "角度変更2032" then
								set ret to my rotate_ami(rasterdpi, todpi, workdir)
								if ret is false then
									display dialog "rotate_ami:その他のエラー"
									exit repeat
								end if
							end if
							
							activate
							
							-- シャープネス
							if isSharp_P then
								if process is "B6変形用処理" then
									filter current layer using unsharp mask with options {class:unsharp mask, amount:110, radius:1.0, threshold:10}
								else
									filter current layer using unsharp mask with options {class:unsharp mask, amount:100, radius:1.0, threshold:40}
								end if
							else if isSharp_M then
								filter current layer using sharpen
							else if isSharp_F then
								filter current layer using sharpen more
							end if
							
							set saveFile to ""
							if savType is "jpg" then
								set saveFile to (savePath & "/" & kzPath's trim_ext(g_cur_file as string) & ".jpg") as string
								set myOptions to {class:JPEG save options, embed color profile:isEmbed, format options:standard, quality:9}
								save in file saveFile as JPEG with options myOptions without copying
								
							else if savType is "tif" then
								set saveFile to (savePath & "/" & kzPath's trim_ext(g_cur_file as string) & ".tif") as string
								set myOptions to {class:TIFF save options, byte order:Mac OS, embed color profile:isEmbed, image compression:LZW, save layers:true, save spot colors:true}
								save in file saveFile as TIFF with options myOptions without copying
							end if
							
							close without saving
						end tell
					else if process is "グレーTo２値" then
						
						my open_image(kzPath, rasterdpi, isAnti, colMode)
						
						set currentDocument to (a reference to document 1)
						tell currentDocument
							-- アクティブ
							activate
							
							-- レイヤー統合
							flatten
							
							my rasterise(rasterdpi)
							
							activate
							
							-- シャープネス
							(*
							if isSharp_P then
									filter current layer using unsharp mask with options {class:unsharp mask, amount:100, radius:1.0, threshold:40}
							else if isSharp_M then
								filter current layer using sharpen
							else if isSharp_F then
								filter current layer using sharpen more
							end if
							*)
							
							set saveFile to ""
							
							set saveFile to (savePath & "/" & kzPath's trim_ext(g_cur_file as string) & ".tif") as string
							
							set myOptions to {class:TIFF save options, byte order:Mac OS, embed color profile:isEmbed, image compression:LZW, save layers:true, save spot colors:true}
							save in file saveFile as TIFF with options myOptions without copying
							
							
							close without saving
						end tell
						
					else if process is "電撃4面" then
						
						repeat with j from 1 to 4
							my ChangeRulerToMM()
							my open_image(kzPath, rasterdpi, isAnti, colMode)
							set flg to 0
							set currentDocument to (a reference to document 1)
							tell currentDocument
								-- アクティブ
								activate
								
								-- レイヤー統合
								flatten
								
								-- 処理
								if j is 1 then
									
									set ret to my test(rasterdpi)
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 1
								else if j is 2 then
									set ret to my test2(rasterdpi)
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 2
								else if j is 3 then
									set ret to my test3(rasterdpi)
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 3
								else if j is 4 then
									set ret to my test4(rasterdpi)
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 4
								end if
								activate
								
								
								-- シャープネス
								if isSharp_P then
									filter current layer using unsharp mask with options {class:unsharp mask, amount:100, radius:1.0, threshold:40}
								else if isSharp_M then
									filter current layer using sharpen
								else if isSharp_F then
									filter current layer using sharpen more
								end if
								
								my ChangeRulerToPXL()
								-- 解像度変更 (1200 - 72)
								resize image height 3200 width 2250 resolution 72 resample method bicubic smoother
								
								set saveFile to ""
								
								if savType is "jpg" then -- つかわない
									set saveFile to ((savePath & "/" & i as string) & "_" & kzPath's trim_ext(g_cur_file as string) & ".jpg") as string
									
									set myOptions to {class:JPEG save options, embed color profile:isEmbed, format options:standard, quality:9}
									save in file saveFile as JPEG with options myOptions without copying
									
								else if savType is "tif" then
									set save_name_num to ""
									set fname to kzPath's trim_ext(g_cur_file as string)
									set fn_long to (length of fname) as number
									set fn_last to text fn_long thru fn_long of fname
									if flg is 1 then
										if fn_last is "O" then
											set save_name_num to "P005"
										else
											set save_name_num to "P007"
										end if
									else if flg is 2 then
										if fn_last is "O" then
											set save_name_num to "P004"
										else
											set save_name_num to "P002"
										end if
									else if flg is 3 then
										if fn_last is "O" then
											set save_name_num to "P008"
										else
											set save_name_num to "P006"
										end if
									else if flg is 4 then
										if fn_last is "O" then
											set save_name_num to "P001"
										else
											set save_name_num to "P003"
										end if
									end if
									set saveFile to (savePath & "/" & save_name_num & ".tif") as string
									set myOptions to {class:TIFF save options, byte order:Mac OS, embed color profile:isEmbed, image compression:LZW, save layers:true, save spot colors:true}
									save in file saveFile as TIFF with options myOptions without copying
								end if
								
								close without saving
							end tell
						end repeat
						
					else if process is "電撃巻折" then
						set save_name_num to ""
						set fname to kzPath's trim_ext(g_cur_file as string)
						set fn_long to (length of fname) as number
						set fn_last to text fn_long thru fn_long of fname
						
						repeat with j from 1 to 2
							my open_image(kzPath, rasterdpi, isAnti, colMode)
							set flg to 0
							set currentDocument to (a reference to document 1)
							tell currentDocument
								-- アクティブ
								activate
								
								-- レイヤー統合
								flatten
								
								-- 処理
								my ChangeRulerToMM()
								if (j is 1) and (fn_last is "O") then
									set ret to my test_maki()
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 1
								else if (j is 2) and (fn_last is "O") then
									set ret to my test2_maki()
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 2
								else if (j is 1) then
									set ret to my test3_maki()
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 3
								else if (j is 2) then
									set ret to my test4_maki()
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 4
								end if
								my ChangeRulerToPXL()
								activate
								
								
								-- シャープネス
								if isSharp_P then
									filter current layer using unsharp mask with options {class:unsharp mask, amount:100, radius:1.0, threshold:40}
								else if isSharp_M then
									filter current layer using sharpen
								else if isSharp_F then
									filter current layer using sharpen more
								end if
								
								-- 解像度変更 (1200 - 72)
								if (flg is 1) or (flg is 4) then
									resize image height 3200 width 2250 resolution 72 resample method bicubic smoother
								else
									resize image height 3600 width 6816 resolution 72 resample method bicubic smoother
								end if
								
								set saveFile to ""
								
								if savType is "jpg" then -- つかわない
									set saveFile to ((savePath & "/" & i as string) & "_" & kzPath's trim_ext(g_cur_file as string) & ".jpg") as string
									
									set myOptions to {class:JPEG save options, embed color profile:isEmbed, format options:standard, quality:9}
									save in file saveFile as JPEG with options myOptions without copying
									
								else if savType is "tif" then
									if flg is 1 then
										set save_name_num to "P001"
										
									else if flg is 2 then
										set save_name_num to "見開き_表"
										
									else if flg is 3 then
										set save_name_num to "見開き_裏"
										
									else if flg is 4 then
										set save_name_num to "P002"
										
									end if
									set saveFile to (savePath & "/" & save_name_num & ".tif") as string
									set myOptions to {class:TIFF save options, byte order:Mac OS, embed color profile:isEmbed, image compression:LZW, save layers:true, save spot colors:true}
									save in file saveFile as TIFF with options myOptions without copying
								end if
								
								close without saving
							end tell
						end repeat
					else if process is "電撃カバー" then
						repeat with j from 1 to 2
							my open_image(kzPath, rasterdpi, isAnti, colMode)
							set flg to 0
							set currentDocument to (a reference to document 1)
							tell currentDocument
								-- アクティブ
								activate
								
								-- レイヤー統合
								flatten
								
								-- 処理
								my ChangeRulerToMM()
								if (j is 1) then
									set ret to my test_cover()
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 1
								else if (j is 2) then
									set ret to my test_cover2()
									if ret is false then
										display dialog "sasatoku:その他のエラー"
										exit repeat
									end if
									set flg to 2
								end if
								
								my ChangeRulerToPXL()
								activate
								
								-- シャープネス
								if isSharp_P then
									filter current layer using unsharp mask with options {class:unsharp mask, amount:100, radius:1.0, threshold:40}
								else if isSharp_M then
									filter current layer using sharpen
								else if isSharp_F then
									filter current layer using sharpen more
								end if
								
								-- 解像度変更 (1200 - 72)
								resize image height 3200 width 2250 resolution 72 resample method bicubic smoother
								
								set saveFile to ""
								set save_name_num to ""
								if savType is "jpg" then -- つかわない
									set saveFile to ((savePath & "/" & i as string) & "_" & kzPath's trim_ext(g_cur_file as string) & ".jpg") as string
									
									set myOptions to {class:JPEG save options, embed color profile:isEmbed, format options:standard, quality:9}
									save in file saveFile as JPEG with options myOptions without copying
									
								else if savType is "tif" then
									if flg is 1 then
										set save_name_num to "カバー"
										
									else if flg is 2 then
										set save_name_num to "著者近影"
										
									end if
									set saveFile to (savePath & "/" & save_name_num & ".tif") as string
									set myOptions to {class:TIFF save options, byte order:Mac OS, embed color profile:isEmbed, image compression:LZW, save layers:true, save spot colors:true}
									save in file saveFile as TIFF with options myOptions without copying
								end if
								
								close without saving
							end tell
						end repeat
					else if process is "サムネイル作成" then
						set targetFile to {"thumbnail.png", "thumbnail_L.png", "thumbnail_M.png", "thumbnail_S.png"}
						set targetSize to {{96, 128}, {48, 64}, {24, 32}, {12, 16}}
						set g_cur_path to (item 1 of filepathList)
						set g_cur_file to (item 1 of filenameList)
						
						set duplicateDoc to missing value
						repeat with i from 1 to (count of targetFile)
							tell application "Adobe Photoshop CS5.1"
								open alias ((g_cur_path & "/" & g_cur_file) as POSIX file) with options ¬
									{class:PDF open options, mode:RGB, resolution:rasterdpi, use antialias:isAnti, page:1, crop page:media box}
								set currentDocument to (a reference to current document)
								
								tell currentDocument
									-- アクティブ
									activate
									-- レイヤー統合
									flatten
									
									-- リサイズ
									resize image width (item 1 of item i of targetSize) height (item 2 of item i of targetSize) resolution todpi resample method bicubic
									
									adjust current layer using automatic contrast
									
									-- インデックスカラー変換
									change mode to indexed color with options ¬
										{class:indexed mode options, palette:local adaptive, dither:none, forced colors:black and white, transparency:false}
									
								end tell
								
								set saveFile to savePath & "/" & (item i of targetFile)
								export currentDocument in file saveFile as save for web with options ¬
									{web format:PNG, transparency:false, color reduction:adaptive, with profile:true, quality:90}
								close currentDocument without saving
							end tell
						end repeat
						
					end if
				end tell
			end repeat
			set tv to table view "files" of scroll view "files" of w
			delete every data row of data source of tv
		end timeout
		
	else if name of theObject is "savesetting" then
		my savePlist("RasterDpi", contents of text field "rasterdpi" of w)
		my savePlist("JpegWidth", contents of text field "jpgwidth" of w)
		my savePlist("JpegHigh", contents of text field "jpgheight" of w)
		my savePlist("Patterns", title of current menu item of popup button "patterns" of w)
		my savePlist("Process", title of current menu item of popup button "process" of w)
		my savePlist("Sharp", contents of button "sharp" of w)
		my savePlist("AntiAlias", contents of button "anti" of w)
		my savePlist("ToDpi", contents of text field "todpi" of w)
		my savePlist("Mode", name of current cell of matrix "ma" of w)
		my savePlist("FileType", name of current cell of matrix "mat" of w)
		my savePlist("EmbedProf", contents of button "prof" of w)
		
	else if name of theObject is "clearlist" then
		set tv to table view "files" of scroll view "files" of w
		delete every data row of data source of tv
	end if
end clicked

-- 角度変更2032
on rotate_ami(rasterdpi, todpi, workdir)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			adjust current layer using levels adjustment with options {class:levels adjustment, input range start:13, input range end:255, input range gamma:1.0, output range start:0, output range end:255}
			-- 「ぶれ」
			set bure to workdir & "bure.jsx"
			do javascript (file bure)
			filter current layer using motion blur with options {class:motion blur, angle:45, radius:10}
			
			set raster_dpi to rasterdpi - 100
			resize image resolution raster_dpi resample method bicubic smoother
			filter current layer using motion blur with options {class:motion blur, angle:60, radius:10}
			
			set raster_dpi to rasterdpi - 100
			resize image resolution raster_dpi resample method bicubic smoother
			filter current layer using motion blur with options {class:motion blur, angle:0, radius:10}
			
			set raster_dpi to raster_dpi - 100
			resize image resolution raster_dpi resample method bicubic smoother
			filter current layer using motion blur with options {class:motion blur, angle:15, radius:10}
			
			set raster_dpi to raster_dpi - 100
			resize image resolution raster_dpi resample method bicubic smoother
			filter current layer using motion blur with options {class:motion blur, angle:56, radius:10}
			
			set raster_dpi to rasterdpi / 2
			resize image resolution raster_dpi resample method bicubic sharper
			filter current layer using sharpen more
			
			set raster_dpi to raster_dpi / 2
			resize image resolution raster_dpi resample method bicubic smoother
			filter current layer using gaussian blur with options {class:gaussian blur, radius:1}
			
			resize image height g_jpeg_high width g_jpeg_width resolution todpi resample method bicubic smoother
			filter current layer using unsharp mask with options {class:unsharp mask, amount:100, radius:1.0, threshold:0}
		end tell
	end tell
	return true
end rotate_ami

-- 繰り返しぼかし1200
on kaiComic(raster_dpi, to_dpi)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			-- ぼかし
			filter current layer using gaussian blur with options {class:gaussian blur, radius:2}
			
			-- 解像度変更 (1200 - 600)
			set raster_dpi to raster_dpi / 2
			resize image resolution raster_dpi resample method bicubic sharper
			
			-- ぼかし
			filter current layer using gaussian blur with options {class:gaussian blur, radius:1}
			
			-- 解像度変更 (600 - 72)
			resize image height g_jpeg_high width g_jpeg_width resolution to_dpi resample method bicubic smoother
			
			-- 明るさ調整
			--adjust current layer using brightness and contrast with options {class:brightness and contrast, brightness level:3, contrast level:3}
			
			-- シャープネス
			--if isShp then
			--	filter current layer using unsharp mask with options {class:unsharp mask, amount:100, radius:1.0, threshold:40}
			--end if
		end tell
	end tell
	return true
end kaiComic

-- 繰り返しぼかし2400
on fijimiComic(raster_dpi)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			-- ぼかし
			filter current layer using gaussian blur with options {class:gaussian blur, radius:1}
			
			-- 解像度変更 (2400 - 1200)
			set raster_dpi to raster_dpi / 2
			resize image resolution raster_dpi resample method bicubic smoother
			
			-- ぼかし
			filter current layer using gaussian blur with options {class:gaussian blur, radius:1}
			
			-- 解像度変更 (1200 - 600)
			set raster_dpi to raster_dpi / 2
			resize image resolution raster_dpi resample method bicubic smoother
			
			-- ぼかし
			filter current layer using gaussian blur with options {class:gaussian blur, radius:1}
			
			-- 解像度変更 (600 - 300)
			set raster_dpi to raster_dpi / 2
			resize image resolution 300 resample method bicubic smoother
			
			-- リサイズ
			resize image height g_jpeg_high width g_jpeg_width resample method bicubic smoother
			
			-- 明るさ調整
			--adjust current layer using brightness and contrast with options {class:brightness and contrast, brightness level:3, contrast level:3}
			
			-- シャープネス
			--if isShp then
			--	filter current layer using unsharp mask with options {class:unsharp mask, amount:100, radius:1.0, threshold:40}
			--end if
		end tell
	end tell
	return true
end fijimiComic

-- TIFFぼかし
on tiffBokasi(to_dpi)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			-- ぼかし
			filter current layer using gaussian blur with options {class:gaussian blur, radius:2}
			
			-- 解像度変更 (1200 - 600)
			resize image height g_jpeg_high width g_jpeg_width resolution to_dpi resample method bicubic smoother
			
		end tell
	end tell
	return true
end tiffBokasi

-- リサイズ
on resize(todpi)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			-- リサイズ
			resize image height g_jpeg_high width g_jpeg_width resolution todpi resample method bicubic sharper
		end tell
	end tell
	return true
end resize

-- グレーTo2値
on rasterise(rasterdpi)
	tell application "Adobe Photoshop CS5.1"
		
		set currentDocument to (a reference to document 1)
		tell currentDocument
			adjust current layer using levels adjustment with options {class:levels adjustment, input range start:13, input range end:255, input range gamma:1.0, output range start:0, output range end:255}
			--	display dialog "グレーTo２値"
			change mode to bitmap with options {class:Bitmap mode options, conversion method:halftone screen conversion, angle:45, frequency:133, resolution:rasterdpi, screen shape:halftone round}
		end tell
		
	end tell
end rasterise

-- B6変形
on b6henkei(raster_dpi, todpi)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			-- ノイズを加える
			filter current layer using add noise with options {class:add noise, amount:5, distribution:Gaussian, monochromatic:false}
			-- ぼかし
			filter current layer using gaussian blur with options {class:gaussian blur, radius:2}
			
			-- 解像度変更 (1200 - 600)
			set raster_dpi to raster_dpi / 2
			resize image resolution raster_dpi resample method bicubic sharper
			
			-- ぼかし
			filter current layer using gaussian blur with options {class:gaussian blur, radius:1}
			
			-- 解像度変更 (600 - 300)
			set raster_dpi to raster_dpi / 2
			resize image resolution raster_dpi resample method bicubic sharper
			
			-- ぼかし
			filter current layer using gaussian blur with options {class:gaussian blur, radius:1}
			
			-- 解像度変更 (300 - 72)
			resize image height g_jpeg_high width g_jpeg_width resolution todpi resample method bicubic smoother
			
			-- シャープネス
			--if isShp then
			--	filter current layer using unsharp mask with options {class:unsharp mask, amount:110, radius:1.0, threshold:10}
			--end if
		end tell
	end tell
	return true
	
end b6henkei

-- 電撃左上 (表はP005,裏はP007)
on test(raster_dpi)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			resize canvas width 105 height 150 anchor position top left
		end tell
	end tell
	return true
	
end test

-- test2
on test2(raster_dpi)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			
			resize canvas width 105 height 150 anchor position top right
			
			-- 解像度変更 (300 - 72)
			--resize image height 1024 width 720 resolution 72 resample method bicubic smoother
			
			
		end tell
	end tell
	return true
	
end test2

-- test3
on test3(raster_dpi)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			resize canvas width 105 height 150 anchor position bottom left
			rotate canvas angle 180
			
			-- 解像度変更 (300 - 72)
			--resize image height 1024 width 720 resolution 72 resample method bicubic smoother
			
			
		end tell
	end tell
	return true
	
end test3

-- test4
on test4(raster_dpi)
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			resize canvas width 105 height 150 anchor position bottom right
			rotate canvas angle 180
			
			-- 解像度変更 (300 - 72)
			--resize image height 1024 width 720 resolution 72 resample method bicubic smoother
			
			
		end tell
	end tell
	return true
	
end test4

on test_maki()
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			resize canvas width 105 height 150 anchor position top left
		end tell
	end tell
	return true
	
end test_maki
on test2_maki()
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			resize canvas width 284 height 150 anchor position top right
		end tell
	end tell
	return true
	
end test2_maki
on test3_maki()
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			resize canvas width 284 height 150 anchor position top left
		end tell
	end tell
	return true
	
end test3_maki
on test4_maki()
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			resize canvas width 105 height 150 anchor position top right
		end tell
	end tell
	return true
	
end test4_maki

-- カバ−
on test_cover()
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			resize canvas width 180 height 150 anchor position top left
			resize canvas width 105 height 150 anchor position top right
		end tell
	end tell
	return true
	
end test_cover

-- 著者近影
on test_cover2()
	tell application "Adobe Photoshop CS5.1"
		set currentDocument to (a reference to document 1)
		tell currentDocument
			resize canvas width 75 height 150 anchor position top right
			resize canvas width 105 height 150 anchor position top left
			flatten
		end tell
	end tell
	return true
	
end test_cover2
(*======================================*)
(* Functions *)
(*======================================*)

--初期設定ファイルに保存する
--savePlist(項目名,内容)
on savePlist(thisKey, thisContent)
	try
		--初期設定ファイルに保存
		set contents of default entry thisKey of user defaults to thisContent
	on error
		make new default entry at end of default entries of user defaults with properties {name:thisKey, contents:""}
		set contents of default entry thisKey of user defaults to thisContent
	end try
	
end savePlist

--初期設定ファイルから読み込む
--loadPlist(項目名)
on loadPlist(thisKey)
	try
		--初期設定ファイルから読み込み
		set thisCont to contents of default entry thisKey of user defaults
	on error
		set thisCont to ""
	end try
	
	return thisCont
end loadPlist

on checkDirectory(workPath, fol_name)
	set kzFm to make KZFileManager of KZFileManager
	set kzPath to make KZPathString of KZStrings
	
	set targetfolder to workPath & "/" & fol_name
	
	if (kzFm's is_exists(targetfolder)) is 0 then
		tell application "Finder" to make folder at (workPath as POSIX file) with properties {name:fol_name}
	end if
end checkDirectory



-- PhotoShopの定規単位を設定
-- パラメータ：cm units/inch units/mm units/percent units/pixel units/point units
on setRulerPref(myRuler)
	tell application "Adobe Photoshop CS5.1"
		set ruler units of settings to myRuler
	end tell
end setRulerPref

-- PhotoShopの定規単位をpixelに変更
on ChangeRulerToPXL()
	tell application "Adobe Photoshop CS5.1" to setRulerPref(pixel units) of me
	return true
end ChangeRulerToPXL

-- PhotoShopの定規単位をmmに変更
on ChangeRulerToMM()
	tell application "Adobe Photoshop CS5.1" to setRulerPref(mm units) of me
	return true
end ChangeRulerToMM

on setDataToTable(arrfile, theObject)
	set kzPath to make KZPathString of KZStrings
	set theDataSource to data source of theObject
	set cmpData to {}
	set sortDatas to {}
	
	repeat with theItem in arrfile
		set fileName to kzPath's last_item(theItem)
		set tFileName to kzPath's trim_ext(fileName)
		set theFilePath to trim_last_item(theItem) of kzPath
		set end of sortDatas to theFilePath & "," & fileName & (ASCII character 10)
	end repeat
	
	set workdir to (POSIX path of (path to me) as Unicode text)
	set workdir to workdir & "Contents/Resources/"
	
	set old_delims to AppleScript's text item delimiters
	set sortBase to sortDatas as string
	
	--ソート結果を一旦ファイルに書き出す
	set command to "echo " & quoted form of sortBase & " | sort -d > " & quoted form of workdir & "tmp.csv"
	do shell script command
	
	-- ソート済みデータ格納
	set tmpPath to workdir & "tmp.csv"
	set x to do shell script "cat " & quoted form of tmpPath & " | cut -f1 -d, "
	set sortedPath to (paragraphs of x)
	
	set x to do shell script "cat " & quoted form of tmpPath & " | cut -f2 -d, "
	set sortedFileNames to (paragraphs of x)
	
	do shell script "rm -f " & tmpPath
	set AppleScript's text item delimiters to old_delims
	
	repeat with i from 2 to (count of sortedFileNames)
		set rowData to {}
		set end of rowData to item i of sortedFileNames
		set end of rowData to item i of sortedPath
		set end of cmpData to rowData
	end repeat
	append the theDataSource with cmpData
end setDataToTable



on open_image(kzPath, raster_dpi, use_anti, Cmode)
	set aexpitem to kzPath's path_ext(g_cur_file)
	
	tell application "Adobe Photoshop CS5.1"
		set aFile to g_cur_path & "/" & g_cur_file as text
		
		if ((aexpitem is "tif") or (aexpitem is "tiff")) then
			open alias aFile as TIFF
		else if (aexpitem is "psd") then
			open alias aFile showing dialogs never
		else if (aexpitem is "pdf") and (Cmode is "rgb") then
			
			open alias aFile with options {class:PDF open options, mode:RGB, resolution:raster_dpi, use antialias:use_anti, page:1, constrain proportions:true, crop page:media box}
		else if (aexpitem is "pdf") and (Cmode is "gray") then
			open alias aFile with options {class:PDF open options, mode:grayscale, resolution:raster_dpi, use antialias:use_anti, page:1, constrain proportions:true, crop page:media box}
		else if (aexpitem is "eps") and (Cmode is "rgb") then
			open alias aFile with options {class:EPS open options, mode:RGB, resolution:raster_dpi, use antialias:use_anti, constrain proportions:true}
		else if (aexpitem is "eps") and (Cmode is "gray") then
			open alias aFile with options {class:EPS open options, mode:grayscale, resolution:raster_dpi, use antialias:use_anti, constrain proportions:true}
		else
			display dialog "ファイルタイプが違います。"
		end if
	end tell
	
end open_image


(*======================================*)
(* init UI *)
(*======================================*)
on awake from nib theObject
	set w to tab view item "graphic" of tab view "tab" of window "MainWin"
	
	if (name of theObject is "files") then
		-- 処理対象データソース作成
		set theDataSource to make new data source at end of data sources with properties {name:"files"}
		-- カラム作成
		make new data column at end of data columns of theDataSource with properties {name:"fileName"}
		make new data column at end of data columns of theDataSource with properties {name:"path"}
		
		-- テーブルにデータソースを設定
		set data source of theObject to theDataSource
		
		-- ドラッグタイプ設定
		tell theObject to register drag types {"file names"}
		
	else if name of theObject is "rasterdpi" then
		if (my loadPlist("RasterDpi") is not "") then
			set contents of text field "rasterdpi" of w to my loadPlist("RasterDpi")
		else
			set contents of text field "rasterdpi" of w to 1200
		end if
		
	else if name of theObject is "jpgwidth" then
		if (my loadPlist("JpegWidth") is not "") then
			set contents of text field "jpgwidth" of w to my loadPlist("JpegWidth")
		else
			set contents of text field "jpgwidth" of w to 720
		end if
		
	else if name of theObject is "jpgheight" then
		--log "JpegHigh:" & my loadPlist("JpegHigh")
		if (my loadPlist("JpegHigh") is not "") then
			set contents of text field "jpgheight" of w to my loadPlist("JpegHigh")
		else
			set contents of text field "jpgheight" of w to 1024
		end if
		
	else if name of theObject is "patterns" then
		--log "Patterns:" & my loadPlist("Patterns")
		set current menu item of theObject to menu item (my getIndexMenu(my loadPlist("Patterns"))) of theObject
		
	else if name of theObject is "process" then
		--log "Process:" & my loadPlist("Process")
		set current menu item of theObject to menu item (my getIndexMenu(my loadPlist("Process"))) of theObject
		
	else if name of theObject is "ma" then
		--log "Mode:" & my loadPlist("Mode")
		set m to my loadPlist("Mode")
		set gcell to cell "gray" of matrix "ma" of w
		set rcell to cell "rgb" of matrix "ma" of w
		if (m is not "") then
			if m is "rgb" then
				set state of gcell to off state
				set state of rcell to on state
				set current cell of theObject to rcell
			else if m is "gray" then
				set state of gcell to on state
				set state of rcell to off state
				set current cell of theObject to gcell
			end if
		else
			set state of gcell to off state
			set state of rcell to on state
			set current cell of theObject to rcell
		end if
	else if name of theObject is "mat" then
		--log "FileType:" & my loadPlist("FileType")
		set m to my loadPlist("FileType")
		set jcell to cell "jpg" of matrix "mat" of w
		set tcell to cell "tif" of matrix "mat" of w
		if (m is not "") then
			if m is "jpg" then
				set state of tcell to off state
				set state of jcell to on state
				set current cell of theObject to jcell
			else if m is "tif" then
				set state of tcell to on state
				set state of jcell to off state
				set current cell of theObject to tcell
			end if
		else
			set state of cell "tif" of matrix "mat" of w to off state
			set state of cell "jpg" of matrix "mat" of w to on state
			set current cell of theObject to jcell
		end if
		
	else if name of theObject is "sharp" then
		if (my loadPlist("Sharp") is not "") then
			set contents of button "sharp" of w to my loadPlist("Sharp")
		else
			set contents of button "sharp" of w to true
		end if
	else if name of theObject is "anti" then
		if (my loadPlist("AntiAlias") is not "") then
			set contents of button "anti" of w to my loadPlist("AntiAlias")
		else
			set contents of button "anti" of w to true
		end if
		
	else if name of theObject is "prof" then
		if (my loadPlist("EmbedProf") is not "") then
			set contents of button "prof" of w to my loadPlist("EmbedProf")
		else
			set contents of button "prof" of w to true
		end if
		
	else if name of theObject is "todpi" then
		if (my loadPlist("ToDpi") is not "") then
			set contents of text field "todpi" of w to my loadPlist("ToDpi")
		else
			set contents of text field "todpi" of w to 72
		end if
		
	end if
	
end awake from nib

(*======================================*)
(* Drag&Drop Handler *)
(*======================================*)

on accept table drop theObject drag info dragInfo drop operation dropOperation row theRow
	set dataTypes to types of pasteboard of dragInfo
	set theDataSource to data source of theObject
	
	set update views of theDataSource to false
	
	-- Set up the target data row (where we'll be placing the dropped items)
	if theRow is greater than (count of data rows of theDataSource) then
		set targetDataRow to missing value
	else
		set targetDataRow to data row theRow of theDataSource
	end if
	
	if "file names" is in dataTypes then
		-- ファイルのドロップ時処理
		set theFiles to {}
		
		set preferred type of pasteboard of dragInfo to "file names"
		
		set theFiles to contents of pasteboard of dragInfo
		log theFiles
		set kzFm to make KZFileManager of KZFileManager
		set kzPath to make KZPathString of KZStrings
		set isFolder to is_directory((item 1 of theFiles), 1) of kzFm
		
		
		if (isFolder = 1) then
			set arrfile to file_list((item 1 of theFiles), 1) of kzFm
			
			if name of theObject is "cmp2" then
				if a_Folder is "" then
					set a_Folder to item 1 of theFiles
				end if
			end if
			my setDataToTable(arrfile, theObject)
			set update views of theDataSource to true
			return true
			
		end if
		if (count of theFiles) > 0 then
			
			if name of theObject is "cmp2" then
				if a_Folder is "" then
					set a_Folder to kzPath's trim_last_item((item 1 of theFiles))
				end if
			end if
			
			-- ドロップしたファイルをテーブルに設定
			my setDataToTable(theFiles, theObject)
			set update views of theDataSource to true
			return true
		end if
	end if
	set update views of theDataSource to true
	return false
end accept table drop

on prepare table drag theObject drag rows dragRows pasteboard thePasteboard
	set preferred type of thePasteboard to "rows"
	-- ペーストボードにドラッグする行番号を設定
	set content of thePasteboard to dragRows
	return true
end prepare table drag

on prepare table drop theObject drag info dragInfo drop operation dropOperation row theRow
	-- By default we will set the drag operation to not be a drag operation
	set dragOperation to no drag operation
	
	-- Get the list of data types on the pasteboard
	set dataTypes to types of pasteboard of dragInfo
	
	if "rows" is in dataTypes then
		if dropOperation is 1 then
			-- 行のDrag&Drop時にドロップ実行
			if option key down of event 1 then
				set dragOperation to copy drag operation
			else
				set dragOperation to move drag operation
			end if
		end if
		
	else if "file names" is in dataTypes then
		if dropOperation is 1 then
			-- ファイルのDrag&Drop時にドロップ実行
			set dragOperation to copy drag operation
		end if
	end if
	return dragOperation
end prepare table drop


on will close theObject
	quit
end will close
