library("pdftools") # to convert pdf to text
library("tm") # tools to work with text
library("wordcloud") # generate the wordcloud
library("RColorBrewer") # color palette 
library("Cairo") # antialiasing for better graphics



# Convert pdf to text and store as a character vector
tex<-pdf_text("/Users/macariolullo/Library/Mobile Documents/com~apple~CloudDocs/mueller-report-searchable.pdf")

# Convert the text string to a corpus to allow the tm
# package for work with it

docs <- Corpus(VectorSource(tex))

# We''ll spend a little time tidying up the corpus and 
# removing the common words that wouldn't be informative
# in a word cloud.

# Convert the text to lower case

docs <- tm_map(docs, content_transformer(tolower))

# remove numbers

docs <- tm_map(docs, removeNumbers)

# remove common English words

docs <- tm_map(docs, removeWords, stopwords("english"))

# specify any additional words you want removed
# revisit this line and run again after doing the
# visualization to add any extra words

docs <- tm_map(docs, removeWords, c("president", "presidents", "also",
                                    "one", "day", "ira", "time", "usc",
                                    "later", "part","see","may","june","july",
                                    "emails","white","based","crfill","ac",
                                    "gru","will","new","two","first","march",
                                    "next","describe","ection","gn","cial",
                                    "m","o","cir","corney","simer","electior",
                                    "department","yes","crifflharm","criff",
                                    "yes","crim","page","matter","matters",
                                    "post","criffl","united"))

# remove punctuation 

docs <- tm_map(docs, removePunctuation)

# Eliminate extra white spaces

docs<-tm_map(docs, stripWhitespace)

# There is a rondomization component (mostly in terms of)
# layout, so let's lock that randomization so we can 
# reproduce the exact same figure if we want to 

set.seed(5)

# Before making the figure, we're going to specify a graphics device to output to
# We'll use Cairo because it adds antialiasing for higher quality

CairoPNG("wordcloud.png", width = 600, height = 600)

# make the wordcloud

wordcloud(words = docs, 
          scale=c(3.5,0.75), # size difference between largest and smallest words
          min.freq = 1,
          max.words = 200, # how many words to plot
          random.order=FALSE, 
          rot.per=0.35, # what % of words will be rotated
          colors=brewer.pal(4, "Dark2")) # specify the color pallette

# Turn off the Cairo graphics device, which effectively saves the wordcloud as a .png

dev.off()




