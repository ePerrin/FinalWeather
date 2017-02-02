# FinalWeather - iOS app with swift 3

## Intro
This project's goal is to set app a simple weather app according to [this project](https://github.com/FinalCAD/FinalWeather).

## Layers code
### Model Layer
The model layer rely on AFNetworking/SwiftyJSON to get data from OpenWeatherMap API and deserialize it to Object understable by iOS, and on Core Data to save entities in local store

### View Layer
Some utilities like date formatter, Localizable string or image management about elements displays inside controllers 

### Controller Layer
There is three differents storyboard:
- LaunchScreen : called before app done launching.
- Cities : first one call during app did finish launching. It's here that Lyon weather data is loaded. If I have some time, I could add others controllers in this storyboard to allow user adding it's own cities
- Main : call automaticaly after Cities, if there is stored data about Lyon in core data. This data could be already stored, or obtain via API. These controllers are based on splitViewController, with access to menu (forecast) for iPad in portrait mode 

## Demo
- Clone the project in your local repository
- Open "FinalWeather.xcworkspace" file with Xcode
- Build app (Product -> Build or cmd B)
- Make sure you have access to network and test app (Product -> Test or cmd U), test should be successfull
- Run the app on an iOS simulator (Product -> Run or cmd R)



