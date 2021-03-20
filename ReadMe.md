# Project Proposal

For this final project, the only member of this team is Daniel 
McGrath, and the idea that I have chosen to pursue is a social media 
app that allows users to share drinks they have had with their 
friends. Logging the drinks will take into account the type, the 
time, the location, an optional rating field for the drink, and an 
optional picture. It will also include a section that shows local 
bars near you as well as what their ratings are and who is “going”. I 
essentially want to create a mixture of Instagram and Yelp for 
drinking that is clean and easy to use.

Upon entering the app for the first time, the user will encounter a 
typical registration or login screen. This will lead a user through a 
set of prompts that obtain their email, password, and favorite 
drinks. The user will then land on a feed that will be empty until 
they either find people to be friends with, or they start posting 
themselves. The user will then be able to navigate to one of their 
friends or their own profile where they will see a card layout of all 
their recent drink excursions. When clicking into one of these cards, 
the user will be able to comment or like the event. In doing so, 
users will be able to share their opinions on the venue, drink, etc. 
with the user that posted the event. The app will also ideally 
contain a page that users can go to in order to see places that are 
close to them. If I can manage it, I would like to add ratings to the 
places as well as a “going” section because I think that people would 
like to see who is where during a night out. This will further 
promote a sense of community on the app because users can join their 
friends when they see where they are going without the hassle of over 
the phone back and forth communication.

 This app is very similar to Beer Buddy. At the conception of this 
idea (and after some work into it), I found out that there was an app 
very similar to it. I have never personally used Beer Buddy but based 
off of the screenshots in the App Store, my version is going to be 
more of an Instagram feel with a lot of similar functionality. If it 
isn’t all that different, I hope that I can create something that is 
comparable to that experience. I will most likely download and use 
the app a little bit to get a better feel for what their design and 
UX is like so that I can try and find areas of their app that I want 
to improve upon in my implementation. 

To accomplish this, I am going to be relying on an external API from 
Google called the Places API. This will allow the Phoenix/Elixir side 
of things to list venues within a radius of the user given a 
longitude and latitude. That way, this application can “suggest” 
nearby drink locations to a user as well as provide the social aspect 
of it. Hopefully I can also add objects to the Postgres database that 
contain a name and address along with a going, like, and dislike 
count so that when places are suggested users can see what other 
users on the platform think. This will end up reinforcing the 
experience for the second half of my target customer (the young 
professionals).

The real time behavior of the application will be in regard to the 
posts. I would have initially liked to make the real time behavior to 
be location tracking, but I think that would be a much larger 
undertaking. Instead, I am going to have posts be updated in real 
time and might carry over the liking and commenting as well. This 
way, users will not have to refresh the page. A caveat to this is 
that I might have to do something to prevent automatic scrolling 
otherwise that would be very annoying to have the posts you are 
looking at constantly moving. Another real time idea that I am 
playing with is a “going” option so that users can see who is going 
where to gauge where they might want to go out to drink for the 
night. This would allow people to either join or avoid others at 
venues. This would help solve the whole “which place is the move 
tonight” question by just showing what the most popular venues are 
going to be for the night.

Persistent state stored in this app will be in the form of posts, 
comments, places, and profiles. The profile fields will be linked to 
the user objects, but the profiles will have more information about 
the user than simply the login information stored in the user. I will 
probably play around with the idea of merging these two, but for 
right now I am going to say they are separate. The comments and posts 
will be quite similar to the work we did in the events app, so that 
shouldn’t be too difficult to replicate in this implementation. The 
places portion is going to be really interesting to put together. I 
am going to try and piggyback off of the Places API from Google by 
initially presenting the places with no ratings or metrics about 
them. Once users interact with these places in the app, it will 
create a spot in the table that links the name and address of the 
place in the table to the name and address from Google’s API while 
storing all of the data from the user interaction. In doing this, I 
just have to store all of the extra rating and “going” data from my 
app that supplements the data received from the Places API. 
For the “something neat” section of this app, I am going to be 
creating the experience where people can see where their friends are 
when they open the app. This will be very rudimentary and also 
require me to ask for location permissions which will be a cool 
addition to work with. The user will then be able to see which places 
are around them on a Google Maps instance, and which ones are hosting 
the most people. One of the challenges I foresee with this is 
figuring out what the best route going forward is going to be for 
displaying the map information. I will have to play around a lot with 
overlays on maps to get the most ideal result of  a fully customized 
icon, or in the worst-case scenario simply show the locations in a 
list with the distance away on the list item. This will be using the 
places around you section. In doing this, people will be able to see 
which places are the most popular for the night.

