local hipster = {}

local WORDS_IN_SENTENCE = { min = 5, max = 15 }
local SENTENCES_IN_PARAGRAPH = { min = 2, max = 7 }
local PARAGRAPHS_IN_TEXT = { min = 2, max = 7 }

local function random_int(min, max)
    return math.random(min, max)
end

local BASE_PHRASE = [[
Hipster ipsum normal iTrust fund fashion axe bitters art party raw denim.
XOXO distillery tofu, letterpress cred literally gluten-free flexitarian fap.
VHS fashion axe gluten-free 90's church-key, kogi hashtag Marfa.
Kogi Tumblr Brooklyn chambray.
Flannel pickled YOLO semiotics.
Mlkshk keffiyeh narwhal, mumblecore gentrify raw denim food truck DIY.
Craft beer chia readymade ethnic, hella kogi Vice jean shorts cliche cray mlkshk ugh cornhole kitsch quinoa.
]]

local function get_words(phrase)
    local list = {}
    for word in phrase:gmatch "%a+" do
        table.insert(list, word:lower())
    end
    return list
end

hipster._dict = get_words(BASE_PHRASE)

function hipster:word()
    return hipster._dict[random_int(1, #hipster._dict)]
end

function hipster:sentence()
    local n = random_int(WORDS_IN_SENTENCE.min, WORDS_IN_SENTENCE.max)
    local words = {}
    for i = 1, n do
        words[i] = hipster:word()
    end
    local s = table.concat(words, " ")
    s = s .. "."
    s = s:sub(1, 1):upper() .. s:sub(2)
    return s
end

function hipster:paragraph()
    local n = random_int(SENTENCES_IN_PARAGRAPH.min, SENTENCES_IN_PARAGRAPH.max)
    local sentences = {}
    for i = 1, n do
        sentences[i] = hipster:sentence()
    end
    return table.concat(sentences, " ")
end

function hipster:text()
    local n = random_int(PARAGRAPHS_IN_TEXT.min, PARAGRAPHS_IN_TEXT.max)
    local paragraphs = {}
    for i = 1, n do
        paragraphs[i] = hipster:paragraph()
    end
    return table.concat(paragraphs, "\n")
end

function hipster:output()
    vim.cmd("normal A" .. hipster:text():gsub("\n", "\r"))
end

return hipster
