----
   rewrite_by_lua '  
       local index = string.find(ngx.var.conUri, "([0-9]+)x([0-9]+)");  
       local originalUri = string.sub(ngx.var.conUri, 0, index-2);  
       local area = string.sub(ngx.var.conUri, index);  
       index = string.find(area, "([.])");  
       area = string.sub(area, 0, index-1);  

       local image_sizes = {"80x80", "800x600", "40x40"};  
       function table.contains(table, element)  
          for _, value in pairs(table) do  
             if value == element then  
                return true  
             end  
          end  
          return false  
       end  

       if table.contains(image_sizes, area) then  
           local command = "gm convert " .. ngx.var.image_root ..  originalUri  .. " -thumbnail " .. area .. " -background gray -gravity center -extent " .. area .. " " .. ngx.var.file;  
           os.execute(command);  
           ngx.req.set_uri(ngx.var.conUri, true);  
       else  
           ngx.exit(404);  
       end;  
    ';
----
