## STRINGS WITH STRINGR

library(tidyverse)
library(stringr)
string1 <- "This is a string" 
string2 <- 'To put a "quote" inside a string, use single quotes' 

double_quote <- "\"" # or '"' used to output a double quote
single_quote <- '\'' # or "'" used to output a single quote
tab <- "\t"
next_line <- "\n"

x <- c("\"", "\\")
writeLines(x)

x <- "\u00b5" 
x 

c("one", "two", "three") # strings can be stored in character vectors

## STRING LENGTH

str_length(c("a", "R for data science", NA)) # tells us the length of a string

## COMBINING STRINGS
str_c("x","y")
str_c("x", "y", "z")
str_c("x", "y", sep = ", ")
x <- c("abc", NA) 
str_c("|-", x, "-|") 
str_c("|-", str_replace_na(x), "-|") ## using str_replace_na applies the formula to NA values as well

str_c("prefix-", c("a", "b", "c"), "-suffix")
name <- "Hadley" 
time_of_day <- "morning" 
birthday <- FALSE
str_c("Good ", time_of_day, " ", name,  
      if (birthday) " and HAPPY BIRTHDAY", 
      "." 
      ) 
str_c(c("x", "y", "z"), collapse = ", ")  ## used for collapsing a vector of strings into a single string

## SUBSETTING STRINGS
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1,3) ## extracting the first three letters
str_sub(x, -3, -1) ## negative numbers count backwards
str_sub("a",1,5)
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1)) # converting the first letters from upper case to lower case
x

## LOCALES
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr") ## turkish version
x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en")
str_sort(x, locale = "haw")

## Exercise
paste(c("red", "yellow"), "lorry")
paste(c("red", "yellow"), "lorry", collapse = ", ")
paste(c("red", "yellow"), "lorry", sep = ", ")
paste0(c("red", "yellow"), "lorry")
## paste works with many arguments while paste0 only works with one argument.

## sep is applied to the strings individually while collapse works for a vector of strings

y <- "Apple"
if (str_length(y) %% 2 == 0){
  str_sub(y, str_length(y)/2, str_length(y)/2 + 1)
} else {
  str_sub(y, str_length(y)/2, str_length(y)/2)
}

?str_wrap
str_wrap("Apple", width = 7)
?str_trim
str_trim("Apple  ", side = "right") # used to trim whitespaces
str_pad("Apple", 7, side = "left")

## MATCHING PATTERNS WITH REGULAR EXPRESSIONS
x <- c("apple", "banana", "pear") 
str_view(x, "an")
str_view(x, ".a.")
dot <- "\\."
writeLines(dot)
str_view(c("abc", "a.c", "bef"), "a\\.c")
x <- "a\\b";writeLines(x) 
str_view(x, "\\\\")

## Exercise
str_view(c(".a.b.c", ".a.b", "....."), c("\\..\\..\\.."), match = TRUE)

## ANCHORS
x <- c("apple", "banana", "pear") 
str_view(x, "^a") # ^ used to match the start of a string
str_view(x, "a$") # $ used to match the end of a string
x <- c("apple pie", "apple", "apple cake") 
str_view(x, "apple")
str_view(x, "^apple$")
str_view(c("$^$", "ab$^$sfas"), "^\\$\\^\\$$", match = TRUE)

## Exercise
str_view(words, "^y", match = TRUE)
str_view(words, "x$", match = TRUE)
str_view(words, "^...$", match = TRUE)
str_view(words, "^.......", match = TRUE)

## CHARACTER CLASSES AND ALTERNATIVES
str_view(c("grey", "gray"), "gr(e|a)y")

## Exercise
str_view(words,"^(a|e|i|o|u)")
str_subset(words, "^[^aeiou]+$") ## str_subset is used to subset matching strings out of a string vector
str_subset(words, "[^e]ed$")
str_subset(c("ed", words), "(^|[^e])ed$")
str_subset(words, "i(ng|se)$")
x <- c("123-456-7890", "1235-2351")
str_view(x, "\\d\\d\\d-\\d\\d\\d-\\d\\d\\d\\d")
str_view(words, "q[^u]", match = TRUE)

## REPETITION
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII" 
str_view(x, "CC?") # 0 OR 1 times
str_view(x, "CC+") # 1 or more
str_view(x, 'C[LX]+')
str_view(x, "C{2}") ## exactly two times
str_view(x, "C{2,}") ## two or more times
str_view(x, "C{2,3}") ## two or three times
str_view(x, 'C{2,3}?') ## by adding ?, the shortest string possible is matched
str_view(x, 'C[LX]+?')

## GROUPING AND BACKREFERENCES
str_view(fruit, "(..)\\1", match = TRUE)

## TOOLS

## DETECT MATCHES
x <- c("apple", "banana", "pear");str_detect(x, "e") ## string_detect returns TRUE or FALSE if the character appears in a string
sum(str_detect(words, "^t")) 
mean(str_detect(words, "[aeiou]$")) 
no_vowels_1 <- !str_detect(words, "[aeiou]") 
no_vowels_2 <- str_detect(words, "^[^aeiou]+$") 
identical(no_vowels_1, no_vowels_2) 
words[str_detect(words, "x$")]
str_subset(words, "x$") 
df <- tibble(word = words,  
             i = seq_along(word) 
             ) 
