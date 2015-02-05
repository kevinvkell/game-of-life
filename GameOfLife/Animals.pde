class Animal {
    int xCoord;
    int yCoord;
    int speed;
    String type;

    Animal(int newXCoord, int newYCoord, int newSpeed) {
        xCoord = newXCoord;
        yCoord = newYCoord;
        speed = newSpeed;
    }

    Animal(int newXCoord, int newYCoord) {
        xCoord = newXCoord;
        yCoord = newYCoord;
        speed = 1;
    }

    void setCoordinates(int newXCoord, int newYCoord) {
        xCoord = newXCoord;
        yCoord = newYCoord;
    }

    void fixCoordinates() {
        xCoord = getValidX(xCoord);
        yCoord = getValidY(yCoord);
    }

    boolean isAdjacent(Animal otherAnimal) {
        if((otherAnimal.xCoord <= xCoord + 1) && (otherAnimal.xCoord >= xCoord - 1)) {
            if((otherAnimal.yCoord <= yCoord + 1) && (otherAnimal.yCoord >= yCoord - 1)) {
                return true;
            }
        }

        return false;
    }

    ArrayList<Animal> getNeighbors() {
        ArrayList<Animal> result = new ArrayList<Animal>();

        for(Animal currentAnimal : world.animalList) {
            if(this.isAdjacent(currentAnimal)) {
                result.add(currentAnimal);
            }
        }

        return result;
    }

    Animal getNearest(String type) {
        PVector animalLocation = new PVector(xCoord, yCoord);
        Animal nearest = null;
        int closest_distance = predator_smell_radius;

        for(Animal target : world.animalList) {
            PVector targetLocation = new PVector(target.xCoord, target.yCoord);
            int difference = int(animalLocation.dist(targetLocation));

            if(difference <= closest_distance) {
                if(type.equals("animal") || target.type.equals(type)) {
                    closest_distance = closest_distance;
                    nearest = target;
                }
            }
        }

        return nearest;
    }

    void move_to_location(int x, int y) {
        world.removeAnimal(xCoord, yCoord);

        xCoord += x;
        yCoord += y;
        fixCoordinates();

        world.addAnimal(this);
    }

    void move() {
        int xMovement = int(random(3)) - 1;
        int yMovement = int(random(3)) - 1;

        boolean successfull_move = int(random(speed)) == 0;
        if(successfull_move) {
            this.move_to_location(xMovement, yMovement);
        }
    }

    void display() {
        //should not be called
    }

    void checkConditions() {
        //should not be called
    }
}

class Predator extends Animal {
    Predator(int newXCoord, int newYCoord) {
        super(newXCoord, newYCoord);
        type = "predator";
    }

    Predator(int newXCoord, int newYCoord, int newSpeed) {
        super(newXCoord, newYCoord, newSpeed);
        type = "predator";
    }

    void move() {
        Animal nearest_prey = this.getNearest("prey");

        if(nearest_prey != null) {
            int xDiff = nearest_prey.xCoord - xCoord;
            int yDiff = nearest_prey.yCoord - yCoord;
            int xMovement = xDiff == 0 ? 0 : xDiff/abs(xDiff);
            int yMovement = yDiff == 0 ? 0 : yDiff/abs(yDiff);

            this.move_to_location(xMovement, yMovement);
        }
        else {
            super.move();
        }
    }

    void display() {
        int drawXCoord = xCoord * columnWidth;
        int drawYCoord = yCoord * columnHeight;

        fill(255, 0, 0);
        rect(drawXCoord, drawYCoord, columnWidth, columnHeight);
    }

    void checkConditions() {
        ArrayList<Animal> neighbors = this.getNeighbors();
        Animal dinner = null;

        for(Animal animal : neighbors) {
            if(animal.type.equals("prey")) {
                dinner = animal;
            }
        }

        if(dinner != null) {
            world.removeAnimal(dinner.xCoord, dinner.yCoord);
        }
    }
}

class Prey extends Animal {
    Prey(int newXCoord, int newYCoord) {
        super(newXCoord, newYCoord);
        type = "prey";
    }

    Prey(int newXCoord, int newYCoord, int newSpeed) {
        super(newXCoord, newYCoord, newSpeed);
        type = "prey";
    }

    void display() {
        int drawXCoord = xCoord * columnWidth;
        int drawYCoord = yCoord * columnHeight;

        fill(0, 0, 255);
        rect(drawXCoord, drawYCoord, columnWidth, columnHeight);
    }

    void checkConditions() {
        ArrayList<Animal> neighbors = this.getNeighbors();
        Animal significant_other = null;
        int num_surrounding_prey = 0;

        for(Animal animal : neighbors) {
            if(animal.type.equals("prey") && animal != this) {
                num_surrounding_prey++;
                significant_other = animal;
            }
        }

        if(num_surrounding_prey >= prey_maximum_neighbors) {
            world.removeAnimal(xCoord, yCoord);
        }

        boolean successfull_courtship = int(random(prey_reproduction_factor)) == 0;
        if(significant_other != null &&  successfull_courtship) {
            int newSpeed = (speed + significant_other.speed)/2;
            newSpeed += int(random(prey_mutation_factor)) - (prey_mutation_factor/2);

            world.addAnimal(new Prey(xCoord, yCoord, newSpeed));
        }
    }
}
