-- 打印表格
function PrintTable(t, indent, done)
    --print ( string.format ('PrintTable type %s', type(keys)) )
    if type(t) ~= "table" then return end

    done = done or {}
    done[t] = true
    indent = indent or 0

    local l = {}
    for k, v in pairs(t) do
        table.insert(l, k)
    end

    table.sort(l)
    for k, v in ipairs(l) do
        -- Ignore FDesc
        if v ~= 'FDesc' then
            local value = t[v]

            if type(value) == "table" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..":")
                PrintTable (value, indent + 2, done)
            elseif type(value) == "userdata" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
            else
                if t.FDesc and t.FDesc[v] then
                    print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
                else
                    print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                end
            end
        end
    end
end



-- ***** string 功能扩展开始 ******

    -- RC4
    -- http://en.wikipedia.org/wiki/RC4
    function RC4encrypt(text,key) 

        function KSA(key)
            local key_len = string.len(key)
            local S = {}
            local key_byte = {}

            for i = 0, 255 do
                S[i] = i
            end

            for i = 1, key_len do
                key_byte[i-1] = string.byte(key, i, i)
            end

            local j = 0
            for i = 0, 255 do
                j = (j + S[i] + key_byte[i % key_len]) % 256
                S[i], S[j] = S[j], S[i]
            end
            return S
        end

        function PRGA(S, text_len)
            local i = 0
            local j = 0
            local K = {}

            for n = 1, text_len do

                i = (i + 1) % 256
                j = (j + S[i]) % 256

                S[i], S[j] = S[j], S[i]
                K[n] = S[(S[i] + S[j]) % 256]
            end
            return K
        end

        function RC4(key, text)
            local text_len = string.len(text)

            local S = KSA(key)        
            local K = PRGA(S, text_len) 
            return output(K, text)
        end

        function output(S, text)
            local len = string.len(text)
            local c = nil
            local res = {}
            for i = 1, len do
                c = string.byte(text, i, i)
                res[i] = string.char(bxor(S[i], c))
            end
            return table.concat(res)
        end


        -------------------------------
        -------------bit wise-----------
        -------------------------------

        local bit_op = {}
        function bit_op.cond_and(r_a, r_b)
            return (r_a + r_b == 2) and 1 or 0
        end

        function bit_op.cond_xor(r_a, r_b)
            return (r_a + r_b == 1) and 1 or 0
        end

        function bit_op.cond_or(r_a, r_b)
            return (r_a + r_b > 0) and 1 or 0
        end

        function bit_op.base(op_cond, a, b)
            -- bit operation
            if a < b then
                a, b = b, a
            end
            local res = 0
            local shift = 1
            while a ~= 0 do
                r_a = a % 2
                r_b = b % 2
        
                res = shift * bit_op[op_cond](r_a, r_b) + res 
                shift = shift * 2

                a = math.modf(a / 2)
                b = math.modf(b / 2)
            end
            return res
        end

        function bxor(a, b)
            return bit_op.base('cond_xor', a, b)
        end

        function band(a, b)
            return bit_op.base('cond_and', a, b)
        end

        function bor(a, b)
            return bit_op.base('cond_or', a, b)
        end

        local textLen = string.len(text)
        local schedule = KSA(key)
        local k = PRGA(schedule, textLen)
        return output(k, text)
    end


    --将字符串按格式转为16进制串
    function string.tohex(str)
        --判断输入类型
        if (type(str)~="string") then
            return nil,"string2hex invalid input type"
        end
        --拼接字符串
        local index=1
        local ret=""
        for index=1,str:len() do
            ret=ret..string.format("%02X",str:sub(index):byte())
        end
    
        return ret
    end

    --将16进制串转换为字符串
    function string.fromhex(hex)
        --判断输入类型	
        if (type(hex)~="string") then
            return nil,"hex2string invalid input type"
        end
        --滤掉分隔符
        hex=hex:gsub("[%s%p]",""):upper()
        --检查内容是否合法
        if(hex:find("[^0-9A-Fa-f]")~=nil) then
            return nil,"hex2string invalid input content"
        end
        --检查字符串长度
        if(hex:len()%2~=0) then
            return nil,"hex2string invalid input lenth"
        end
        --拼接字符串
        local index=1
        local ret=""
        for index=1,hex:len(),2 do
            ret=ret..string.char(tonumber(hex:sub(index,index+1),16))
        end
    
        return ret
    end


    -- 字符串编码
    function string.encode(text, key) 
        if text == nil or string.len(text) == 0 then return text end 
        return string.tohex(RC4encrypt(text, key))     
    end

    -- 字符串解码
    function string.decode(text, key) 
        if text == nil or string.len(text) == 0 then return text end 
        local s,e = string.fromhex(text)
        if s == nil then 
            return s,e 
        else
            return RC4encrypt(s, key)
        end   
    end

    -- 字符串分割，返回分割后子串数组
    function string.split(input, delimiter)
        input = tostring(input)
        delimiter = tostring(delimiter)
        if (delimiter=='') then return false end
        local pos,arr = 0, {}
        for st,sp in function() return string.find(input, delimiter, pos, true) end do
            table.insert(arr, string.sub(input, pos, st - 1))
            pos = sp + 1
        end
        table.insert(arr, string.sub(input, pos))
        return arr
    end

    -- 字符串输出到文件
    function string.tofile(str, path)
        local out = io.open(path,"w")
        if out then
            out:write(str)
            out:close()
        end
    end

    -- 超长字符串格式化的方式输出到文件，使用方法 table.concat(t)
    function string.tablefile(str, path)
        local out = io.open(path,"w")
        if out then
            out:write('{\n')
            local len = string.len(str)
            local step = 255
            local n = math.floor(len/step)            
            for i=0,n-1 do
                out:write('    "'..string.sub(str, i*step+1, (i+1)*step)..'",\n')
            end
            out:write('    "'..string.sub(str, n*step+1, (n+1)*step)..'"\n}')       
            out:close()
        end
    end

    -- 从kv文件中载入字符串，对应 string.savekvfile 的输出
    function string.loadkvfile(path)
        local t = LoadKeyValues(path)
		if t == nil or t["1"] == nil then return nil end	

        local ret = t["1"]
        local i = 2
        while(t[tostring(i)] ~= nil)
        do
            ret = ret..t[tostring(i)]
            i = i + 1
        end
        t = {}
        return ret		
    end
    
    --[[ 
        以字符串内容写入文件，成功返回 true，失败返回 false
        "mode 写入模式" 参数决定 io.writefile() 如何写入内容，可用的值如下：
        -   "w+" : 覆盖文件已有内容，如果文件不存在则创建新文件
        -   "a+" : 追加内容到文件尾部，如果文件不存在则创建文件    
        此外，还可以在 "写入模式" 参数最后追加字符 "b" ，表示以二进制方式写入数据，这样可以避免内容写入不完整。
        - 默认值为 "w+b"
        path 文件完全路径
        content 要写入的内容
    --]] 
    function string.writefile(content, path, mode)
        mode = mode or "w+b"
        local file = io.open(path, mode)
        if file then
            if file:write(content) == nil then return false end
            io.close(file)
            return true
        else
            return false
        end
    end

