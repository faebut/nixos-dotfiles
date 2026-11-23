local max_line_chars = 90
local max_word_share = 0.6
local code_weight = 1.15
local no_break_before = {
  ["-"] = true, ["/"] = true, ["."] = true, ["_"] = true, [":"] = true,
  ["?"] = true, ["&"] = true, ["="] = true, [","] = true, [")"] = true,
}

local function chars(text)
  local list = {}
  for _, code in utf8.codes(text) do
    list[#list + 1] = utf8.char(code)
  end
  return list
end

local function breakable(text, limit, make)
  local parts = chars(text)
  if #parts <= math.floor(limit) then
    return nil
  end
  local inlines = pandoc.Inlines({})
  for index, char in ipairs(parts) do
    inlines:insert(make(char))
    local next_char = parts[index + 1]
    if next_char and not no_break_before[next_char] then
      inlines:insert(pandoc.RawInline("latex", "\\allowbreak{}"))
    end
  end
  return inlines
end

local function break_tokens_longer_than(limit)
  return {
    Str = function(el)
      return breakable(el.text, limit, pandoc.Str)
    end,
    Code = function(el)
      return breakable(el.text, limit / code_weight, function(char)
        return pandoc.Code(char, el.attr)
      end)
    end,
  }
end

local function each_row(tbl, fn)
  for _, row in ipairs(tbl.head.rows) do
    fn(row)
  end
  for _, body in ipairs(tbl.bodies) do
    for _, row in ipairs(body.head) do
      fn(row)
    end
    for _, row in ipairs(body.body) do
      fn(row)
    end
  end
  for _, row in ipairs(tbl.foot.rows) do
    fn(row)
  end
end

local function text_length(text)
  return utf8.len(text) or #text
end

local function measure(blocks)
  local total, longest, word = 0, 0, 0
  local function end_word()
    longest = math.max(longest, word)
    word = 0
  end
  local function add_text(text, weight)
    local first = true
    for piece in (text .. " "):gmatch("([^%s]*)%s") do
      if not first then
        total = total + 1
        end_word()
      end
      local length = text_length(piece) * weight
      word = word + length
      total = total + length
      first = false
    end
  end
  blocks:walk({
    Str = function(el)
      add_text(el.text, 1)
    end,
    Code = function(el)
      add_text(el.text, code_weight)
    end,
    Space = function()
      total = total + 1
      end_word()
    end,
    SoftBreak = function()
      total = total + 1
      end_word()
    end,
    LineBreak = end_word,
  })
  end_word()
  return longest, total
end

local function column_metrics(tbl)
  local count = #tbl.colspecs
  local min_width, max_width = {}, {}
  for index = 1, count do
    min_width[index] = 1
    max_width[index] = 1
  end
  each_row(tbl, function(row)
    local column = 1
    for _, cell in ipairs(row.cells) do
      local span = cell.col_span or 1
      if span == 1 and column <= count then
        local longest, total = measure(cell.contents)
        min_width[column] = math.max(min_width[column], longest)
        max_width[column] = math.max(max_width[column], total)
      end
      column = column + span
    end
  end)
  return min_width, max_width
end

local function sum(list)
  local total = 0
  for _, value in ipairs(list) do
    total = total + value
  end
  return total
end

local function fill_smallest_first(wanted, available)
  local assigned = {}
  local remaining = available
  local open = #wanted
  local changed = true
  while changed and open > 0 do
    changed = false
    local fair = remaining / open
    for index, width in ipairs(wanted) do
      if not assigned[index] and width <= fair then
        assigned[index] = width
        remaining = remaining - width
        open = open - 1
        changed = true
      end
    end
  end
  for index = 1, #wanted do
    if not assigned[index] then
      assigned[index] = remaining / open
    end
  end
  return assigned
end

local function column_widths(tbl)
  local min_width, max_width = column_metrics(tbl)
  local count = #min_width
  local available = max_line_chars - 3 * count
  local min_cap = available * max_word_share
  for index = 1, count do
    max_width[index] = max_width[index] + 2
    min_width[index] = math.min(min_width[index] + 2, min_cap, max_width[index])
  end

  if sum(max_width) <= available then
    return nil, available
  end

  local min_total = sum(min_width)
  if min_total >= available then
    return fill_smallest_first(min_width, available), available
  end

  local slack_total = sum(max_width) - min_total
  local spare = available - min_total
  local widths = {}
  for index = 1, count do
    local slack = max_width[index] - min_width[index]
    widths[index] = min_width[index] + spare * slack / slack_total
  end
  return widths, available
end

local function read_meta(meta)
  local chars_per_line = tonumber(pandoc.utils.stringify(meta["table-line-chars"] or ""))
  if chars_per_line and chars_per_line > 20 then
    max_line_chars = chars_per_line
  end
  local weight = tonumber(pandoc.utils.stringify(meta["table-code-weight"] or ""))
  if weight and weight > 0 then
    code_weight = weight
  end
end

local function Table(tbl)
  if not FORMAT:match("latex") and not FORMAT:match("beamer") then
    return nil
  end

  local widths, available = column_widths(tbl)
  if widths then
    for index, colspec in ipairs(tbl.colspecs) do
      tbl.colspecs[index] = { colspec[1], widths[index] / available }
    end
  end

  local limits = {}
  for index, colspec in ipairs(tbl.colspecs) do
    local share = colspec[2]
    if type(share) == "number" and share > 0 then
      limits[index] = math.max(share * available - 1.5, 4)
    end
  end
  if next(limits) == nil then
    return widths and tbl or nil
  end

  each_row(tbl, function(row)
    local column = 1
    for _, cell in ipairs(row.cells) do
      local limit = limits[column]
      if limit then
        cell.contents = cell.contents:walk(break_tokens_longer_than(limit))
      end
      column = column + (cell.col_span or 1)
    end
  end)
  return tbl
end

return {
  { Meta = read_meta },
  { Table = Table },
}
