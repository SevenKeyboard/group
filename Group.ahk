#Requires AutoHotkey v1.1.21+
;==============================================================
; Group — Window group management helper (add/delete/active/exist)
;
; GitHub: https://github.com/SevenKeyboard/group
; Author: SevenKeyboard Ltd. (2025)
; License: The Unlicense
;
; Documentation / References:
;   GroupAdd, GroupDelete, GroupTranspose:
;     https://www.autohotkey.com/boards/viewtopic.php?t=60272
;==============================================================
class VersionManager_Group
{
    static _ := VersionManager_Group._init()
    _init()    {
        global
        GROUP_VERSION := "1.0.0"
    }
}
class Group
{
    add(groupName, groupMembers*)    {
        if (!isObject(this.list))
            this.list:={}
        if (!isObject(this.list[groupName]))
            this.list[groupName]:=[]
        loop % groupMembers.maxIndex()    {
            groupMember:=groupMembers[A_Index], isduplicate:=false
            if (groupMember="")
                continue
            for k,v in this.list[groupName]    {
                if (groupMember = v)    {
                    isduplicate:=true
                    break	
                }
            }
            if (!isduplicate)
                this.list[groupName].push(groupMember)
        }
    }
    delete(groupName, groupMembers*)    {
        if (!isObject(this.list))
            this.list:={}
        if (!isObject(this.list[groupName]))
            this.list[groupName]:=[]
        if (!groupMembers.maxIndex())    {
            this.list[groupName]:=""
        }  else  {
            loop % groupMembers.maxIndex()    {
                groupMember:=groupMembers[A_Index], isduplicate:=false
                if (groupMember="")
                    continue
                for k,v in this.list[groupName]    {
                    if (groupMember = v)    {
                        isduplicate:=true
                        break	
                    }
                }
                if (isduplicate)
                    this.list[groupName].delete(k)
            }
            if this.list[groupName].length()    {
                temp_arr:=[]
                for k,v in this.list[groupName]
                    temp_arr.push(v)
                this.list[groupName]:=temp_arr
            }  else  {
                this.list[groupName]:=""
            }
        }
    }
    active(groupName)    {
        if (isObject(this.list[groupName]))    {
            for k,v in this.list[groupName]    {
                if (winActive(v))
                    return true
            }
        }
        return false
    }
    exist(groupName)    {
        if (isObject(this.list[groupName]))    {
            for k,v in this.list[groupName]    {
                if (winExist(v))
                    return true
            }
        }
        return false
    }
    fullList(groupName, delim:="`n")    {
        ret:=""
        if (isObject(this.list[groupName]))    {
            for k,v in this.list[groupName]
                ret.=(ret!=""?delim:"") v
        }
        return ret
    }
}