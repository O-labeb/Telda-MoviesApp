# MoviesApp

Movies List Scene             |  Movie Details Scene
:-------------------------:|:-------------------------:
<img src="https://user-images.githubusercontent.com/33517310/203113417-0e2e9ed8-b8e1-491b-9b1c-bad8ec5295f9.png" width="300">  |  <img src="https://user-images.githubusercontent.com/33517310/203113444-7d56f202-ba18-4cc8-afb4-383a390a320b.png" width="300">

## Design Prototpye
I prototyped the app on [figma](https://www.figma.com/file/LgOEsIsG1U0IR4he5OJhLJ/Untitled?node-id=0%3A1&t=Nxk3oMVdupnvZ9wQ-1) to be able to visualize the details not to miss any..

## Planning & Excution
I devided the project into serveral milestontes:
1. Project Setup https://github.com/O-labib/Telda-MoviesApp/pull/1
2. Networking Setup https://github.com/O-labib/Telda-MoviesApp/pull/2
2. Movies List Scene https://github.com/O-labib/Telda-MoviesApp/pull/3
2. Movie Details Scene https://github.com/O-labib/Telda-MoviesApp/pull/4
2. Cleanups and enhancements https://github.com/O-labib/Telda-MoviesApp/pull/5
2. Unit tests https://github.com/O-labib/Telda-MoviesApp/pull/6

I managed the progress of the project using [this](https://trello.com/b/KLc0cCd6/movies) trello board, and for ease of excution and review I implemented each milestone on a separate branch with a separate PR that was squashed and merged to the main branch.

## Notes
- I used MVP with a router component for this project since I saw it's quite suitable for this sized project..
Model components handle the data logic, Presenter handles the buisiness + presentation logic, whereas View handles the display & rendering logic.
- For searching I used native search controller component.
- To avoid searching while user types fast, I applied search debouncing with 0.3 seconds time interval.
- In the movies list, a movie added to watchlist has the icon black, whereas other movies not added to watchlist have a gray icon.

## Known Challenges:
- The base URL and api key are stored in the codebase, in production I would manage this more securely.
- Images base URL is hardcoded and not fetched/refreshed in codebase, It's not often changed, so for the sake of the task I hardcoded it.
- Pagination has no end condition, I checked the api and there seems to be so many pages, probably more than we will scroll to so I discarded handling its end condition.
- I used Userdefaults to manage the watchlist database, since I'm only persisting a list of IDs, I think Userdefauls will do the job perfectly.
- To group movies by date in a paginated list, there is no guarantee that only one section for each date will exist, since there is no way to fetch movies sorted by date.
- To avoid redundency, I didn't hanlde error in the details scene, it will be no different than the list scene.
- Since only 5 similar movies are needed to be displayed, I thought it's ok to display them in a scrollable view with no views reusability ( not a collection view or a table view )
- To avoid redundency, the details scene has less test coverage than the list scene for the sake of time.
- I didn't apply TTD, that's why I had to do some refactors while writing the tests, and decided to commit them with the tests.

