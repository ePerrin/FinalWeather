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
- Cities : List of cities. Once a city is added, its current and forecast wheaters are stored in core data. A user can also remove a city here
- Main : These controllers are based on splitViewController, and give access to all forecast and current weather for a specific city

## Demo
- Clone the project in your local repository
- Open "FinalWeather.xcworkspace" file with Xcode
- Build app (Product -> Build or cmd B)
- Make sure you have access to network and test app (Product -> Test or cmd U), test should be successfull
- Run the app on an iOS simulator (Product -> Run or cmd R)



