--[[
Copyright (c) 2020 raidho36 <coaxilthedrug@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
]]--

local utf8 = utf8 or require ( 'utf8' )

local tometa = { __index = function ( _ , k ) return k end }
local tolower={['A']='a',['B']='b',['C']='c',['D']='d',['E']='e',['F']='f',['G']='g',['H']='h',['I']='i',['J']='j',['K']='k',['L']='l',['M']='m',['N']='n',['O']='o',['P']='p',['Q']='q',['R']='r',['S']='s',['T']='t',['U']='u',['V']='v',['W']='w',['X']='x',['Y']='y',['Z']='z',['À']='à',['Á']='á',['Â']='â',['Ã']='ã',['Ä']='ä',['Å']='å',['Æ']='æ',['Ç']='ç',['È']='è',['É']='é',['Ê']='ê',['Ë']='ë',['Ì']='ì',['Í']='í',['Î']='î',['Ï']='ï',['Ð']='ð',['Ñ']='ñ',['Ò']='ò',['Ó']='ó',['Ô']='ô',['Õ']='õ',['Ö']='ö',['Ø']='ø',['Ù']='ù',['Ú']='ú',['Û']='û',['Ü']='ü',['Ý']='ý',['Þ']='þ',['Ÿ']='ÿ',['Ā']='ā',['Ă']='ă',['Ą']='ą',['Ć']='ć',['Ĉ']='ĉ',['Ċ']='ċ',['Č']='č',['Ď']='ď',['Đ']='đ',['Ē']='ē',['Ĕ']='ĕ',['Ė']='ė',['Ę']='ę',['Ě']='ě',['Ĝ']='ĝ',['Ğ']='ğ',['Ġ']='ġ',['Ģ']='ģ',['Ĥ']='ĥ',['Ħ']='ħ',['Ĩ']='ĩ',['Ī']='ī',['Ĭ']='ĭ',['Į']='į',--[[I->ı]]['Ĳ']='ĳ',['Ĵ']='ĵ',['Ķ']='ķ',['Ĺ']='ĺ',['Ļ']='ļ',['Ľ']='ľ',['Ŀ']='ŀ',['Ł']='ł',['Ń']='ń',['Ņ']='ņ',['Ň']='ň',['Ŋ']='ŋ',['Ō']='ō',['Ŏ']='ŏ',['Ő']='ő',['Œ']='œ',['Ŕ']='ŕ',['Ŗ']='ŗ',['Ř']='ř',['Ś']='ś',['Ŝ']='ŝ',['Ş']='ş',['Š']='š',['Ţ']='ţ',['Ť']='ť',['Ŧ']='ŧ',['Ũ']='ũ',['Ū']='ū',['Ŭ']='ŭ',['Ů']='ů',['Ű']='ű',['Ų']='ų',['Ŵ']='ŵ',['Ŷ']='ŷ',['Ź']='ź',['Ż']='ż',['Ž']='ž',['Ƃ']='ƃ',['Ƅ']='ƅ',['Ƈ']='ƈ',['Ƌ']='ƌ',['Ƒ']='ƒ',['Ƙ']='ƙ',['Ơ']='ơ',['Ƣ']='ƣ',['Ƥ']='ƥ',['Ƨ']='ƨ',['Ƭ']='ƭ',['Ư']='ư',['Ƴ']='ƴ',['Ƶ']='ƶ',['Ƹ']='ƹ',['Ƽ']='ƽ',['Ǆ']='ǆ',['Ǉ']='ǉ',['Ǌ']='ǌ',['Ǎ']='ǎ',['Ǐ']='ǐ',['Ǒ']='ǒ',['Ǔ']='ǔ',['Ǖ']='ǖ',['Ǘ']='ǘ',['Ǚ']='ǚ',['Ǜ']='ǜ',['Ǟ']='ǟ',['Ǡ']='ǡ',['Ǣ']='ǣ',['Ǥ']='ǥ',['Ǧ']='ǧ',['Ǩ']='ǩ',['Ǫ']='ǫ',['Ǭ']='ǭ',['Ǯ']='ǯ',['Ǳ']='ǳ',['Ǵ']='ǵ',['Ǻ']='ǻ',['Ǽ']='ǽ',['Ǿ']='ǿ',['Ȁ']='ȁ',['Ȃ']='ȃ',['Ȅ']='ȅ',['Ȇ']='ȇ',['Ȉ']='ȉ',['Ȋ']='ȋ',['Ȍ']='ȍ',['Ȏ']='ȏ',['Ȑ']='ȑ',['Ȓ']='ȓ',['Ȕ']='ȕ',['Ȗ']='ȗ',['Ɓ']='ɓ',['Ɔ']='ɔ',['Ɗ']='ɗ',['Ǝ']='ɘ',['Ə']='ə',['Ɛ']='ɛ',['Ɠ']='ɠ',['Ɣ']='ɣ',['Ɨ']='ɨ',['Ɩ']='ɩ',['Ɯ']='ɯ',['Ɲ']='ɲ',['Ɵ']='ɵ',['Ʃ']='ʃ',['Ʈ']='ʈ',['Ʊ']='ʊ',['Ʋ']='ʋ',['Ʒ']='ʒ',['Ά']='ά',['Έ']='έ',['Ή']='ή',['Ί']='ί',['Α']='α',['Β']='β',['Γ']='γ',['Δ']='δ',['Ε']='ε',['Ζ']='ζ',['Η']='η',['Θ']='θ',['Ι']='ι',['Κ']='κ',['Λ']='λ',['Μ']='μ',['Ν']='ν',['Ξ']='ξ',['Ο']='ο',['Π']='π',['Ρ']='ρ',['Σ']='σ',['Τ']='τ',['Υ']='υ',['Φ']='φ',['Χ']='χ',['Ψ']='ψ',['Ω']='ω',['Ϊ']='ϊ',['Ϋ']='ϋ',['Ό']='ό',['Ύ']='ύ',['Ώ']='ώ',['Ϣ']='ϣ',['Ϥ']='ϥ',['Ϧ']='ϧ',['Ϩ']='ϩ',['Ϫ']='ϫ',['Ϭ']='ϭ',['Ϯ']='ϯ',['А']='а',['Б']='б',['В']='в',['Г']='г',['Д']='д',['Е']='е',['Ж']='ж',['З']='з',['И']='и',['Й']='й',['К']='к',['Л']='л',['М']='м',['Н']='н',['О']='о',['П']='п',['Р']='р',['С']='с',['Т']='т',['У']='у',['Ф']='ф',['Х']='х',['Ц']='ц',['Ч']='ч',['Ш']='ш',['Щ']='щ',['Ъ']='ъ',['Ы']='ы',['Ь']='ь',['Э']='э',['Ю']='ю',['Я']='я',['Ё']='ё',['Ђ']='ђ',['Ѓ']='ѓ',['Є']='є',['Ѕ']='ѕ',['І']='і',['Ї']='ї',['Ј']='ј',['Љ']='љ',['Њ']='њ',['Ћ']='ћ',['Ќ']='ќ',['Ў']='ў',['Џ']='џ',['Ѡ']='ѡ',['Ѣ']='ѣ',['Ѥ']='ѥ',['Ѧ']='ѧ',['Ѩ']='ѩ',['Ѫ']='ѫ',['Ѭ']='ѭ',['Ѯ']='ѯ',['Ѱ']='ѱ',['Ѳ']='ѳ',['Ѵ']='ѵ',['Ѷ']='ѷ',['Ѹ']='ѹ',['Ѻ']='ѻ',['Ѽ']='ѽ',['Ѿ']='ѿ',['Ҁ']='ҁ',['Ґ']='ґ',['Ғ']='ғ',['Ҕ']='ҕ',['Җ']='җ',['Ҙ']='ҙ',['Қ']='қ',['Ҝ']='ҝ',['Ҟ']='ҟ',['Ҡ']='ҡ',['Ң']='ң',['Ҥ']='ҥ',['Ҧ']='ҧ',['Ҩ']='ҩ',['Ҫ']='ҫ',['Ҭ']='ҭ',['Ү']='ү',['Ұ']='ұ',['Ҳ']='ҳ',['Ҵ']='ҵ',['Ҷ']='ҷ',['Ҹ']='ҹ',['Һ']='һ',['Ҽ']='ҽ',['Ҿ']='ҿ',['Ӂ']='ӂ',['Ӄ']='ӄ',['Ӈ']='ӈ',['Ӌ']='ӌ',['Ӑ']='ӑ',['Ӓ']='ӓ',['Ӕ']='ӕ',['Ӗ']='ӗ',['Ә']='ә',['Ӛ']='ӛ',['Ӝ']='ӝ',['Ӟ']='ӟ',['Ӡ']='ӡ',['Ӣ']='ӣ',['Ӥ']='ӥ',['Ӧ']='ӧ',['Ө']='ө',['Ӫ']='ӫ',['Ӯ']='ӯ',['Ӱ']='ӱ',['Ӳ']='ӳ',['Ӵ']='ӵ',['Ӹ']='ӹ',['Ա']='ա',['Բ']='բ',['Գ']='գ',['Դ']='դ',['Ե']='ե',['Զ']='զ',['Է']='է',['Ը']='ը',['Թ']='թ',['Ժ']='ժ',['Ի']='ի',['Լ']='լ',['Խ']='խ',['Ծ']='ծ',['Կ']='կ',['Հ']='հ',['Ձ']='ձ',['Ղ']='ղ',['Ճ']='ճ',['Մ']='մ',['Յ']='յ',['Ն']='ն',['Շ']='շ',['Ո']='ո',['Չ']='չ',['Պ']='պ',['Ջ']='ջ',['Ռ']='ռ',['Ս']='ս',['Վ']='վ',['Տ']='տ',['Ր']='ր',['Ց']='ց',['Ւ']='ւ',['Փ']='փ',['Ք']='ք',['Օ']='օ',['Ֆ']='ֆ',['Ⴀ']='ა',['Ⴁ']='ბ',['Ⴂ']='გ',['Ⴃ']='დ',['Ⴄ']='ე',['Ⴅ']='ვ',['Ⴆ']='ზ',['Ⴇ']='თ',['Ⴈ']='ი',['Ⴉ']='კ',['Ⴊ']='ლ',['Ⴋ']='მ',['Ⴌ']='ნ',['Ⴍ']='ო',['Ⴎ']='პ',['Ⴏ']='ჟ',['Ⴐ']='რ',['Ⴑ']='ს',['Ⴒ']='ტ',['Ⴓ']='უ',['Ⴔ']='ფ',['Ⴕ']='ქ',['Ⴖ']='ღ',['Ⴗ']='ყ',['Ⴘ']='შ',['Ⴙ']='ჩ',['Ⴚ']='ც',['Ⴛ']='ძ',['Ⴜ']='წ',['Ⴝ']='ჭ',['Ⴞ']='ხ',['Ⴟ']='ჯ',['Ⴠ']='ჰ',['Ⴡ']='ჱ',['Ⴢ']='ჲ',['Ⴣ']='ჳ',['Ⴤ']='ჴ',['Ⴥ']='ჵ',['Ḁ']='ḁ',['Ḃ']='ḃ',['Ḅ']='ḅ',['Ḇ']='ḇ',['Ḉ']='ḉ',['Ḋ']='ḋ',['Ḍ']='ḍ',['Ḏ']='ḏ',['Ḑ']='ḑ',['Ḓ']='ḓ',['Ḕ']='ḕ',['Ḗ']='ḗ',['Ḙ']='ḙ',['Ḛ']='ḛ',['Ḝ']='ḝ',['Ḟ']='ḟ',['Ḡ']='ḡ',['Ḣ']='ḣ',['Ḥ']='ḥ',['Ḧ']='ḧ',['Ḩ']='ḩ',['Ḫ']='ḫ',['Ḭ']='ḭ',['Ḯ']='ḯ',['Ḱ']='ḱ',['Ḳ']='ḳ',['Ḵ']='ḵ',['Ḷ']='ḷ',['Ḹ']='ḹ',['Ḻ']='ḻ',['Ḽ']='ḽ',['Ḿ']='ḿ',['Ṁ']='ṁ',['Ṃ']='ṃ',['Ṅ']='ṅ',['Ṇ']='ṇ',['Ṉ']='ṉ',['Ṋ']='ṋ',['Ṍ']='ṍ',['Ṏ']='ṏ',['Ṑ']='ṑ',['Ṓ']='ṓ',['Ṕ']='ṕ',['Ṗ']='ṗ',['Ṙ']='ṙ',['Ṛ']='ṛ',['Ṝ']='ṝ',['Ṟ']='ṟ',['Ṡ']='ṡ',['Ṣ']='ṣ',['Ṥ']='ṥ',['Ṧ']='ṧ',['Ṩ']='ṩ',['Ṫ']='ṫ',['Ṭ']='ṭ',['Ṯ']='ṯ',['Ṱ']='ṱ',['Ṳ']='ṳ',['Ṵ']='ṵ',['Ṷ']='ṷ',['Ṹ']='ṹ',['Ṻ']='ṻ',['Ṽ']='ṽ',['Ṿ']='ṿ',['Ẁ']='ẁ',['Ẃ']='ẃ',['Ẅ']='ẅ',['Ẇ']='ẇ',['Ẉ']='ẉ',['Ẋ']='ẋ',['Ẍ']='ẍ',['Ẏ']='ẏ',['Ẑ']='ẑ',['Ẓ']='ẓ',['Ẕ']='ẕ',['Ạ']='ạ',['Ả']='ả',['Ấ']='ấ',['Ầ']='ầ',['Ẩ']='ẩ',['Ẫ']='ẫ',['Ậ']='ậ',['Ắ']='ắ',['Ằ']='ằ',['Ẳ']='ẳ',['Ẵ']='ẵ',['Ặ']='ặ',['Ẹ']='ẹ',['Ẻ']='ẻ',['Ẽ']='ẽ',['Ế']='ế',['Ề']='ề',['Ể']='ể',['Ễ']='ễ',['Ệ']='ệ',['Ỉ']='ỉ',['Ị']='ị',['Ọ']='ọ',['Ỏ']='ỏ',['Ố']='ố',['Ồ']='ồ',['Ổ']='ổ',['Ỗ']='ỗ',['Ộ']='ộ',['Ớ']='ớ',['Ờ']='ờ',['Ở']='ở',['Ỡ']='ỡ',['Ợ']='ợ',['Ụ']='ụ',['Ủ']='ủ',['Ứ']='ứ',['Ừ']='ừ',['Ử']='ử',['Ữ']='ữ',['Ự']='ự',['Ỳ']='ỳ',['Ỵ']='ỵ',['Ỷ']='ỷ',['Ỹ']='ỹ',['Ἀ']='ἀ',['Ἁ']='ἁ',['Ἂ']='ἂ',['Ἃ']='ἃ',['Ἄ']='ἄ',['Ἅ']='ἅ',['Ἆ']='ἆ',['Ἇ']='ἇ',['Ἐ']='ἐ',['Ἑ']='ἑ',['Ἒ']='ἒ',['Ἓ']='ἓ',['Ἔ']='ἔ',['Ἕ']='ἕ',['Ἠ']='ἠ',['Ἡ']='ἡ',['Ἢ']='ἢ',['Ἣ']='ἣ',['Ἤ']='ἤ',['Ἥ']='ἥ',['Ἦ']='ἦ',['Ἧ']='ἧ',['Ἰ']='ἰ',['Ἱ']='ἱ',['Ἲ']='ἲ',['Ἳ']='ἳ',['Ἴ']='ἴ',['Ἵ']='ἵ',['Ἶ']='ἶ',['Ἷ']='ἷ',['Ὀ']='ὀ',['Ὁ']='ὁ',['Ὂ']='ὂ',['Ὃ']='ὃ',['Ὄ']='ὄ',['Ὅ']='ὅ',['Ὑ']='ὑ',['Ὓ']='ὓ',['Ὕ']='ὕ',['Ὗ']='ὗ',['Ὠ']='ὠ',['Ὡ']='ὡ',['Ὢ']='ὢ',['Ὣ']='ὣ',['Ὤ']='ὤ',['Ὥ']='ὥ',['Ὦ']='ὦ',['Ὧ']='ὧ',['ᾈ']='ᾀ',['ᾉ']='ᾁ',['ᾊ']='ᾂ',['ᾋ']='ᾃ',['ᾌ']='ᾄ',['ᾍ']='ᾅ',['ᾎ']='ᾆ',['ᾏ']='ᾇ',['ᾘ']='ᾐ',['ᾙ']='ᾑ',['ᾚ']='ᾒ',['ᾛ']='ᾓ',['ᾜ']='ᾔ',['ᾝ']='ᾕ',['ᾞ']='ᾖ',['ᾟ']='ᾗ',['ᾨ']='ᾠ',['ᾩ']='ᾡ',['ᾪ']='ᾢ',['ᾫ']='ᾣ',['ᾬ']='ᾤ',['ᾭ']='ᾥ',['ᾮ']='ᾦ',['ᾯ']='ᾧ',['Ᾰ']='ᾰ',['Ᾱ']='ᾱ',['Ῐ']='ῐ',['Ῑ']='ῑ',['Ῠ']='ῠ',['Ῡ']='ῡ',['Ⓐ']='ⓐ',['Ⓑ']='ⓑ',['Ⓒ']='ⓒ',['Ⓓ']='ⓓ',['Ⓔ']='ⓔ',['Ⓕ']='ⓕ',['Ⓖ']='ⓖ',['Ⓗ']='ⓗ',['Ⓘ']='ⓘ',['Ⓙ']='ⓙ',['Ⓚ']='ⓚ',['Ⓛ']='ⓛ',['Ⓜ']='ⓜ',['Ⓝ']='ⓝ',['Ⓞ']='ⓞ',['Ⓟ']='ⓟ',['Ⓠ']='ⓠ',['Ⓡ']='ⓡ',['Ⓢ']='ⓢ',['Ⓣ']='ⓣ',['Ⓤ']='ⓤ',['Ⓥ']='ⓥ',['Ⓦ']='ⓦ',['Ⓧ']='ⓧ',['Ⓨ']='ⓨ',['Ⓩ']='ⓩ',['Ａ']='ａ',['Ｂ']='ｂ',['Ｃ']='ｃ',['Ｄ']='ｄ',['Ｅ']='ｅ',['Ｆ']='ｆ',['Ｇ']='ｇ',['Ｈ']='ｈ',['Ｉ']='ｉ',['Ｊ']='ｊ',['Ｋ']='ｋ',['Ｌ']='ｌ',['Ｍ']='ｍ',['Ｎ']='ｎ',['Ｏ']='ｏ',['Ｐ']='ｐ',['Ｑ']='ｑ',['Ｒ']='ｒ',['Ｓ']='ｓ',['Ｔ']='ｔ',['Ｕ']='ｕ',['Ｖ']='ｖ',['Ｗ']='ｗ',['Ｘ']='ｘ',['Ｙ']='ｙ',['Ｚ']='ｚ',}
local toupper={['a']='A',['b']='B',['c']='C',['d']='D',['e']='E',['f']='F',['g']='G',['h']='H',['i']='I',['j']='J',['k']='K',['l']='L',['m']='M',['n']='N',['o']='O',['p']='P',['q']='Q',['r']='R',['s']='S',['t']='T',['u']='U',['v']='V',['w']='W',['x']='X',['y']='Y',['z']='Z',['à']='À',['á']='Á',['â']='Â',['ã']='Ã',['ä']='Ä',['å']='Å',['æ']='Æ',['ç']='Ç',['è']='È',['é']='É',['ê']='Ê',['ë']='Ë',['ì']='Ì',['í']='Í',['î']='Î',['ï']='Ï',['ð']='Ð',['ñ']='Ñ',['ò']='Ò',['ó']='Ó',['ô']='Ô',['õ']='Õ',['ö']='Ö',['ø']='Ø',['ù']='Ù',['ú']='Ú',['û']='Û',['ü']='Ü',['ý']='Ý',['þ']='Þ',['ÿ']='Ÿ',['ā']='Ā',['ă']='Ă',['ą']='Ą',['ć']='Ć',['ĉ']='Ĉ',['ċ']='Ċ',['č']='Č',['ď']='Ď',['đ']='Đ',['ē']='Ē',['ĕ']='Ĕ',['ė']='Ė',['ę']='Ę',['ě']='Ě',['ĝ']='Ĝ',['ğ']='Ğ',['ġ']='Ġ',['ģ']='Ģ',['ĥ']='Ĥ',['ħ']='Ħ',['ĩ']='Ĩ',['ī']='Ī',['ĭ']='Ĭ',['į']='Į',['ı']='I',['ĳ']='Ĳ',['ĵ']='Ĵ',['ķ']='Ķ',['ĺ']='Ĺ',['ļ']='Ļ',['ľ']='Ľ',['ŀ']='Ŀ',['ł']='Ł',['ń']='Ń',['ņ']='Ņ',['ň']='Ň',['ŋ']='Ŋ',['ō']='Ō',['ŏ']='Ŏ',['ő']='Ő',['œ']='Œ',['ŕ']='Ŕ',['ŗ']='Ŗ',['ř']='Ř',['ś']='Ś',['ŝ']='Ŝ',['ş']='Ş',['š']='Š',['ţ']='Ţ',['ť']='Ť',['ŧ']='Ŧ',['ũ']='Ũ',['ū']='Ū',['ŭ']='Ŭ',['ů']='Ů',['ű']='Ű',['ų']='Ų',['ŵ']='Ŵ',['ŷ']='Ŷ',['ź']='Ź',['ż']='Ż',['ž']='Ž',['ƃ']='Ƃ',['ƅ']='Ƅ',['ƈ']='Ƈ',['ƌ']='Ƌ',['ƒ']='Ƒ',['ƙ']='Ƙ',['ơ']='Ơ',['ƣ']='Ƣ',['ƥ']='Ƥ',['ƨ']='Ƨ',['ƭ']='Ƭ',['ư']='Ư',['ƴ']='Ƴ',['ƶ']='Ƶ',['ƹ']='Ƹ',['ƽ']='Ƽ',['ǆ']='Ǆ',['ǉ']='Ǉ',['ǌ']='Ǌ',['ǎ']='Ǎ',['ǐ']='Ǐ',['ǒ']='Ǒ',['ǔ']='Ǔ',['ǖ']='Ǖ',['ǘ']='Ǘ',['ǚ']='Ǚ',['ǜ']='Ǜ',['ǟ']='Ǟ',['ǡ']='Ǡ',['ǣ']='Ǣ',['ǥ']='Ǥ',['ǧ']='Ǧ',['ǩ']='Ǩ',['ǫ']='Ǫ',['ǭ']='Ǭ',['ǯ']='Ǯ',['ǳ']='Ǳ',['ǵ']='Ǵ',['ǻ']='Ǻ',['ǽ']='Ǽ',['ǿ']='Ǿ',['ȁ']='Ȁ',['ȃ']='Ȃ',['ȅ']='Ȅ',['ȇ']='Ȇ',['ȉ']='Ȉ',['ȋ']='Ȋ',['ȍ']='Ȍ',['ȏ']='Ȏ',['ȑ']='Ȑ',['ȓ']='Ȓ',['ȕ']='Ȕ',['ȗ']='Ȗ',['ɓ']='Ɓ',['ɔ']='Ɔ',['ɗ']='Ɗ',['ɘ']='Ǝ',['ə']='Ə',['ɛ']='Ɛ',['ɠ']='Ɠ',['ɣ']='Ɣ',['ɨ']='Ɨ',['ɩ']='Ɩ',['ɯ']='Ɯ',['ɲ']='Ɲ',['ɵ']='Ɵ',['ʃ']='Ʃ',['ʈ']='Ʈ',['ʊ']='Ʊ',['ʋ']='Ʋ',['ʒ']='Ʒ',['ά']='Ά',['έ']='Έ',['ή']='Ή',['ί']='Ί',['α']='Α',['β']='Β',['γ']='Γ',['δ']='Δ',['ε']='Ε',['ζ']='Ζ',['η']='Η',['θ']='Θ',['ι']='Ι',['κ']='Κ',['λ']='Λ',['μ']='Μ',['ν']='Ν',['ξ']='Ξ',['ο']='Ο',['π']='Π',['ρ']='Ρ',['σ']='Σ',['τ']='Τ',['υ']='Υ',['φ']='Φ',['χ']='Χ',['ψ']='Ψ',['ω']='Ω',['ϊ']='Ϊ',['ϋ']='Ϋ',['ό']='Ό',['ύ']='Ύ',['ώ']='Ώ',['ϣ']='Ϣ',['ϥ']='Ϥ',['ϧ']='Ϧ',['ϩ']='Ϩ',['ϫ']='Ϫ',['ϭ']='Ϭ',['ϯ']='Ϯ',['а']='А',['б']='Б',['в']='В',['г']='Г',['д']='Д',['е']='Е',['ж']='Ж',['з']='З',['и']='И',['й']='Й',['к']='К',['л']='Л',['м']='М',['н']='Н',['о']='О',['п']='П',['р']='Р',['с']='С',['т']='Т',['у']='У',['ф']='Ф',['х']='Х',['ц']='Ц',['ч']='Ч',['ш']='Ш',['щ']='Щ',['ъ']='Ъ',['ы']='Ы',['ь']='Ь',['э']='Э',['ю']='Ю',['я']='Я',['ё']='Ё',['ђ']='Ђ',['ѓ']='Ѓ',['є']='Є',['ѕ']='Ѕ',['і']='І',['ї']='Ї',['ј']='Ј',['љ']='Љ',['њ']='Њ',['ћ']='Ћ',['ќ']='Ќ',['ў']='Ў',['џ']='Џ',['ѡ']='Ѡ',['ѣ']='Ѣ',['ѥ']='Ѥ',['ѧ']='Ѧ',['ѩ']='Ѩ',['ѫ']='Ѫ',['ѭ']='Ѭ',['ѯ']='Ѯ',['ѱ']='Ѱ',['ѳ']='Ѳ',['ѵ']='Ѵ',['ѷ']='Ѷ',['ѹ']='Ѹ',['ѻ']='Ѻ',['ѽ']='Ѽ',['ѿ']='Ѿ',['ҁ']='Ҁ',['ґ']='Ґ',['ғ']='Ғ',['ҕ']='Ҕ',['җ']='Җ',['ҙ']='Ҙ',['қ']='Қ',['ҝ']='Ҝ',['ҟ']='Ҟ',['ҡ']='Ҡ',['ң']='Ң',['ҥ']='Ҥ',['ҧ']='Ҧ',['ҩ']='Ҩ',['ҫ']='Ҫ',['ҭ']='Ҭ',['ү']='Ү',['ұ']='Ұ',['ҳ']='Ҳ',['ҵ']='Ҵ',['ҷ']='Ҷ',['ҹ']='Ҹ',['һ']='Һ',['ҽ']='Ҽ',['ҿ']='Ҿ',['ӂ']='Ӂ',['ӄ']='Ӄ',['ӈ']='Ӈ',['ӌ']='Ӌ',['ӑ']='Ӑ',['ӓ']='Ӓ',['ӕ']='Ӕ',['ӗ']='Ӗ',['ә']='Ә',['ӛ']='Ӛ',['ӝ']='Ӝ',['ӟ']='Ӟ',['ӡ']='Ӡ',['ӣ']='Ӣ',['ӥ']='Ӥ',['ӧ']='Ӧ',['ө']='Ө',['ӫ']='Ӫ',['ӯ']='Ӯ',['ӱ']='Ӱ',['ӳ']='Ӳ',['ӵ']='Ӵ',['ӹ']='Ӹ',['ա']='Ա',['բ']='Բ',['գ']='Գ',['դ']='Դ',['ե']='Ե',['զ']='Զ',['է']='Է',['ը']='Ը',['թ']='Թ',['ժ']='Ժ',['ի']='Ի',['լ']='Լ',['խ']='Խ',['ծ']='Ծ',['կ']='Կ',['հ']='Հ',['ձ']='Ձ',['ղ']='Ղ',['ճ']='Ճ',['մ']='Մ',['յ']='Յ',['ն']='Ն',['շ']='Շ',['ո']='Ո',['չ']='Չ',['պ']='Պ',['ջ']='Ջ',['ռ']='Ռ',['ս']='Ս',['վ']='Վ',['տ']='Տ',['ր']='Ր',['ց']='Ց',['ւ']='Ւ',['փ']='Փ',['ք']='Ք',['օ']='Օ',['ֆ']='Ֆ',['ა']='Ⴀ',['ბ']='Ⴁ',['გ']='Ⴂ',['დ']='Ⴃ',['ე']='Ⴄ',['ვ']='Ⴅ',['ზ']='Ⴆ',['თ']='Ⴇ',['ი']='Ⴈ',['კ']='Ⴉ',['ლ']='Ⴊ',['მ']='Ⴋ',['ნ']='Ⴌ',['ო']='Ⴍ',['პ']='Ⴎ',['ჟ']='Ⴏ',['რ']='Ⴐ',['ს']='Ⴑ',['ტ']='Ⴒ',['უ']='Ⴓ',['ფ']='Ⴔ',['ქ']='Ⴕ',['ღ']='Ⴖ',['ყ']='Ⴗ',['შ']='Ⴘ',['ჩ']='Ⴙ',['ც']='Ⴚ',['ძ']='Ⴛ',['წ']='Ⴜ',['ჭ']='Ⴝ',['ხ']='Ⴞ',['ჯ']='Ⴟ',['ჰ']='Ⴠ',['ჱ']='Ⴡ',['ჲ']='Ⴢ',['ჳ']='Ⴣ',['ჴ']='Ⴤ',['ჵ']='Ⴥ',['ḁ']='Ḁ',['ḃ']='Ḃ',['ḅ']='Ḅ',['ḇ']='Ḇ',['ḉ']='Ḉ',['ḋ']='Ḋ',['ḍ']='Ḍ',['ḏ']='Ḏ',['ḑ']='Ḑ',['ḓ']='Ḓ',['ḕ']='Ḕ',['ḗ']='Ḗ',['ḙ']='Ḙ',['ḛ']='Ḛ',['ḝ']='Ḝ',['ḟ']='Ḟ',['ḡ']='Ḡ',['ḣ']='Ḣ',['ḥ']='Ḥ',['ḧ']='Ḧ',['ḩ']='Ḩ',['ḫ']='Ḫ',['ḭ']='Ḭ',['ḯ']='Ḯ',['ḱ']='Ḱ',['ḳ']='Ḳ',['ḵ']='Ḵ',['ḷ']='Ḷ',['ḹ']='Ḹ',['ḻ']='Ḻ',['ḽ']='Ḽ',['ḿ']='Ḿ',['ṁ']='Ṁ',['ṃ']='Ṃ',['ṅ']='Ṅ',['ṇ']='Ṇ',['ṉ']='Ṉ',['ṋ']='Ṋ',['ṍ']='Ṍ',['ṏ']='Ṏ',['ṑ']='Ṑ',['ṓ']='Ṓ',['ṕ']='Ṕ',['ṗ']='Ṗ',['ṙ']='Ṙ',['ṛ']='Ṛ',['ṝ']='Ṝ',['ṟ']='Ṟ',['ṡ']='Ṡ',['ṣ']='Ṣ',['ṥ']='Ṥ',['ṧ']='Ṧ',['ṩ']='Ṩ',['ṫ']='Ṫ',['ṭ']='Ṭ',['ṯ']='Ṯ',['ṱ']='Ṱ',['ṳ']='Ṳ',['ṵ']='Ṵ',['ṷ']='Ṷ',['ṹ']='Ṹ',['ṻ']='Ṻ',['ṽ']='Ṽ',['ṿ']='Ṿ',['ẁ']='Ẁ',['ẃ']='Ẃ',['ẅ']='Ẅ',['ẇ']='Ẇ',['ẉ']='Ẉ',['ẋ']='Ẋ',['ẍ']='Ẍ',['ẏ']='Ẏ',['ẑ']='Ẑ',['ẓ']='Ẓ',['ẕ']='Ẕ',['ạ']='Ạ',['ả']='Ả',['ấ']='Ấ',['ầ']='Ầ',['ẩ']='Ẩ',['ẫ']='Ẫ',['ậ']='Ậ',['ắ']='Ắ',['ằ']='Ằ',['ẳ']='Ẳ',['ẵ']='Ẵ',['ặ']='Ặ',['ẹ']='Ẹ',['ẻ']='Ẻ',['ẽ']='Ẽ',['ế']='Ế',['ề']='Ề',['ể']='Ể',['ễ']='Ễ',['ệ']='Ệ',['ỉ']='Ỉ',['ị']='Ị',['ọ']='Ọ',['ỏ']='Ỏ',['ố']='Ố',['ồ']='Ồ',['ổ']='Ổ',['ỗ']='Ỗ',['ộ']='Ộ',['ớ']='Ớ',['ờ']='Ờ',['ở']='Ở',['ỡ']='Ỡ',['ợ']='Ợ',['ụ']='Ụ',['ủ']='Ủ',['ứ']='Ứ',['ừ']='Ừ',['ử']='Ử',['ữ']='Ữ',['ự']='Ự',['ỳ']='Ỳ',['ỵ']='Ỵ',['ỷ']='Ỷ',['ỹ']='Ỹ',['ἀ']='Ἀ',['ἁ']='Ἁ',['ἂ']='Ἂ',['ἃ']='Ἃ',['ἄ']='Ἄ',['ἅ']='Ἅ',['ἆ']='Ἆ',['ἇ']='Ἇ',['ἐ']='Ἐ',['ἑ']='Ἑ',['ἒ']='Ἒ',['ἓ']='Ἓ',['ἔ']='Ἔ',['ἕ']='Ἕ',['ἠ']='Ἠ',['ἡ']='Ἡ',['ἢ']='Ἢ',['ἣ']='Ἣ',['ἤ']='Ἤ',['ἥ']='Ἥ',['ἦ']='Ἦ',['ἧ']='Ἧ',['ἰ']='Ἰ',['ἱ']='Ἱ',['ἲ']='Ἲ',['ἳ']='Ἳ',['ἴ']='Ἴ',['ἵ']='Ἵ',['ἶ']='Ἶ',['ἷ']='Ἷ',['ὀ']='Ὀ',['ὁ']='Ὁ',['ὂ']='Ὂ',['ὃ']='Ὃ',['ὄ']='Ὄ',['ὅ']='Ὅ',['ὑ']='Ὑ',['ὓ']='Ὓ',['ὕ']='Ὕ',['ὗ']='Ὗ',['ὠ']='Ὠ',['ὡ']='Ὡ',['ὢ']='Ὢ',['ὣ']='Ὣ',['ὤ']='Ὤ',['ὥ']='Ὥ',['ὦ']='Ὦ',['ὧ']='Ὧ',['ᾀ']='ᾈ',['ᾁ']='ᾉ',['ᾂ']='ᾊ',['ᾃ']='ᾋ',['ᾄ']='ᾌ',['ᾅ']='ᾍ',['ᾆ']='ᾎ',['ᾇ']='ᾏ',['ᾐ']='ᾘ',['ᾑ']='ᾙ',['ᾒ']='ᾚ',['ᾓ']='ᾛ',['ᾔ']='ᾜ',['ᾕ']='ᾝ',['ᾖ']='ᾞ',['ᾗ']='ᾟ',['ᾠ']='ᾨ',['ᾡ']='ᾩ',['ᾢ']='ᾪ',['ᾣ']='ᾫ',['ᾤ']='ᾬ',['ᾥ']='ᾭ',['ᾦ']='ᾮ',['ᾧ']='ᾯ',['ᾰ']='Ᾰ',['ᾱ']='Ᾱ',['ῐ']='Ῐ',['ῑ']='Ῑ',['ῠ']='Ῠ',['ῡ']='Ῡ',['ⓐ']='Ⓐ',['ⓑ']='Ⓑ',['ⓒ']='Ⓒ',['ⓓ']='Ⓓ',['ⓔ']='Ⓔ',['ⓕ']='Ⓕ',['ⓖ']='Ⓖ',['ⓗ']='Ⓗ',['ⓘ']='Ⓘ',['ⓙ']='Ⓙ',['ⓚ']='Ⓚ',['ⓛ']='Ⓛ',['ⓜ']='Ⓜ',['ⓝ']='Ⓝ',['ⓞ']='Ⓞ',['ⓟ']='Ⓟ',['ⓠ']='Ⓠ',['ⓡ']='Ⓡ',['ⓢ']='Ⓢ',['ⓣ']='Ⓣ',['ⓤ']='Ⓤ',['ⓥ']='Ⓥ',['ⓦ']='Ⓦ',['ⓧ']='Ⓧ',['ⓨ']='Ⓨ',['ⓩ']='Ⓩ',['ａ']='Ａ',['ｂ']='Ｂ',['ｃ']='Ｃ',['ｄ']='Ｄ',['ｅ']='Ｅ',['ｆ']='Ｆ',['ｇ']='Ｇ',['ｈ']='Ｈ',['ｉ']='Ｉ',['ｊ']='Ｊ',['ｋ']='Ｋ',['ｌ']='Ｌ',['ｍ']='Ｍ',['ｎ']='Ｎ',['ｏ']='Ｏ',['ｐ']='Ｐ',['ｑ']='Ｑ',['ｒ']='Ｒ',['ｓ']='Ｓ',['ｔ']='Ｔ',['ｕ']='Ｕ',['ｖ']='Ｖ',['ｗ']='Ｗ',['ｘ']='Ｘ',['ｙ']='Ｙ',['ｚ']='Ｚ',}
setmetatable ( tolower, tometa )
setmetatable ( toupper, tometa )

