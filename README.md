# game-of-life
Plays a modified game of life using processing. There are two types of organisms, predators and prey.
All organisms have a speed that is specified upon creation. Their speed determines the probability that
they will be able to move a space in a given generation. Both animals have a smell radius.

Prey will reproduce if next to another prey. The offspring's speed will be the average of the parent's 
speeds plus a mutation factor. A prey will die if it is next to too many other prey. If a predator
is within a prey's smell radius, it will move away from the predator instead of moving randomly. 

Predators will eat prey if they are next to one. Both animals have a smell radius. If a prey is within
a predator's smell radius, it will move towards the prey instead of moving randomly. 

The movements and actions of the animals is shown in the majority of the screen. To the right of the game board is a display of some data about the game. The bar on the left is the average speed of all the prey on the board. Lower numbers for speed make the animal move faster. The far right bar is a moving average for number of animals eaten by the predators. The window is 50 generations. 

##How to Play
1. Clone this repository into destination of your choice
2. Open the file "GameOfLife.pde" in the processing application
3. Click run
4. Press enter to run one generation, hold down the mouse to run generations continuously

##Advanced Play
There are two JSON files that hold the configuration for the game. 


<code>config.json</code> determines the board size, number of columns, and general prey/predator characteristics
The config variables and animal traits are as follows:
    * prey_reproduction_factor: probability that two adjacent prey will reproduce 
        a value of 1 gives 100% chance and a value of 2 gives 50% chance
    * prey_maximum_neighbors: max number of neighbors a prey can have before it will die
    * prey_mutation_factor: a greater factor will make prey offspring have more variable speed
        a value of 2 will have a chance of adding or subtracting 1 from the average speed of the parents
    * predator_smell_radius: a predator will move randomly unless a prey is within this radius at which point it will
    move towards the prey

<code>initial_animals.json</code> determines the starting configuration of the board
    Animals are specified as json objects. Each object specifies several traits. 
    * xCoord and yCoord: The starting coordinates of the animal. Must be within the size defined in <code>config.json</code>
    * speed: The speed of an animal is the chance that it will move during a given cycle.
        A value of 1 gives 100% chance and a value of 2 gives 50% chance.
    * type: The type of animal to be created.

##Biological Notes
This version of the game of life is supposed to explore the results of evolutionary pressures. Depending on how the game is configured, the prey will evolve different speeds. Using the bars on the right of the game, you can see that when there is a big spike in prey being eaten, the speed usually spikes as well. Depending on the starting configuration, the evolutionary pressures may be stronger or weaker, causing the prey to evolve faster or slower. 

##Technical Notes
It was a little interesting trying to make a more complex simulation in processing, but it worked well in the end. It seems to take a really long time to read the JSON files and set up the board, but it runs quickly after that. The variables and methods common to both animals are in a parent class, and things specific to prey or predators is in subclasses that extend the animal class. The game is built to be easily modifyable. There are definitely some things that can be done to make it better. I think that a much better way to display the average speed and animal consumption would be to plot the points over time to make a line chart. Adding evolution for the predators would not be too difficult and might make the game more interesting and provide some new data to display. 