df %>%  
  filter(str_detect(words, "x$")) 
x <- c("apple", "banana", "pear") 
str_count(x, "a") ## str_count is used to counts the number of times the character appears in a string
mean(str_count(words, "[aeiou]"))
df %>%  
  mutate(vowels = str_count(word, "[aeiou]"), consonants = str_count(word, "[^aeiou]")  ) 
str_count("abababa", "aba")
str_view_all("abababa", "aba")

# Exercise
b1 <- words[str_detect(words, "^x")]
b1
b2 <- words[str_detect(words, "x$")]
b2
b3 <- words[str_detect(words,"^[aeiou]")]
b3
b4 <- b3[str_detect(b3, "[^aeiou]$")]
b4
str_view(words, "^[^a]", match = TRUE)
words[str_detect(words, "a") & str_detect(words, "e") & str_detect(words, "i") & str_detect(words, "o") & str_detect(words, "u")]
## [^()] This signifies that the command in the parentheses is what we are not looking for.
## EXTRACT MATCHES
length(sentences)
head(sentences)
colors <- c("red", "orange", "yellow", "green", "blue", "purple") 
color_match <- str_c(colors, collapse = "|") 
color_match 

has_color <- str_subset(sentences, color_match) 
matches <- str_extract(has_color, color_match) 
head(matches)
more <- sentences[str_count(sentences, color_match) > 1] 
str_view_all(more, color_match)
str_extract(more, color_match)  ## used for extracting the first matches in each string
str_extract_all(more, color_match) ## used for extracting all the matches
str_extract_all(more, color_match, simplify = TRUE)
x <- c("a", "a b", "a b c") 
str_extract_all(x, "[a-z]", simplify = TRUE) ## simplify true is used to return a matrix

## GROUPED MATCHES
noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>%  
  str_subset(noun) %>%  
  head(10) 
has_noun %>%  
  str_extract(noun) 
has_noun %>%  
  str_match(noun) 
tibble(sentence = sentences) %>%  
  tidyr::extract(sentence, c("article", "noun"), "(a|the) ([^ ]+)", remove = FALSE) 

## REPLACING MATCHES
x <- c("apple", "pear", "banana") 
str_replace(x, "[aeiou]", "-") ## str_replace is used to replace designated characters in strings. It does this for the first matching character
str_replace_all(x, "[aeiou]", "-") ## str_replace_all replaces all the designated characters in a string

x <- c("1 house", "2 cars", "3 people") 
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))
sentences %>%  
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>%  
  head(5)

## SPLITTING
sentences %>%  
  head(5) %>% 
  str_split(" ") ## str_split is used to split a string by " "
"a|b|c|d" %>%  
  str_split("\\|") %>%  
  .[[1]]
sentences %>%  
  head(5) %>%  
  str_split(" ", simplify = TRUE)
fields <- c("Name: Hadley", "Country: NZ", "Age: 35") 
fields %>% 
  str_split(": ", n = 2, simplify = TRUE) # n is used to request maximum number of pieces
x <- "This is a sentence.  This is another sentence." 
str_view_all(x, boundary("word"))
str_split(x, " ")[[1]] 
str_split(x, boundary("word"))[[1]] 

## FIND MATCHES
## Other types of patterns
str_view(fruit, "nana") # Is shorthand for 
str_view(fruit, regex("nana")) 
bananas <- c("banana", "Banana", "BANANA") 
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE)) # ignore_case is used to ignore the case of the string

x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]] 
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]] 
phone <- regex("\\(?     # optional opening parens  (\\d{3}) # area code  [)- ]?   # optional closing parens, dash, or space  (\\d{3}) # another three numbers  [ -]?    # optional space or dash  (\\d{3}) # three more numbers", comments = TRUE)
str_match("514-791-8141", phone) 

##install.packages("microbenchmark")
library(microbenchmark)
microbenchmark(fixed = str_detect(sentences, fixed("the")), regex = str_detect(sentences, "the"),  times = 20) 
a1 <- "\u00e1" 
a2 <- "a\u0301" 
c(a1, a2) 
a1 == a2
str_detect(a1, fixed(a2)) ## reports FALSE because they were defined differently
str_detect(a1, coll(a2)) ## coll uses collation rules and returns TRUE
i <- c("I", "İ", "i", "ı")
i 
str_subset(i, coll("i", ignore_case = TRUE)) 
str_subset(i,  coll("i", ignore_case = TRUE, locale = "tr"))

stringi::stri_locale_info()
x <- "This is a sentence." 
str_view_all(x, boundary("word"))
str_extract_all(x, boundary("word")) ## boundary can be used split a sentence as a string into words.

## Other Uses of Regular Expressions
apropos("replace") # used to output certain functions that contain the string
head(dir(pattern = "\\.Rmd$")) 

