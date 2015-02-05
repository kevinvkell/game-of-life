class Animal {
    int xCoord;
    int yCoord;
    String type;

    Animal(int newXCoord, int newYCoord) {
        xCoord = newXCoord;
        yCoord = newYCoord;
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

    void move() {
        int xMovement = int(random(3)) - 1;
        int yMovement = int(random(3)) - 1;

        world.removeAnimal(xCoord, yCoord);

        xCoord += xMovement;
        yCoord += yMovement;
        fixCoordinates();

        world.addAnimal(this);
    }

    void display() {
        int drawXCoord = xCoord * columnWidth;
        int drawYCoord = yCoord * columnHeight;

        fill(0, 0, 0);
        rect(drawXCoord, drawYCoord, columnWidth, columnHeight);
    }

    void checkConditions() {

    }
}

class Predator extends Animal {
    Predator(int newXCoord, int newYCoord) {
        super(newXCoord, newYCoord);
        type = "predator";
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
            if(animal.type == "prey") {
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
            if(animal.type == "prey" && animal != this) {
                num_surrounding_prey++;
                significant_other = animal;
            }
        }

        if(num_surrounding_prey >= overcrowding_factor) {
            world.removeAnimal(xCoord, yCoord);
        }

        boolean successfull_courtship = int(random(reproduction_factor)) == 0;
        if(significant_other != null &&  successfull_courtship) {
            world.addAnimal(new Prey(xCoord, yCoord));
        }
    }
}