local utf8_offset = utf8.offset
local string_sub = string.sub
local string_len = string.len
local sub = function ( str, i, j )
	i = utf8_offset ( str, i ) or ( i > 0 and string_len ( str ) or 1 )
	if j and j < 0 and j >= -1 then j = nil end
	if j then j = ( utf8_offset ( str, j + 1 ) or ( j > 0 and string_len ( str ) + 1 or 1 ) ) - 1 end
	return string_sub ( str, i, j )
end

local utf8_charpattern = utf8.charpattern
local string_gsub = string.gsub
local lower = function ( str )
	str = string_gsub ( str, utf8_charpattern, tolower )
	return str
end

local upper = function ( str )
	str = string_gsub ( str, utf8_charpattern, toupper )
	return str
end

local string_match = string.match
local function uft8dotpattern ( pat ) return pat == "%." and pat or utf8_charpattern end
local match = function ( str, pattern, init )
	if init then init = utf8_offset ( str, init ) or ( init > 0 and string_len ( str ) or 1 ) end
	pattern = string_gsub ( pattern, "%%?%.", uft8dotpattern )
	return string_match ( str, pattern, init )
end

local string_gmatch = string.gmatch
local gmatch = function ( str, pattern )
	pattern = string_gsub ( pattern, "%%?%.", uft8dotpattern )
	return string_gmatch ( str, pattern )
