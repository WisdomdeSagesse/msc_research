library(ghql)
library(jsonlite)
library(dplyr)

#link to KIVA API
link <- 'https://api.kivaws.org/graphql'
#create GraphQL client
conn <- GraphqlClient$new(url = link)
query <- '{
    lend {
        loans(filters: {country: ["BF", "TG", "CD", "GH", "KE", "LR", "MG", "MZ", "RW", "SN", "SL", "TZ", "TG", "UG"]}, limit: 3000) {
            values {
                id
                name
                loanAmount
                activity {
                    name
                }
                delinquent
                disbursalDate
                fundraisingDate
                gender
                geocode {
                    country {
                        name
                        isoCode
                        region
                    }
                    city
                }
                lenderRepaymentTerm
                paidAmount
                raisedDate
                researchScore
                repaymentInterval
                sector {
                    id
                }
                status
            }
        }
    }
}'
new <- Query$new()$query('link', query)
new$link
result <- conn$exec(new$link) %>%
    fromJSON(flatten = F)
result
kiva_AF_data <- result %>%
    as_tibble()
kiva_AF_data
kiva_AF_df <- data.frame(do.call("rbind", strsplit(as.character(kiva_AF_data$data$lend$loans$values), ",",
                                     fixed = TRUE)))
library(data.table)
kiva_AF_df_T <- transpose(kiva_AF_df)
kiva_AF_df_T
class(kiva_AF_df_T)
write.csv(kiva_AF_df_T, "C:\\Users\\User\\Downloads\\kiva_africa_loans2.csv", row.names=FALSE)
