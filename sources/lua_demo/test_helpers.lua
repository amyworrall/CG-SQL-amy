--[[
Copyright (c) Meta Platforms, Inc. and affiliates.

This source code is licensed under the MIT license found in the
LICENSE file in the root directory of this source tree.
--]]

-- TESTING METHODS --

-- this is better done with string.pack but this is human
-- readable and therefore easier to debug and it works just
-- as well for the test case

function str_unpack(str)
  local data = {}
  for w in str:gmatch("([^,]+)") do table.insert(data, w) end
  for i = 1, 4
  do
    if data[i] == nil then data[i] = "0" end
    data[i] = tonumber(data[i])
  end

  return data[1], data[2], data[3], data[4]
end

function str_pack(a,b,c,d)
  return tostring(a)..","..tostring(b)..","..tostring(c)..","..tostring(d)
end

function bcreateval(context, t, ...)
  local vals = {0, 0, 0}
  local args = {...}
  local i = 0
  while i + 3 <= #args
  do
     local off = args[i+1]
     local val = args[i+2]
     vals[off+1] = val
     i = i  + 3
  end
  local r = str_pack(t, vals[1], vals[2], vals[3])
  context:result_blob(r);
end

function bupdateval(context, b, ...)
  local t, v1, v2, v3
  t, v1, v2, v3 = str_unpack(b)
  local vals = {v1, v2, v3}
  local args = {...}
  local i = 0
  while i + 3 <= #args
  do
     local off = args[i+1]
     local val = args[i+2]
     vals[off+1] = val
     i = i  + 3
  end
  local r = str_pack(t, vals[1], vals[2], vals[3])
  context:result_blob(r)
end

function bcreatekey(context, t, ...)
  local vals = {0, 0, 0}
  local args = {...}
  local i = 0
  local off = 1
  while i + 2 <= #args
  do
     local val = args[i+1]
     vals[off] = val
     i = i  + 2
     off = off + 1
  end

  local r = str_pack(t, vals[1], vals[2], vals[3])
  context:result_blob(r)
end

function bupdatekey(context, b, ...)
  local t, v1, v2, v3
  t, v1, v2, v3 = str_unpack(b)
  local vals = {v1, v2, v3}
  local args = {...}
  local i = 0
  while i + 2 <= #args
  do
     local off = args[i+1]
     local val = args[i+2]
     vals[off+1] = val
     i = i  + 2
  end
  local r = str_pack(t, vals[1], vals[2], vals[3])
  context:result_blob(r)
end

function bgetval_type(context, b)
  t = str_unpack(b)
  -- note: result(t) allows int64 results as well as int
  context:result(t)
end

function bgetval(context, b, offs)
  local t, v1, v2, v3
  t, v1, v2, v3 = str_unpack(b)
  local r = 0
  if offs == 0 then r = v1 end
  if offs == 1 then r = v2 end
  if offs == 2 then r = v3 end
  -- note: result(t) allows int64 results as well as int
  context:result(r)
end

function rscount(context, rsid)
  local rs = cql_get_aux_value_for_id(rsid)
  context:result_int(#rs)
end

function rscol(context, rsid, rownum, colnum)
  local rs = cql_get_aux_value_for_id(rsid)
  local row = rs[rownum+1]

  -- columns are not in order so we just hard code the order for the test
  if colnum == 0 then
    k = "v"
  else
    k = "vsq"
  end

  result = row[k]
  context:result(result)
end

function _cql_init_extensions(db)
  db:create_function("rscount", 1, rscount)
  db:create_function("rscol", 3, rscol)
  db:create_function("bupdateval", -1, bupdateval)
  db:create_function("bupdatekey", -1, bupdatekey)
  db:create_function("bcreateval", -1, bcreateval)
  db:create_function("bcreatekey", -1, bcreatekey)
  db:create_function("bgetval_type", 1, bgetval_type)
  db:create_function("bgetkey_type", 1, bgetval_type)
  db:create_function("bgetval", 2, bgetval)
  db:create_function("bgetkey", 2, bgetval)
  return sqlite3.OK
end

function get_outstanding_refs()
  return 0
end

function string_from_blob(str)
  return str
end

function blob_from_string(blob)
  return blob
end

function run_test_math(int1)
   return int1 * 7, int1 * 5
end

function string_create()
  return "Hello, world."
end

function set_create()
  return {}
end

function set_contains(s, k)
  return s[k] ~= nil
end

function set_add(s, k)
  if s[k] ~= nil then
    return false
  end

  s[k] = 1
  return true
end

function cql_invariant(x)
 if x == false or x == 0 then
    print("invariant failed")
    force_error_exit()
 end
end

function some_integers_fetch(a,b,c)
  return some_integers_fetch_results(a,b,c)
end

function exit(code)
  print("exit code", code)
end

function take_bool(x,y)
  if x ~= y then
    print("invariant failed")
    force_error_exit()
  end
end

function take_bool_not_null(x,y)
  if x ~= y then
    print("invariant failed")
    force_error_exit()
  end
end
