# HomeWeather
###iPhone Front-end for Home Data

##What is it?
This is a custom iPhone App I use to gather temperature and humidity data from my apartment. Using the app, I can know what is temperature in my living room, what is the humidity level. Also I use the app to control the temperature and the humidity of the apartment.
This is how the interface looks. 

![](http://i.giphy.com/26xBulBhc83RkUBAk.gif)

##How does it work?

###Logic & Workflow


• Both apps in A and B’s phones have home location LatLong Saved. It knows person A’s preferred home temp [A-Setpoint 70F, B-Setpoint 80F]. Essentially, my occupancy sensing is done using the person’s phone.
• I sample home temperature and humidity at 120 seconds interval - send it to PubNub cloud for computing daily averages, etc.
• Get weather data and next 4 hours prediction for home location from OpenWeather API.
• If time is > 9AM, and neither user A nor B is at home, set thermostat to Min Set Point [60F]. At this point, it is assumed we are not drawing any energy to heat the house. If next 4 hour prediction is Temp < 35 F, set thermostat to Set Point 65 F.
• If time is > 3PM, and neither user A nor B is at home, based on geographic location - see which user is closer to home. and set thermostat to that user’s preference.
• If both users are at home, set thermostat to whoever has a higher preferred temperature.

###Calculating the Energy Used in Heating

I used some approximations and calculations here. I assume my heaters only heat the air in the room, and not the walls, furniture, etc. I assume I have terrific insulation (which I am sure I don’t). I programmed this into a web app so the calculations keep happening automatically.

Here’s my calculations:

Dry Air Sp. Heat = 1 J/g Kelvin, Air Density = 1300 g/m^3, Home Area = 870 sq. ft, Room Height = 10 ft, Air Mass = Density*Area*Height. For Change in Temperature = T1 to T2 (i.e. Delta T), Energy = Dry Air Sp. Heat * Mass * Delta T. Since it takes about 45 mins, to heat from 60 F to 90 F in my apartment, I calculate the power used by my heater as Energy/45 minutes = 800 watts (I think, I don’t remember exactly)

###Calculating the Energy Used by Other Appliances

I have no access to the water heater, so I don’t know how much energy it uses. I ignore that.

I classify my home appliances into two types:
(1) always on — (i) Refrigerator. Its a 1992 built fridge, it uses 76 kWh/month according to a DOE Website.
(2) Frequently turned on/off — I connected these with the 433 MHz sockets. I connected these to my phone app so that every time I turn these on or off, it communicates to my PubNub data stream, and tells the energy app whether its on off. If on, it adds to the total energy being currently used. The appliances used are: (i) bedroom light (ii) living room lamp 1 (iii) living room lamp 2 (iv) study room light (v) microwave oven.
(3) Always connected, but used for a very small amount of time every day — (i) cooking range. (ii) bathroom lights. I do not actually include these in my energy usage calculations, but I should.

Thus, from the PubNub stream I can figure out which devices are on and off, and estimate the energy being used due to heating the room. This way, I can get a real time home energy usage prediction.


##Bill of Materials
1. DHT22 Temp and Humidity Sensor + Raspberry Pi + Some intermediate Python Scripts. [This Repo is only about the iOS front-end. The python scripts are in another repo: www.github.com/sayonsom/HomeAutomationPythonScripts]
2. PubNub — for real-time data streaming
3. I live in an old-ish University apartment, and cannot upgrade to a smart thermostat. So I use a small stepper motor connected to a Raspberry Pi to mechanically move the thermostat knob from ‘Min Set Point [60F]’ to ‘Max Set Point [90F]’. I use a Python script to turn the motor into different angles and it then moves a stick which in turn moves the thermostat knob. My entire workflow will have been much simpler/elegant using a smart thermostat like Nest, may be.
4. I now know that it takes about 45 minutes for my apartment to go from uncomfortably cold to a fuzzy 70F about 45 minutes, if the thermostat is moved to Max Set Point (90F) for the entire 45 mins with all windows closed.
5. It also takes about 5 hours for my apartment to go back to being uncomfortably cold after having turned down the thermostat to ‘Min Set Point [60F]’ from a comfortable set point [around 70-ish F].
6. I connected all my frequently switched on/off appliances into 433MHz remote-controlled power sockets. So I have 5 of these sockets. These can be purchased at: https://www.amazon.co.uk/gp/product/B00V4ISS38/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1634&creative=6738&creativeASIN=B00V4ISS38&linkCode=as2&tag=georgsinstr-21

##In Progress ...
- [ ] Smart Notification System that enables tells me when to raise or lower the temperature set-points.
- [ ] Addition of display on the screen which family members are in the house. (The app requires that all family members in the household has the app.]