-- ***** string 功能扩展结束 ******



-- ***** table 功能扩展开始 ******

    -- table和string的互转
    function table.tostring(t)

        function ToStringEx(value)
            if type(value)=='table' then
            return table.tostring(value)
            elseif type(value)=='string' then
                return "\'"..value.."\'"
            else
            return tostring(value)
            end
        end

        if t == nil then return "" end
        local retstr= "{"

        local i = 1
        for key,value in pairs(t) do
            local signal = ","
            if i==1 then
            signal = ""
            end

            if key == i then
                retstr = retstr..signal..ToStringEx(value)
            else
                if type(key)=='number' or type(key) == 'string' then
                    retstr = retstr..signal..'['..ToStringEx(key).."]="..ToStringEx(value)
                else
                    if type(key)=='userdata' then
                        retstr = retstr..signal.."*s"..table.tostring(getmetatable(key)).."*e".."="..ToStringEx(value)
                    else
                        retstr = retstr..signal..key.."="..ToStringEx(value)
                    end
                end
            end

            i = i+1
        end

        retstr = retstr.."}"
        return retstr
    end

    -- table和string的互转
    function table.fromstring(str)
        if str == nil or type(str) ~= "string" then
            return
        end
        -- loadstring在lua5.2中已经被弃用了
        -- return loadstring("return " .. str)()   
        return load("return " .. str)()   
    end

    -- table按键名排序遍历，默认为升序
    -- t为table, method为排序方式，asc或desc，func为遍历回调
    -- lua中table是按照hash排列的，ipairs可以顺序遍历，但是不一定全部结果都能遍历出来，pairs能够全部遍历，但是遍历出来的结果是随机的，故需使用此方法
    function table.sorteach(t, func, method) 
        local tableTemp = {}
        for i in pairs(t) do
            if i ~= nil then 
                table.insert(tableTemp, i)  
            end
        end
        if method == "desc" or method == "DESC" then 
            -- 降序
            table.sort(tableTemp, function(a,b) return (a > b) end)
        else        
            -- 升序
            table.sort(tableTemp, function(a,b) return (a < b) end)  
        end
        
        -- 遍历
        for _, key in pairs(tableTemp) do  
            if type(func) == "function" then func(key, t[key]) end
        end   
        tableTemp = {}
    end

    -- 深度复制表
    function table.deepcopy(object)
        local lookup_table = {}
        local function _copy(object)
            if type(object) ~= "table" then
                return object
            elseif lookup_table[object] then
                return lookup_table[object]
            end
            local new_table = {}
            lookup_table[object] = new_table
            for index, value in pairs(object) do
                new_table[_copy(index)] = _copy(value)
            end
            return setmetatable(new_table, getmetatable(object))
        end
        return _copy(object)
    end

    -- 判断键是否在table中
    function table.haskey(t, key)
        for k,v in pairs(t) do
            if k == key then return true end
        end
        return false
    end

    -- 判断值是否在table中
    function table.hasvalue(t, value)
        for k,v in pairs(t) do
            if v == value then return true end
        end
        return false
    end

    -- 从文件中载入数据，来源对应加密数据
    function table.loadkv(path)        
        return table.fromstring(string.decode(string.loadkvfile(path), server_key))
    end

