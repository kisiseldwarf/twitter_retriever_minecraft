local args = { ... }
if #args < 2 then
	print("need the bearer token as first argument and the # to search for in the second.")
	return 1
end


local authentication = args[1]
local monitor = peripheral.wrap("right")
local a = {}
a[ "Authorization" ] = authentication
os.loadAPI("json")

b = http.get("https://api.twitter.com/1.1/search/tweets.json?q=%23"..args[2].."&count=5",a)

local date = "Mon Jul 15 18:51:54 +0000 2019"

-- not used here, but could be useful one day
function str_in_bytes(str)
  local res = {}
  local buf = str
  for i=1,string.len(str),1 do
    res[i] = string.byte(buf)
    buf = string.sub(buf,2,string.len(buf))
  end
  return res
end

function decode_date(date)
  local res = ""
  if string.find(date,"Mon") then
    res = res.."Lundi"
  elseif string.find(date,"Tue") then
    res = res.."Mardi"
  elseif string.find(date,"Wed") then
    res = res.."Mercredi"
  elseif string.find(date,"Thu") then
    res = res.."Jeudi"
  elseif string.find(date,"Fri") then
    res = res.."Vendredi"
  elseif string.find(date,"Sat") then
    res = res.."Semedi"
  elseif string.find(date,"Sun") then
    res = res.."Dimanche"
  end

  res = res.." "..string.sub(date,string.find(date,"%d%d"))

  if string.find(date,"Jan") then
    res = res.." ".."Janvier"
  elseif string.find(date,"Feb") then
    res = res.." ".."Février"
  elseif string.find(date,"March") then
    res = res.." ".."Mars"
  elseif string.find(date,"April") then
    res = res.." ".."Avril"
  elseif string.find(date,"May") then
    res = res.." ".."Mai"
  elseif string.find(date,"Jun") then
    res = res.." ".."Juin"
  elseif string.find(date,"Jul") then
    res = res.." ".."Juillet"
  elseif string.find(date,"Aug") then
    res = res.." ".."Août"
  end

  local heure = string.sub(date,string.find(date,"%d%d:%d%d:%d%d"))

  res = res.." à "..string.sub(date,string.find(date,"%d%d:%d%d:%d%d"))
  res = res.." (GMT+00)"
  return res
end

print(decode_date(date))

my_func = function (w)
  local res = string.sub(w,2,string.len(w))
  return utf8.char("0x"..res)
end

function detect_unicode(str)
  local res = string.gsub(str,"(\\....)",my_func)
  return res
end

monitor.setTextScale(0.5)
monitor.clear()
monitor.setCursorPos(1,1)
a = json.decode(b.readAll())
term.redirect(monitor)
term.setTextColor(colors.blue)
print("La trend #"..args[2].."\n")
term.setTextColor(colors.white)
for i=1,#a.statuses,1 do
  term.setTextColor(colors.red)
  print("Le "..decode_date(a.statuses[i].created_at).." :")
  local text = a.statuses[i].text
  text = detect_unicode(text)
  term.setTextColor(colors.white)
  print(text.."\n")
end
