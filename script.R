library(XML)
url <- "http://www.livescore.com/"
html <- htmlParse(url,useInternalNodes = TRUE)
rootNode <- xmlRoot(html)
#Premier League Only
altUrl <- "http://www.livescore.com/soccer/england/premier-league/results/all/"
altHtml <- htmlParse(altUrl,useInternalNodes = TRUE)
altRootNode <- xmlRoot(altHtml)
altScores <- xpathSApply(altRootNode,"//a[@class='scorelink']",xmlValue)
altHTeam <- xpathSApply(altRootNode,"//div[@class='ply tright name']",xmlValue)
altATeam <- xpathSApply(altRootNode,"//div[@class='ply name']",xmlValue)
altATeam <- trimws(altATeam,which = "both")
altHTeam <- trimws(altHTeam,which = "both")
altMin <- trimws(xpathSApply(altRootNode,"//div[@class='min']",xmlValue),"both")
altMatchDate <- t(xpathSApply(altRootNode,"//div[@data-esd]",xmlAttrs))
#altMatchDate <- t(altMatchDate)
altResultsDf <- data.frame(Home_Team = altHTeam, Score= altScores, Away_Team=altATeam,Min=altMin,Match_Date=altMatchDate[,5],stringsAsFactors = FALSE)
altResultsDf$Match_Date <- as.POSIXct(paste(substr(altResultsDf$Match_Date,5,6),substr(altResultsDf$Match_Date,7,8),substr(altResultsDf$Match_Date,1,4), substr(altResultsDf$Match_Date,9,10),substr(altResultsDf$Match_Date,11,12),substr(altResultsDf$Match_Date,13,14),sep = "/"),format="%m/%d/%Y/%H/%M/%S")
#Get rid of in progress games
#altResultsDf <- altResultsDf[which(altResultsDf$Score!="? - ?"),]
altResultsDf <- altResultsDf[which(altResultsDf$Min=="FT"),]

altMoreInfo <- xpathSApply(altRootNode,"//a[@class='scorelink'][@href]",xmlAttrs,"href")
altScorelinks<-paste0("http://www.livescore.com",altMoreInfo[1,])
altResultsDf$MatchInfoLink<-altScorelinks



#testing a match details script

matchNode<-htmlParse(altResultsDf$MatchInfoLink[1])
minute<-xpathSApply(matchNode,"//div[@data-id='details']/div[@class='min']",xmlValue)
names<-xpathSApply(matchNode,"//div[@data-id='details']/div[@class='ply tright' or @class='ply']/div/span[@class='name']",xmlValue)



#details<-xpathSApply(matchNode,"//div[@class='min']",xmlValue);details<-details[3:length(details)]

#doesnt work
#scoresNode <- getNodeSet(altRootNode, "//div[@data-esd]")
#z <- lapply(scoresNode, function(x){
#                 subDoc <- xmlDoc(x)
#                 r <- xpathApply(x, "//a[@href]")
#                 free(subDoc) # not sure if necessary
#                 return(r)
#})

