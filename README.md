#  LOG
**LOG** is an application for gamers,**LOG** stands for List Of Games, from it’s name it’s related for gamers, where you search for the required game and then you can make list for your games one as a favorite, one in a wish list and the last is the rating list, where you rate games, and as a gamer it’s an important thing to give rating for game you just finished better than giving it rate after while where you might lost some of the game experience, I chose **LOG** to be like the log file of events.

## API
**giantbomb** API is used to retrieve information of games , you can access the documentation of the API methods [here](https://www.giantbomb.com/api/documentation/).

the used methods :
-[search](https://www.giantbomb.com/api/documentation/#toc-0-41)
-[game](https://www.giantbomb.com/api/documentation/#toc-0-16)

## Rating system 
A star rating system is used in the project known as Cosmos and it's installed in the project by adding **CosmosDistrib.swift** file to the project directory,you can access Cosmos on github [here](https://github.com/evgenyneu/Cosmos).

## Persistent storage
Core Data framework is user to persist the data.

## What is game object?
Game is the main object of the project which has 13 attributes :
1. guid: unique ID of the game
2. name: name of the game
3. developer:  name of the game's developer
4. publisher: name of the game's publisher
5. theme: main theme of the game
6. imageString: medium url of the game poster to be used in the imageView of  **GameDetailsViewController**
7. iconImageString: url of the icon game poster to be used in the imageViews in cells of the table views
8. detailsURL: url of the game's page on giantbomb website
9. releaseDate: release data of the game
10. rating: the user entered rating
11. isFavorite: boolean indicating game is in favorites
12. isWished: boolean indicating game is in wish list
13. isRated: boolean indicating game is in rating list

## Implementation

**LOG** consists of  `UITabBarController` which has 4 tabs :
1. **SearchGameViewController**: consists of `UISearchBar`,`UITableView`,`UIActivityIndicatorView`,where the user enters the name of the required game and then an request is sent to **giantbomb** to get results containing games of the required query,populated in the **tableView**,and when a game is seleted it moves to **GameDetailsViewController**.
2. **FavoriteListViewController**: consists of `UITableView`,this view populates the games saved in the persistent store based on isFavorite value,user can also remove the game from the list by sliding the table row or from the edit button.
3. **WishListViewController**: consists of `UITableView`,this view populates the games saved in the persistent store based on isWished value,user can also remove the game from the list by sliding the table row or from the edit button.
4. **RatingListViewController**: consists of `UITableView` with custom `UITableViewCell` it's custom class is RatingListViewCell containing `UILabel`,`CosmosView`,`UIImageView`,this view populates the games saved in the persistent store based on isRated value,user can also remove the game from the list by sliding the table row of from the edit button.

**GameDetailsViewController**: A `UIViewController` consists of `UIImageView`,vertical stackview containg horizontal stackviews containg `UILabels`,to show the game poster and details of the game(name,developer,publisher,release date,theme), and the more details `UIButton` directs the user to the game's page on giantbomb website,there are three `UIBarButton`, one for toggling favorite, one for toggling wish and one for rating,by pressing any of these buttons the selected game is added to the relating list,also if the game is in the list pressing the relating button removing it from the list 

## Requirements
Xcode 10
Swift 4.2 
