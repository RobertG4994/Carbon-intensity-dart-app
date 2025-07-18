# Carbon Intensity app
In this dart app, I made use of 2 API endpoints to display data for the user.

The first API provides carbon intensity data for the actual 30 mins timeframe. I displayed it in a simple way, using color as a mean for the user to understand the index level of carbon intensity. The second API provides all the data, in 30min timeframes, from the last 24h. I displayed this for the user by using a column which shows the level of intensity every 30min. I also used the same colors from the previous display to show the level of carbon. I tried to use date.now as the input for the API but it was not working. even when i was trying to hard code the current date it would still give errors. so I decided to substract 1 day, using yesterday's date.

Future additions: First, I would add multiple pages in the app. One main feature that I would add using the same API, would be a map of the UK. The user would be able to check and see the carbon intensity of all the regions of UK.
