class Grid {
    int columns, rows;
    Animal spaces[][];
    ArrayList<Animal> animalList;

    Grid(int numColumns, int numRows) {
        spaces = new Animal[numColumns][numRows];
        columns = numColumns;
        rows = numRows;
        animalList = new ArrayList<Animal>();
    }

    void addAnimal(Animal newAnimal) {
        OrderedPair destination = getFreeSpace(newAnimal.xCoord, newAnimal.yCoord);

        if(destination == null) {
            return;
        }

        newAnimal.setCoordinates(destination.x, destination.y);
        spaces[destination.x][destination.y] = newAnimal;
        animalList.add(newAnimal);
    }

    void removeAnimal(int x, int y) {
        animalList.remove(spaces[x][y]);
        spaces[x][y] = null;
    }

    void display() {
        ArrayList<Animal> currentAnimals = new ArrayList<Animal>(animalList);
        for(Animal animal : currentAnimals) {
            animal.display();
        }
    }

    void move() {
        ArrayList<Animal> currentAnimals = new ArrayList<Animal>(animalList);
        for(Animal animal : currentAnimals) {
            animal.move();
        }
    }

    void checkConditions() {
        ArrayList<Animal> currentAnimals = new ArrayList<Animal>(animalList);
        for(Animal animal : currentAnimals) {
            animal.checkConditions();
        }
    }

    OrderedPair getFreeSpace(int x, int y) {
        if(spaces[x][y] == null) {
            return new OrderedPair(x, y);
        }

        ArrayList<OrderedPair> freeSpaces = new ArrayList<OrderedPair>();

        for(int i=-1; i<2; i++) {
            for(int j=-1; j<2; j++) {
                int testX = getValidX(x + i);
                int testY = getValidY(y + j);

                if(spaces[testX][testY] == null) {
                    freeSpaces.add(new OrderedPair(testX, testY));
                }
            }
        }

        if(freeSpaces.size() > 0) {
            int index = int(random(freeSpaces.size()));
            return freeSpaces.get(index);
        }

        return null;
    }
}
