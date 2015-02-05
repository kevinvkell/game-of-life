# game-of-life
Plays the game of life using processing.

Click to run generations continuously. Press enter to run one generation.

<pre>
    The config variables and animal traits are as follows:
    prey_reproduction_factor: probability that two adjacent prey will reproduce 
        a value of 1 gives 100% chance and a value of 2 gives 50% chance
    prey_maximum_neighbors: max number of neighbors a prey can have before it will die
    prey_mutation_factor: a greater factor will make prey offspring have more variable speed
        a value of 2 will have a chance of adding or subtracting 1 from the average speed of the parents
    predator_smell_radius: a predator will move randomly unless a prey is within this radius at which point it will move towards the prey
    speed: the speed of an animal is the chance that it will move during a given cycle.
        a value of 1 gives 100% chance and a value of 2 gives 50% chance
</pre>
