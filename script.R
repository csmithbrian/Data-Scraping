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
