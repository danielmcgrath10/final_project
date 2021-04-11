# Final Report - Daniel McGrath

## Meta Questions

### Who was on your team? 
- It was just me working on this project

### What's the URL of your deployed app? 
- https://final.danny-mcgrath.com

### What’s the URL of your github repository with the code for your de-
### ployed app?
- https://github.com/danielmcgrath10/final_project

### Is your app deployed and working?
- Yes, it should be

### For each team member, what work did that person do on the project?
- Daniel McGrath: Everything

--- 
## Summary
The project 2 app is sort of a social media for drinking. It is very s
imilar to beer buddy, but with some personal design choices and with m
y having never used the app before. The app has changed a little bit s
ince it's conception in the initial report. I think that I decided to 
try and break off a little more than I could chew when I first looked 
at this concept. That being said, I think that the only difference bet
ween the concept I first wrote about and the concept now is that I got
 rid of the main map view idea. Instead, the "nifty" thing that I adde
d was the geolocation api from google with the geolocator in the brows
er to reverse lookup neighborhoods using latitude and longitude coordi
nates. This allows users to just get their location and add it as the 
title of their posts rather than typing it in. Another big change was 
the login flow. I didn't put as much work into the user profiles as I 
thought I was going to initially. This came from really focusing on th
e livestream feed functionality using channels and then wrapping the G
oogle Places api for reviews in the search section. I also was very am
bitious in thinking I could also implement a going/not going functiona
lity for the application. I think that overall, the consesus is that m
y eyes were definitely too big for what I could realistically accompli
sh alone in the time provided with other course final projects.

Users begin by creating an account. This gains them access to the appl
ication, and allows them to see a feed of all the posts within the las
t two hours. Users can then create a post which takes a caption, how m
uch they liked it through a "rating" number, and what kind of drink th
ey had. The users can then go to the "search" section of the applicati
on and, through a search term, can find a place around them to see how
 other users on the platform like that location. This presents the use
r with a rating and a comments section so that they can get the best i
dea possible about what people think. 

The application meets all of the requirements listed. The app is built
 in two separate components (ui and server) where the backend is built
 in Elixir's Phoenix Framework utlizing channels and JSONs validated w
ith JWTs. The front end is built using the Create React App. The appli
cation is deployed to my Vultr VPS instance. The application uses user
 accounts with passwords for security. The application heavily utilize
s Postgres. The backend uses the Google Places API to serve informatio
n to the users. The application uses Phoenix channels to create the ho
me feed. These channels are subscribed to and then updated from the co
ntrollers using the Endpoint.broadcast function. As stated above, the 
application does use the devices geolocation in tandem with the revers
e geolocation api lookup from google to get the user's current neighbo
rhood. 

The complex part of the application was wrapping the results from the 
Google Places Api with additional information from the backend. I ende
d up finding that I could link the place_id provided in each return va
lue from the external api (allowed by Google) with a stored "Review". 
This allowed me to add votes and comments to the Place returned from t
he api so that users could have a "app only" source of information abo
ut this Place. It was a little fun to get working with Redux and the E
lixir backend because I had to code for different parts of the state u
pdating at different times to avoid calling the Google API over and ov
er again. 

The most significant challenge that I encountered was getting the chan
nel to work for the livestream feed. I found it difficult to debug, an
d it ended up eating a lot of time because I would follow similar proc
esses to what I had done in the past and found I was just getting hit 
with different errors every time. I eventually got it to work, but tha
t was the most significant challenge that I encountered.