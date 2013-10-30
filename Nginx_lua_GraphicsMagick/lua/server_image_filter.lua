file_exists = function(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

get_path=function(str,sep)
    sep=sep or "/";
    return str:match("(.*"..sep..")");
end

-- 功能：获取图片url
-- example: local s = "OK path1=http://192.168.1.112:8500/dev1/0/000/000/0000000002.fid&paths=1"
function getPicUrl(s)
    local index = string.find(s, "http")
    if index == nil then
        return false;
    end
    local end_index = string.find(s, "&")
    local str = string.sub(s, index, end_index - 1)
    return str
end

-- 功能：获取mogilefs 图片url
function getPaths(host, port, cmd)
    local socket = require("socket")
    local tcp = assert(socket.tcp())

    tcp:connect(host, port)
    tcp:send(cmd)
    
    local s, status, partial = tcp:receive()
    tcp:close()

    return s
end

-- 功能：获取内容并保存到文件
-- 输入：链接,保存文件名
-- 输出：成功返回true
function saveFile(url, filename)

    local http = require("socket.http")
    local ltn12 = require("ltn12")
     
    -- timeout 1s
    http.TIMEOUT = 1

    local file = io.open(filename, "w")
    local r, c, h, w = http.request{
        url = url,
	    sink = ltn12.sink.file(file)
    }
    return c == 200
end

-- 功能:读取文件
-- 输入：文件名
-- 输出：屏幕上一行一行显示文件内容
function readfile(filename)
    local rfile=io.open(filename, "r")
    assert(rfile)
    for str in rfile:lines() do
        print(str)
    end
    rfile:close()
end

----功能：写入文件
----输入：文件名, 内容
----输出：生成的文件里面包含内容
function writefile(filename, info)
    local wfile=io.open(filename, "w") --写入文件(w覆盖)
    assert(wfile)  --打开时验证是否出错		
    wfile:write(info)  --写入传入的内容
    wfile:close()  --调用结束后记得关闭
end

local originalFile = ngx.var.image_dir .. "/" .. ngx.var.image_key .. ".jpg";
--ngx.say(ngx.var.image_dir)
--ngx.say(ngx.var.root)
--ngx.say(ngx.var.uri)
--ngx.exit(200)

-- 获取原始图片
if not file_exists(originalFile) then

    local host, port = "192.168.0.30", 8001 
    local cmd = "GET_PATHS domain=spj&key=" .. ngx.var.image_key .. "\n"

    -- get mogilefs url 
    local s = getPaths(host, port, cmd)
    if s == nil then
        ngx.exit(404)
    end

    local pic_url = getPicUrl(s)

    if not pic_url then
        ngx.exit(404)
    end

    os.execute("mkdir -p " .. ngx.var.image_dir);
    saveFile(pic_url, originalFile)

end;

local s_originalFile = ngx.var.image_dir .. "/" .. ngx.var.image_key .. "_s.jpg";
local index,originalUri,area;

-- 等比缩略大图
local s_index = string.find(ngx.var.uri, "_s");
if s_index then
    local s_area = "504x454";

    -- 不存在缩略图图片
    if not file_exists(s_originalFile) then
        --local command = "convert " .. originalFile .. " -thumbnail "  .. s_area .. " " .. s_originalFile;
        --convert -resize “100×50>!” src.jpg dst.jpg
        --local command = "convert -resize 504x454" .. originalFile .. " -thumbnail "  .. s_area .. " " .. s_originalFile;
        -- 改变原图图片比例
	local command = "/usr/local/bin/gm convert " .. originalFile .. " -thumbnail '" .. s_area .. "!' " .. s_originalFile
        os.execute(command);
    end;

    area = string.sub(ngx.var.uri, s_index);
    originalFile = s_originalFile;
end;

index = string.find(ngx.var.uri, "([0-9]+)x([0-9]+)");
if not index then
    ngx.exec(ngx.var.uri);
end

local sub_uri = string.gsub(ngx.var.uri, ngx.var.image_key, "")
index = string.find(sub_uri, "([0-9]+)x([0-9]+)");
local area = string.sub(sub_uri, index);
index = string.find(area, "([.])");
area = string.sub(area, 0, index - 1);

local image_sizes = {"70x63"};
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

--if not table.contains(image_sizes, area) then
--    ngx.exit(404);
--end;

--local command = "convert " .. originalFile .. " -thumbnail " .. area .. " " .. ngx.var.image_file;
local command = "/usr/local/bin/gm convert " .. originalFile .. " -thumbnail '" .. area .. "!' " .. ngx.var.image_file
os.execute(command);

if file_exists(ngx.var.image_file) then
    ngx.exec(ngx.var.uri);
else
    ngx.exit(404)
end