-- ***** table 功能扩展结束 ******



-- ***** MD5 功能开始 ******

    -- 使用 md5.sumhexa(message)
    md5 = {
    _VERSION     = "md5.lua 1.1.0",
    _DESCRIPTION = "MD5 computation in Lua (5.1-3, LuaJIT)",
    _URL         = "https://github.com/kikito/md5.lua",
    _LICENSE     = [[
        MIT LICENSE

        Copyright (c) 2013 Enrique García Cota + Adam Baldwin + hanzao + Equi 4 Software

        Permission is hereby granted, free of charge, to any person obtaining a
        copy of this software and associated documentation files (the
        "Software"), to deal in the Software without restriction, including
        without limitation the rights to use, copy, modify, merge, publish,
        distribute, sublicense, and/or sell copies of the Software, and to
        permit persons to whom the Software is furnished to do so, subject to
        the following conditions:

        The above copyright notice and this permission notice shall be included
        in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
        OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
        CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
        SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ]]
    }

    -- bit lib implementions

    local char, byte, format, rep, sub =
    string.char, string.byte, string.format, string.rep, string.sub
    local bit_or, bit_and, bit_not, bit_xor, bit_rshift, bit_lshift

    local ok, bit = pcall(require, 'bit')
    if ok then
    bit_or, bit_and, bit_not, bit_xor, bit_rshift, bit_lshift = bit.bor, bit.band, bit.bnot, bit.bxor, bit.rshift, bit.lshift
    else
    ok, bit = pcall(require, 'bit32')

    if ok then

        bit_not = bit.bnot

        local tobit = function(n)
        return n <= 0x7fffffff and n or -(bit_not(n) + 1)
        end

        local normalize = function(f)
        return function(a,b) return tobit(f(tobit(a), tobit(b))) end
        end

        bit_or, bit_and, bit_xor = normalize(bit.bor), normalize(bit.band), normalize(bit.bxor)
        bit_rshift, bit_lshift = normalize(bit.rshift), normalize(bit.lshift)

    else

        local function tbl2number(tbl)
        local result = 0
        local power = 1
        for i = 1, #tbl do
            result = result + tbl[i] * power
            power = power * 2
        end
        return result
        end

        local function expand(t1, t2)
        local big, small = t1, t2
        if(#big < #small) then
            big, small = small, big
        end
        -- expand small
        for i = #small + 1, #big do
            small[i] = 0
        end
        end

        local to_bits -- needs to be declared before bit_not

        bit_not = function(n)
        local tbl = to_bits(n)
        local size = math.max(#tbl, 32)
        for i = 1, size do
            if(tbl[i] == 1) then
            tbl[i] = 0
            else
            tbl[i] = 1
            end
        end
        return tbl2number(tbl)
        end

        -- defined as local above
        to_bits = function (n)
        if(n < 0) then
            -- negative
            return to_bits(bit_not(math.abs(n)) + 1)
        end
        -- to bits table
        local tbl = {}
        local cnt = 1
        local last
        while n > 0 do
            last      = n % 2
            tbl[cnt]  = last
            n         = (n-last)/2
            cnt       = cnt + 1
        end

        return tbl
        end

        bit_or = function(m, n)
        local tbl_m = to_bits(m)
        local tbl_n = to_bits(n)
        expand(tbl_m, tbl_n)

        local tbl = {}
        for i = 1, #tbl_m do
            if(tbl_m[i]== 0 and tbl_n[i] == 0) then
            tbl[i] = 0
            else
            tbl[i] = 1
            end
        end

        return tbl2number(tbl)
        end

        bit_and = function(m, n)
        local tbl_m = to_bits(m)
        local tbl_n = to_bits(n)
        expand(tbl_m, tbl_n)

        local tbl = {}
        for i = 1, #tbl_m do
            if(tbl_m[i]== 0 or tbl_n[i] == 0) then
            tbl[i] = 0
            else
            tbl[i] = 1
            end
        end

        return tbl2number(tbl)
        end

        bit_xor = function(m, n)
        local tbl_m = to_bits(m)
        local tbl_n = to_bits(n)
        expand(tbl_m, tbl_n)

        local tbl = {}
        for i = 1, #tbl_m do
            if(tbl_m[i] ~= tbl_n[i]) then
            tbl[i] = 1
            else
            tbl[i] = 0
            end
        end

        return tbl2number(tbl)
        end

        bit_rshift = function(n, bits)
        local high_bit = 0
        if(n < 0) then
            -- negative
            n = bit_not(math.abs(n)) + 1
            high_bit = 0x80000000
        end

        local floor = math.floor

        for i=1, bits do
            n = n/2
            n = bit_or(floor(n), high_bit)
        end
        return floor(n)
        end

        bit_lshift = function(n, bits)
        if(n < 0) then
            -- negative
            n = bit_not(math.abs(n)) + 1
        end

        for i=1, bits do
            n = n*2
        end
        return bit_and(n, 0xFFFFFFFF)
        end
    end
    end

    -- convert little-endian 32-bit int to a 4-char string
    local function lei2str(i)
    local f=function (s) return char( bit_and( bit_rshift(i, s), 255)) end
    return f(0)..f(8)..f(16)..f(24)
    end

    -- convert raw string to big-endian int
    local function str2bei(s)
    local v=0
    for i=1, #s do
        v = v * 256 + byte(s, i)
    end
    return v
    end

    -- convert raw string to little-endian int
    local function str2lei(s)
    local v=0
    for i = #s,1,-1 do
        v = v*256 + byte(s, i)
    end
    return v
    end

    -- cut up a string in little-endian ints of given size
    local function cut_le_str(s,...)
    local o, r = 1, {}
    local args = {...}
    for i=1, #args do
        table.insert(r, str2lei(sub(s, o, o + args[i] - 1)))
        o = o + args[i]
    end
    return r
    end

    local swap = function (w) return str2bei(lei2str(w)) end

    -- An MD5 mplementation in Lua, requires bitlib (hacked to use LuaBit from above, ugh)
    -- 10/02/2001 jcw@equi4.com

    local CONSTS = {
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
    0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
    }

    local f=function (x,y,z) return bit_or(bit_and(x,y),bit_and(-x-1,z)) end
    local g=function (x,y,z) return bit_or(bit_and(x,z),bit_and(y,-z-1)) end
    local h=function (x,y,z) return bit_xor(x,bit_xor(y,z)) end
    local i=function (x,y,z) return bit_xor(y,bit_or(x,-z-1)) end
    local z=function (ff,a,b,c,d,x,s,ac)
    a=bit_and(a+ff(b,c,d)+x+ac,0xFFFFFFFF)
    -- be *very* careful that left shift does not cause rounding!
    return bit_or(bit_lshift(bit_and(a,bit_rshift(0xFFFFFFFF,s)),s),bit_rshift(a,32-s))+b
    end

    local function transform(A,B,C,D,X)
    local a,b,c,d=A,B,C,D
    local t=CONSTS

    a=z(f,a,b,c,d,X[ 0], 7,t[ 1])
    d=z(f,d,a,b,c,X[ 1],12,t[ 2])
    c=z(f,c,d,a,b,X[ 2],17,t[ 3])
    b=z(f,b,c,d,a,X[ 3],22,t[ 4])
    a=z(f,a,b,c,d,X[ 4], 7,t[ 5])
    d=z(f,d,a,b,c,X[ 5],12,t[ 6])
    c=z(f,c,d,a,b,X[ 6],17,t[ 7])
    b=z(f,b,c,d,a,X[ 7],22,t[ 8])
    a=z(f,a,b,c,d,X[ 8], 7,t[ 9])
    d=z(f,d,a,b,c,X[ 9],12,t[10])
    c=z(f,c,d,a,b,X[10],17,t[11])
    b=z(f,b,c,d,a,X[11],22,t[12])
    a=z(f,a,b,c,d,X[12], 7,t[13])
    d=z(f,d,a,b,c,X[13],12,t[14])
    c=z(f,c,d,a,b,X[14],17,t[15])
    b=z(f,b,c,d,a,X[15],22,t[16])

    a=z(g,a,b,c,d,X[ 1], 5,t[17])
    d=z(g,d,a,b,c,X[ 6], 9,t[18])
    c=z(g,c,d,a,b,X[11],14,t[19])
    b=z(g,b,c,d,a,X[ 0],20,t[20])
    a=z(g,a,b,c,d,X[ 5], 5,t[21])
    d=z(g,d,a,b,c,X[10], 9,t[22])
    c=z(g,c,d,a,b,X[15],14,t[23])
    b=z(g,b,c,d,a,X[ 4],20,t[24])
    a=z(g,a,b,c,d,X[ 9], 5,t[25])
    d=z(g,d,a,b,c,X[14], 9,t[26])
    c=z(g,c,d,a,b,X[ 3],14,t[27])
    b=z(g,b,c,d,a,X[ 8],20,t[28])
    a=z(g,a,b,c,d,X[13], 5,t[29])
    d=z(g,d,a,b,c,X[ 2], 9,t[30])
    c=z(g,c,d,a,b,X[ 7],14,t[31])
    b=z(g,b,c,d,a,X[12],20,t[32])

    a=z(h,a,b,c,d,X[ 5], 4,t[33])
    d=z(h,d,a,b,c,X[ 8],11,t[34])
    c=z(h,c,d,a,b,X[11],16,t[35])
    b=z(h,b,c,d,a,X[14],23,t[36])
    a=z(h,a,b,c,d,X[ 1], 4,t[37])
    d=z(h,d,a,b,c,X[ 4],11,t[38])
    c=z(h,c,d,a,b,X[ 7],16,t[39])
    b=z(h,b,c,d,a,X[10],23,t[40])
    a=z(h,a,b,c,d,X[13], 4,t[41])
    d=z(h,d,a,b,c,X[ 0],11,t[42])
    c=z(h,c,d,a,b,X[ 3],16,t[43])
    b=z(h,b,c,d,a,X[ 6],23,t[44])
    a=z(h,a,b,c,d,X[ 9], 4,t[45])
    d=z(h,d,a,b,c,X[12],11,t[46])
    c=z(h,c,d,a,b,X[15],16,t[47])
    b=z(h,b,c,d,a,X[ 2],23,t[48])

    a=z(i,a,b,c,d,X[ 0], 6,t[49])
    d=z(i,d,a,b,c,X[ 7],10,t[50])
    c=z(i,c,d,a,b,X[14],15,t[51])
    b=z(i,b,c,d,a,X[ 5],21,t[52])
    a=z(i,a,b,c,d,X[12], 6,t[53])
    d=z(i,d,a,b,c,X[ 3],10,t[54])
    c=z(i,c,d,a,b,X[10],15,t[55])
    b=z(i,b,c,d,a,X[ 1],21,t[56])
    a=z(i,a,b,c,d,X[ 8], 6,t[57])
    d=z(i,d,a,b,c,X[15],10,t[58])
    c=z(i,c,d,a,b,X[ 6],15,t[59])
    b=z(i,b,c,d,a,X[13],21,t[60])
    a=z(i,a,b,c,d,X[ 4], 6,t[61])
    d=z(i,d,a,b,c,X[11],10,t[62])
    c=z(i,c,d,a,b,X[ 2],15,t[63])
    b=z(i,b,c,d,a,X[ 9],21,t[64])

    return bit_and(A+a,0xFFFFFFFF),bit_and(B+b,0xFFFFFFFF),
            bit_and(C+c,0xFFFFFFFF),bit_and(D+d,0xFFFFFFFF)
    end

    ----------------------------------------------------------------

    local function md5_update(self, s)
    self.pos = self.pos + #s
    s = self.buf .. s
    for ii = 1, #s - 63, 64 do
        local X = cut_le_str(sub(s,ii,ii+63),4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)
        assert(#X == 16)
        X[0] = table.remove(X,1) -- zero based!
        self.a,self.b,self.c,self.d = transform(self.a,self.b,self.c,self.d,X)
    end
    self.buf = sub(s, math.floor(#s/64)*64 + 1, #s)
    return self
    end

    local function md5_finish(self)
    local msgLen = self.pos
    local padLen = 56 - msgLen % 64

    if msgLen % 64 > 56 then padLen = padLen + 64 end

    if padLen == 0 then padLen = 64 end

    local s = char(128) .. rep(char(0),padLen-1) .. lei2str(bit_and(8*msgLen, 0xFFFFFFFF)) .. lei2str(math.floor(msgLen/0x20000000))
    md5_update(self, s)

    assert(self.pos % 64 == 0)
    return lei2str(self.a) .. lei2str(self.b) .. lei2str(self.c) .. lei2str(self.d)
    end

    ----------------------------------------------------------------

    function md5.new()
    return { a = CONSTS[65], b = CONSTS[66], c = CONSTS[67], d = CONSTS[68],
            pos = 0,
            buf = '',
            update = md5_update,
            finish = md5_finish }
    end

    function md5.tohex(s)
    return format("%08x%08x%08x%08x", str2bei(sub(s, 1, 4)), str2bei(sub(s, 5, 8)), str2bei(sub(s, 9, 12)), str2bei(sub(s, 13, 16)))
    end

    function md5.sum(s)
    return md5.new():update(s):finish()
    end

    function md5.sumhexa(s)
    return md5.tohex(md5.sum(s))
    end

-- ***** MD5 功能结束 ******



-- ***** JSON 功能开始 ******

    -- dota2自带此功能，不需要

    -----------------------------------------------------------------------------
    -- JSON4Lua: JSON encoding / decoding support for the Lua language.
    -- json Module.
    -- Author: Craig Mason-Jones
    -- Homepage: http://github.com/craigmj/json4lua/
    -- Version: 1.0.0
    -- This module is released under the MIT License (MIT).
    -- Please see LICENCE.txt for details.
    --
    -- USAGE:
    -- This module exposes two functions:
    --   json.encode(o)
    --     Returns the table / string / boolean / number / nil / json.null value as a JSON-encoded string.
    --   json.decode(json_string)
    --     Returns a Lua object populated with the data encoded in the JSON string json_string.
    --
    -- REQUIREMENTS:
    --   compat-5.1 if using Lua 5.0
    --
    -- CHANGELOG
    --   0.9.20 Introduction of local Lua functions for private functions (removed _ function prefix). 
    --          Fixed Lua 5.1 compatibility issues.
    --      Introduced json.null to have null values in associative arrays.
    --          json.encode() performance improvement (more than 50%) through table.concat rather than ..
    --          Introduced decode ability to ignore /**/ comments in the JSON string.
    --   0.9.10 Fix to array encoding / decoding to correctly manage nil/null values in arrays.
    -----------------------------------------------------------------------------
    
    -----------------------------------------------------------------------------
    -- Imports and dependencies
    -----------------------------------------------------------------------------
    -- local math = require('math')
    -- local string = require("string")
    -- local table = require("table")
    
    -----------------------------------------------------------------------------
    -- Module declaration
    -----------------------------------------------------------------------------
    local json = {}             -- Public namespace
    local json_private = {}     -- Private namespace
    
    -- Public constants                                                            
    json.EMPTY_ARRAY={}                                                           
    json.EMPTY_OBJECT={}
    
    -- Public functions
    
    -- Private functions
    local decode_scanArray
    local decode_scanComment
    local decode_scanConstant
    local decode_scanNumber
    local decode_scanObject
    local decode_scanString
    local decode_scanWhitespace
    local encodeString
    local isArray
    local isEncodable
    
    -----------------------------------------------------------------------------
    -- PUBLIC FUNCTIONS
    -----------------------------------------------------------------------------
    --- Encodes an arbitrary Lua object / variable.
    -- @param v The Lua object / variable to be JSON encoded.
    -- @return String containing the JSON encoding in internal Lua string format (i.e. not unicode)
    function json.encode (v)
    -- Handle nil values
    if v==nil then
        return "null"
    end
    
    local vtype = type(v)
    
    -- Handle strings
    if vtype=='string' then    
        return '"' .. json_private.encodeString(v) .. '"'     -- Need to handle encoding in string
    end
    
    -- Handle booleans
    if vtype=='number' or vtype=='boolean' then
        return tostring(v)
    end
    
    -- Handle tables
    if vtype=='table' then
        local rval = {}
        -- Consider arrays separately
        local bArray, maxCount = isArray(v)
        if bArray then
        for i = 1,maxCount do
            table.insert(rval, json.encode(v[i]))
        end
        else  -- An object, not an array
        for i,j in pairs(v) do
            if isEncodable(i) and isEncodable(j) then
            table.insert(rval, '"' .. json_private.encodeString(i) .. '":' .. json.encode(j))
            end
        end
        end
        if bArray then
        return '[' .. table.concat(rval,',') ..']'
        else
        return '{' .. table.concat(rval,',') .. '}'
        end
    end
    
    -- Handle null values
    if vtype=='function' and v==json.null then
        return 'null'
    end
    
    assert(false,'encode attempt to encode unsupported type ' .. vtype .. ':' .. tostring(v))
    end
    
    
    --- Decodes a JSON string and returns the decoded value as a Lua data structure / value.
    -- @param s The string to scan.
    -- @param [startPos] Optional starting position where the JSON string is located. Defaults to 1.
    -- @param Lua object, number The object that was scanned, as a Lua table / string / number / boolean or nil,
    -- and the position of the first character after
    -- the scanned JSON object.
    function json.decode(s, startPos)
    startPos = startPos and startPos or 1
    startPos = decode_scanWhitespace(s,startPos)
    assert(startPos<=string.len(s), 'Unterminated JSON encoded object found at position in [' .. s .. ']')
    local curChar = string.sub(s,startPos,startPos)
    -- Object
    if curChar=='{' then
        return decode_scanObject(s,startPos)
    end
    -- Array
    if curChar=='[' then
        return decode_scanArray(s,startPos)
    end
    -- Number
    if string.find("+-0123456789.e", curChar, 1, true) then
        return decode_scanNumber(s,startPos)
    end
    -- String
    if curChar==[["]] or curChar==[[']] then
        return decode_scanString(s,startPos)
    end
    if string.sub(s,startPos,startPos+1)=='/*' then
        return json.decode(s, decode_scanComment(s,startPos))
    end
    -- Otherwise, it must be a constant
    return decode_scanConstant(s,startPos)
    end
    --- The null function allows one to specify a null value in an associative array (which is otherwise
    -- discarded if you set the value with 'nil' in Lua. Simply set t = { first=json.null }
    function json.null()
    return json.null -- so json.null() will also return null ;-)
    end
    -----------------------------------------------------------------------------
    -- Internal, PRIVATE functions.
    -- Following a Python-like convention, I have prefixed all these 'PRIVATE'
    -- functions with an underscore.
    -----------------------------------------------------------------------------
    --- Scans an array from JSON into a Lua object
    -- startPos begins at the start of the array.
    -- Returns the array and the next starting position
    -- @param s The string being scanned.
    -- @param startPos The starting position for the scan.
    -- @return table, int The scanned array as a table, and the position of the next character to scan.
    function decode_scanArray(s,startPos)
    local array = {}  -- The return value
    local stringLen = string.len(s)
    assert(string.sub(s,startPos,startPos)=='[','decode_scanArray called but array does not start at position ' .. startPos .. ' in string:\n'..s )
    startPos = startPos + 1
    -- Infinite loop for array elements
    local index = 1
    repeat
        startPos = decode_scanWhitespace(s,startPos)
        assert(startPos<=stringLen,'JSON String ended unexpectedly scanning array.')
        local curChar = string.sub(s,startPos,startPos)
        if (curChar==']') then
        return array, startPos+1
        end
        if (curChar==',') then
        startPos = decode_scanWhitespace(s,startPos+1)
        end
        assert(startPos<=stringLen, 'JSON String ended unexpectedly scanning array.')
        object, startPos = json.decode(s,startPos)
        array[index] = object
        index = index + 1
    until false
    end
    --- Scans a comment and discards the comment.
    -- Returns the position of the next character following the comment.
    -- @param string s The JSON string to scan.
    -- @param int startPos The starting position of the comment
    function decode_scanComment(s, startPos)
    assert( string.sub(s,startPos,startPos+1)=='/*', "decode_scanComment called but comment does not start at position " .. startPos)
    local endPos = string.find(s,'*/',startPos+2)
    assert(endPos~=nil, "Unterminated comment in string at " .. startPos)
    return endPos+2  
    end
    --- Scans for given constants: true, false or null
    -- Returns the appropriate Lua type, and the position of the next character to read.
    -- @param s The string being scanned.
    -- @param startPos The position in the string at which to start scanning.
    -- @return object, int The object (true, false or nil) and the position at which the next character should be 
    -- scanned.
    function decode_scanConstant(s, startPos)
    local consts = { ["true"] = true, ["false"] = false, ["null"] = nil }
    local constNames = {"true","false","null"}
    for i,k in pairs(constNames) do
        if string.sub(s,startPos, startPos + string.len(k) -1 )==k then
        return consts[k], startPos + string.len(k)
        end
    end
    assert(nil, 'Failed to scan constant from string ' .. s .. ' at starting position ' .. startPos)
    end
    --- Scans a number from the JSON encoded string.
    -- (in fact, also is able to scan numeric +- eqns, which is not
    -- in the JSON spec.)
    -- Returns the number, and the position of the next character
    -- after the number.
    -- @param s The string being scanned.
    -- @param startPos The position at which to start scanning.
    -- @return number, int The extracted number and the position of the next character to scan.
    function decode_scanNumber(s,startPos)
    local endPos = startPos+1
    local stringLen = string.len(s)
    local acceptableChars = "+-0123456789.e"
    while (string.find(acceptableChars, string.sub(s,endPos,endPos), 1, true)
    and endPos<=stringLen
    ) do
        endPos = endPos + 1
    end
    local stringValue = 'return ' .. string.sub(s,startPos, endPos-1)
    local stringEval = load(stringValue)
    assert(stringEval, 'Failed to scan number [ ' .. stringValue .. '] in JSON string at position ' .. startPos .. ' : ' .. endPos)
    return stringEval(), endPos
    end
    --- Scans a JSON object into a Lua object.
    -- startPos begins at the start of the object.
    -- Returns the object and the next starting position.
    -- @param s The string being scanned.
    -- @param startPos The starting position of the scan.
    -- @return table, int The scanned object as a table and the position of the next character to scan.
    function decode_scanObject(s,startPos)
    local object = {}
    local stringLen = string.len(s)
    local key, value
    assert(string.sub(s,startPos,startPos)=='{','decode_scanObject called but object does not start at position ' .. startPos .. ' in string:\n' .. s)
    startPos = startPos + 1
    repeat
        startPos = decode_scanWhitespace(s,startPos)
        assert(startPos<=stringLen, 'JSON string ended unexpectedly while scanning object.')
        local curChar = string.sub(s,startPos,startPos)
        if (curChar=='}') then
        return object,startPos+1
        end
        if (curChar==',') then
        startPos = decode_scanWhitespace(s,startPos+1)
        end
        assert(startPos<=stringLen, 'JSON string ended unexpectedly scanning object.')
        -- Scan the key
        key, startPos = json.decode(s,startPos)
        assert(startPos<=stringLen, 'JSON string ended unexpectedly searching for value of key ' .. key)
        startPos = decode_scanWhitespace(s,startPos)
        assert(startPos<=stringLen, 'JSON string ended unexpectedly searching for value of key ' .. key)
        assert(string.sub(s,startPos,startPos)==':','JSON object key-value assignment mal-formed at ' .. startPos)
        startPos = decode_scanWhitespace(s,startPos+1)
        assert(startPos<=stringLen, 'JSON string ended unexpectedly searching for value of key ' .. key)
        value, startPos = json.decode(s,startPos)
        object[key]=value
    until false -- infinite loop while key-value pairs are found
    end
    -- START SoniEx2
    -- Initialize some things used by decode_scanString
    -- You know, for efficiency
    local escapeSequences = {
    ["\\t"] = "\t",
    ["\\f"] = "\f",
    ["\\r"] = "\r",
    ["\\n"] = "\n",
    ["\\b"] = "\b"
    }
    setmetatable(escapeSequences, {__index = function(t,k)
    -- skip "\" aka strip escape
    return string.sub(k,2)
    end})
    -- END SoniEx2
    --- Scans a JSON string from the opening inverted comma or single quote to the
    -- end of the string.
    -- Returns the string extracted as a Lua string,
    -- and the position of the next non-string character
    -- (after the closing inverted comma or single quote).
    -- @param s The string being scanned.
    -- @param startPos The starting position of the scan.
    -- @return string, int The extracted string as a Lua string, and the next character to parse.
    function decode_scanString(s,startPos)
    assert(startPos, 'decode_scanString(..) called without start position')
    local startChar = string.sub(s,startPos,startPos)
    -- START SoniEx2
    -- PS: I don't think single quotes are valid JSON
    assert(startChar == [["]] or startChar == [[']],'decode_scanString called for a non-string')
    --assert(startPos, "String decoding failed: missing closing " .. startChar .. " for string at position " .. oldStart)
    local t = {}
    local i,j = startPos,startPos
    while string.find(s, startChar, j+1) ~= j+1 do
        local oldj = j
        i,j = string.find(s, "\\.", j+1)
        local x,y = string.find(s, startChar, oldj+1)
        if not i or x < i then
        i,j = x,y-1
        end
        table.insert(t, string.sub(s, oldj+1, i-1))
        if string.sub(s, i, j) == "\\u" then
        local a = string.sub(s,j+1,j+4)
        j = j + 4
        local n = tonumber(a, 16)
        assert(n, "String decoding failed: bad Unicode escape " .. a .. " at position " .. i .. " : " .. j)
        -- math.floor(x/2^y) == lazy right shift
        -- a % 2^b == bitwise_and(a, (2^b)-1)
        -- 64 = 2^6
        -- 4096 = 2^12 (or 2^6 * 2^6)
        local x
        if n < 0x80 then
            x = string.char(n % 0x80)
        elseif n < 0x800 then
            -- [110x xxxx] [10xx xxxx]
            x = string.char(0xC0 + (math.floor(n/64) % 0x20), 0x80 + (n % 0x40))
        else
            -- [1110 xxxx] [10xx xxxx] [10xx xxxx]
            x = string.char(0xE0 + (math.floor(n/4096) % 0x10), 0x80 + (math.floor(n/64) % 0x40), 0x80 + (n % 0x40))
        end
        table.insert(t, x)
        else
        table.insert(t, escapeSequences[string.sub(s, i, j)])
        end
    end
    table.insert(t,string.sub(j, j+1))
    assert(string.find(s, startChar, j+1), "String decoding failed: missing closing " .. startChar .. " at position " .. j .. "(for string at position " .. startPos .. ")")
    return table.concat(t,""), j+2
    -- END SoniEx2
    end
    --- Scans a JSON string skipping all whitespace from the current start position.
    -- Returns the position of the first non-whitespace character, or nil if the whole end of string is reached.
    -- @param s The string being scanned
    -- @param startPos The starting position where we should begin removing whitespace.
    -- @return int The first position where non-whitespace was encountered, or string.len(s)+1 if the end of string
    -- was reached.
    function decode_scanWhitespace(s,startPos)
    local whitespace=" \n\r\t"
    local stringLen = string.len(s)
    while ( string.find(whitespace, string.sub(s,startPos,startPos), 1, true)  and startPos <= stringLen) do
        startPos = startPos + 1
    end
    return startPos
    end
    --- Encodes a string to be JSON-compatible.
    -- This just involves back-quoting inverted commas, back-quotes and newlines, I think ;-)
    -- @param s The string to return as a JSON encoded (i.e. backquoted string)
    -- @return The string appropriately escaped.
    local escapeList = {
        ['"']  = '\\"',
        ['\\'] = '\\\\',
        ['/']  = '\\/', 
        ['\b'] = '\\b',
        ['\f'] = '\\f',
        ['\n'] = '\\n',
        ['\r'] = '\\r',
        ['\t'] = '\\t'
    }
    function json_private.encodeString(s)
    local s = tostring(s)
    return s:gsub(".", function(c) return escapeList[c] end) -- SoniEx2: 5.0 compat
    end
    -- Determines whether the given Lua type is an array or a table / dictionary.
    -- We consider any table an array if it has indexes 1..n for its n items, and no
    -- other data in the table.
    -- I think this method is currently a little 'flaky', but can't think of a good way around it yet...
    -- @param t The table to evaluate as an array
    -- @return boolean, number True if the table can be represented as an array, false otherwise. If true,
    -- the second returned value is the maximum
    -- number of indexed elements in the array. 
    function isArray(t)
    -- Next we count all the elements, ensuring that any non-indexed elements are not-encodable 
    -- (with the possible exception of 'n')
    if (t == json.EMPTY_ARRAY) then return true, 0 end
    if (t == json.EMPTY_OBJECT) then return false end
    
    local maxIndex = 0
    for k,v in pairs(t) do
        if (type(k)=='number' and math.floor(k)==k and 1<=k) then -- k,v is an indexed pair
        if (not isEncodable(v)) then return false end -- All array elements must be encodable
        maxIndex = math.max(maxIndex,k)
        else
        if (k=='n') then
            if v ~= (t.n or #t) then return false end  -- False if n does not hold the number of elements
        else -- Else of (k=='n')
            if isEncodable(v) then return false end
        end  -- End of (k~='n')
        end -- End of k,v not an indexed pair
    end  -- End of loop across all pairs
    return true, maxIndex
    end
    
    --- Determines whether the given Lua object / table / variable can be JSON encoded. The only
    -- types that are JSON encodable are: string, boolean, number, nil, table and json.null.
    -- In this implementation, all other types are ignored.
    -- @param o The object to examine.
    -- @return boolean True if the object should be JSON encoded, false if it should be ignored.
    function isEncodable(o)
    local t = type(o)
    return (t=='string' or t=='boolean' or t=='number' or t=='nil' or t=='table') or
        (t=='function' and o==json.null) 
    end
 
-- ***** JSON 功能结束 ******