The first experiment I tried is getting all of the places within a 
set radius of a given latitude and longitude value. I first tried 
this using Postman to make sure that my API token is working and that 
I am not going to be blowing out my API limit with a faulty request. 
I then implemented this request in Elixir because this request is 
going to be handled on the Elixir side of things. The user is going 
to request the page then the server is going to grab those values and 
pass them to the user. The result was successful. Google’s APIs are 
very intuitive. They make it a very simple RESTful request. I learned 
that there even was a Places API. I wasn’t originally sure that I 
could get local places for the user to check out. This opens up 
another cool idea in that I could keep a list of name and addresses 
paired with ratings to make a rating system for the places. 
The second experiment focused on trying to overlay a point on a map 
view using Google’s simple marker function. As I was not able to get 
this working due to a hefty amount of debugging needed to get the 
Google side of things working. I was able to get the map to show with 
a little marker for a second, but then it just errors out due to a 
callback issue. I want to be able to use this to mark locations of 
you relative to local places if I can. This will allow for a more 
intuitive “Drink Venues Around You” section. Cause I could loop 
through the places received from the server which should have the 
latitude and longitude coordinates as part of the Json and 
dynamically add markers to the map. I learned that I am probably 
going to be doing a lot of the location-based getting and displaying 
through the JavaScript so that I can use the easier Google libraries, 
but I am still going to keep the Places information passed through 
the server. I have also learned that debugging for the Google maps 
API is a little more intricate than I thought. They do make it really 
easy, however, by grabbing divs in the DOM by id which is really easy 
to implement.

The users I expect to have most on the app are college age students. 
Otherwise, young adults that are looking to expand their craft drink 
knowledge and share that with others will be the second largest 
group. Going out for drinks, while not incredibly popular these days, 
is a very social activity. It can lead to a lot of conversations with 
co-workers and other students. Everyone wants to be in the loop for 
which breweries are the hottest, and this app will provide a way for 
people to catalogue that journey in a very social setting. On top of 
that, users also might want to know which bars are open right now and 
have the best covid policies. That is something that could be worked 
into the app, but the comments section will be a place for users to 
discuss in greater detail their likes and dislikes about their 
experiences. I have not personally used (and I don’t know anyone that 
does use) an app that is a one-stop-shop for all the questions they 
could ask about going out that night, and that is what this app is 
trying to accomplish for the average mid to late twenties socialite. 
For the college age users, the most common workflow is most likely 
going to be logging in, going to check the local users online, then 
checking the feed to see where the most people are going. I don’t 
think the college users are going to care as much about what people 
have to say about a venue. They are going to care more about who is 
going and when. They want to know what “the move” is going to be for 
the night, and act accordingly. This means that there might have to 
be a lot of focus on the going/not going aspect of the application. 
This would allow this type of user to have a centralized source of 
information for where people are going.

For the young professional users, the workflow is going to be a lot 
more focused on the description and comments sections of the 
application. They are going to log in and read through the most 
recent experiences people had to get a better understanding of if 
they want to go there themselves in the future. A way to cater to 
this will be to add a “saved posts” feature. This would allow people 
scrolling through their feed to save the place their friend went to 
for a later time, so they won’t have to waste time trying to find the 
post again. This will also mean the review and description sections 
will probably want to have a cleaner and more robust information 
entry that’s optional. That way, people can feel as though they are 
helping others of the same mindset by giving them more context to 
their drink experience.