end

local gsub = function ( str, pattern, replace, num )
	pattern = string_gsub ( pattern, "%%?%.", uft8dotpattern )
	return string_gsub ( str, pattern, replace, num )
end

local table_insert = table.insert
local table_concat = table.concat
local reverse = function ( str )
	local out = { }
	for s in string_gmatch ( str, utf8_charpattern ) do
		table_insert ( out, s )
	end
	local l = #out + 1
	for i = 1, l / 2 do
		out[ i ], out[ l - i ] = out[ l - i ], out[ i ]
	end
	return table_concat ( out )
end

local utf8_len = utf8.len
local string_find = string.find
local find = function ( str, pattern, init, plain )
	if init then init = utf8_offset ( str, init ) or ( init > 0 and string_len ( str ) or 1 ) end
	if not plain then pattern = string_gsub ( pattern, "%%?%.", uft8dotpattern ) end
	local a, b = string_find ( str, pattern, init, plain )
	if a and b then
		return utf8_len ( str, 1, a ), utf8_len ( str, 1, b )
	end
	return nil
end

local module = {
	dump    = string.dump,
	byte    = string.byte,
--	code    = utf8.codepoint,
	char    = utf8.char,
	format  = string.format,
	rep     = string.rep,
	len     = utf8.len,
	bytelen = string.len,

	codes   = utf8.codes,
	offset  = utf8.offset,

	sub     = sub,
	match   = match,
	gmatch  = gmatch,
	gsub    = gsub,
	find    = find,
	lower   = lower,
	upper   = upper,
	reverse = reverse,

	lowerpattern = "abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿāăąćĉċčďđēĕėęěĝğġģĥħĩīĭįıĳĵķĺļľŀłńņňŋōŏőœŕŗřśŝşšţťŧũūŭůűųŵŷźżžƃƅƈƌƒƙơƣƥƨƭưƴƶƹƽǆǉǌǎǐǒǔǖǘǚǜǟǡǣǥǧǩǫǭǯǳǵǻǽǿȁȃȅȇȉȋȍȏȑȓȕȗɓɔɗɘəɛɠɣɨɩɯɲɵʃʈʊʋʒάέήίαβγδεζηθικλμνξοπρστυφχψωϊϋόύώϣϥϧϩϫϭϯабвгдежзийклмнопрстуфхцчшщъыьэюяёђѓєѕіїјљњћќўџѡѣѥѧѩѫѭѯѱѳѵѷѹѻѽѿҁґғҕҗҙқҝҟҡңҥҧҩҫҭүұҳҵҷҹһҽҿӂӄӈӌӑӓӕӗәӛӝӟӡӣӥӧөӫӯӱӳӵӹաբգդեզէըթժիլխծկհձղճմյնշոչպջռսվտրցւփքօֆაბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰჱჲჳჴჵḁḃḅḇḉḋḍḏḑḓḕḗḙḛḝḟḡḣḥḧḩḫḭḯḱḳḵḷḹḻḽḿṁṃṅṇṉṋṍṏṑṓṕṗṙṛṝṟṡṣṥṧṩṫṭṯṱṳṵṷṹṻṽṿẁẃẅẇẉẋẍẏẑẓẕạảấầẩẫậắằẳẵặẹẻẽếềểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵỷỹἀἁἂἃἄἅἆἇἐἑἒἓἔἕἠἡἢἣἤἥἦἧἰἱἲἳἴἵἶἷὀὁὂὃὄὅὑὓὕὗὠὡὢὣὤὥὦὧᾀᾁᾂᾃᾄᾅᾆᾇᾐᾑᾒᾓᾔᾕᾖᾗᾠᾡᾢᾣᾤᾥᾦᾧᾰᾱῐῑῠῡⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ",
	upperpattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸĀĂĄĆĈĊČĎĐĒĔĖĘĚĜĞĠĢĤĦĨĪĬĮIĲĴĶĹĻĽĿŁŃŅŇŊŌŎŐŒŔŖŘŚŜŞŠŢŤŦŨŪŬŮŰŲŴŶŹŻŽƂƄƇƋƑƘƠƢƤƧƬƯƳƵƸƼǄǇǊǍǏǑǓǕǗǙǛǞǠǢǤǦǨǪǬǮǱǴǺǼǾȀȂȄȆȈȊȌȎȐȒȔȖƁƆƊƎƏƐƓƔƗƖƜƝƟƩƮƱƲƷΆΈΉΊΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΪΫΌΎΏϢϤϦϨϪϬϮАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯЁЂЃЄЅІЇЈЉЊЋЌЎЏѠѢѤѦѨѪѬѮѰѲѴѶѸѺѼѾҀҐҒҔҖҘҚҜҞҠҢҤҦҨҪҬҮҰҲҴҶҸҺҼҾӁӃӇӋӐӒӔӖӘӚӜӞӠӢӤӦӨӪӮӰӲӴӸԱԲԳԴԵԶԷԸԹԺԻԼԽԾԿՀՁՂՃՄՅՆՇՈՉՊՋՌՍՎՏՐՑՒՓՔՕՖႠႡႢႣႤႥႦႧႨႩႪႫႬႭႮႯႰႱႲႳႴႵႶႷႸႹႺႻႼႽႾႿჀჁჂჃჄჅḀḂḄḆḈḊḌḎḐḒḔḖḘḚḜḞḠḢḤḦḨḪḬḮḰḲḴḶḸḺḼḾṀṂṄṆṈṊṌṎṐṒṔṖṘṚṜṞṠṢṤṦṨṪṬṮṰṲṴṶṸṺṼṾẀẂẄẆẈẊẌẎẐẒẔẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼẾỀỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰỲỴỶỸἈἉἊἋἌἍἎἏἘἙἚἛἜἝἨἩἪἫἬἭἮἯἸἹἺἻἼἽἾἿὈὉὊὋὌὍὙὛὝὟὨὩὪὫὬὭὮὯᾈᾉᾊᾋᾌᾍᾎᾏᾘᾙᾚᾛᾜᾝᾞᾟᾨᾩᾪᾫᾬᾭᾮᾯᾸᾹῘῙῨῩⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ",
	charpattern  = utf8.charpattern,
	codepoint    = utf8.codepoint,
}

return module
