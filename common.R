require(XLConnect)


get_index_2014_data <- function() {
    index2014 <- readWorksheetFromFile(file.path("data/index2014_data.xls"), sheet=1)
    names(index2014) <- get_index_2014_headers()
    index2014[index2014 == "N/A"] <- NA
    index2014
}

get_index_2014_headers <- function() {
    c("CountryID", "Country.Name", "Webname", "Region", "World.Rank", 
      "Region.Rank", "Score", "Change.In.Yearly.Score.From.2013", 
      "Property.Rights", "Change.In.Property.Rights.From.2013", 
      "Freedom.From.Corruption", "Change.In.Freedom.From.Corruption.From.2013", 
      "Fiscal.Freedom", "Change.In.Fiscal.Freedom.From.2013", "Gov.Spending", 
      "Change.In.Gov.Spending.From.2013", "Business.Freemdom", 
      "Change.In.Business.Freedom.From.2013", "Labor.Freedom", 
      "Change.In.Labor.Freedom.From.2013", "Monetary.Freedom", 
      "Change.In.Monetary.Freedom.From.2013", "Trade.Freedom", 
      "Change.In.Trade.Freedom.From.2013", "Investment.Freedom", 
      "Change.In.Investment.Freedom.From.2013", "Financial.Freedom", 
      "Change.In.Financial.Freedom.From.2013", "Tariff.Rate.Percent", 
      "Income.Tax.Rate.Percent", "Corporate.Tax.Rate.Percent", 
      "Tax.Burden.Percent.Of.GDP", "Gov.Expenditure.Percent.Of.GDP", "Country", 
      "Population.In.Millions", "GDP.In.Billions.PPP", "GDP.Growth.Rate.Percent", 
      "Five.Years.GDP.Growth.Rate.Percent", "GDP.Per.Capta", "Unemployment.Percent", 
      "Inflation.Percent", "FDI.Inflow.In.Millions", "Public.Debt.As.Percent.Of.GDP")
}

get_countries <- function() {
    data <- get_index_2014_data()
    data[order(data["Country.Name"]), "Country.Name"]
}

get_all_index_data <- function() {
    d <- read.csv("data/all_index_data.csv")
    d[d == "N/A"] <- NA
    names(d) <- get_all_index_headers()
    d
}

get_all_index_headers <- function() {
    c("Name", "Index.Year", "Overall.Score", "Property.Rights", "Freedom.From.Corruption", "Fiscal.Freedom",
      "Government.Spending", "Business.Freedom", "Labor.Freedom", "Monetary.Freedom", "Trade.Freedom",
      "Investment.Freedom", "Financial.Freedom")
}

get_all_index_series <- function(countries, indicators) {
    data <- get_all_index_data()
    data <- subset(data, Name %in% countries)
    data <- data[, c(c("Index.Year", "Name"), indicators)]
    # data <- data[complete.cases(data), ]
    data <- data[order(data$Index.Year, data$Name), ]
}
