import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Project1 extends PApplet {

int height = 500;
int width = 500;
int gNumColumns = 50;
int gNumRows = 50;
int columnWidth = width/gNumColumns;
int columnHeight = height/gNumRows;
int reproduction_factor;
int overcrowding_factor;
Grid world;

public void setup() {
    size(width, height);
    world = new Grid(gNumColumns, gNumRows);

    configure();
    initializeAnimals();
}

public void draw() {
    background(255);
    world.move();
    world.display();
    world.checkConditions();
}

public void configure() {
    JSONObject config = loadJSONObject("config.json");

    reproduction_factor = config.getInt("reproduction_factor");
    overcrowding_factor = config.getInt("overcrowding_factor");
}

public void initializeAnimals() {
    JSONArray data = loadJSONArray("initial_animals.json");

    for(int i=0; i<data.size(); i++) {
        JSONObject object = data.getJSONObject(i);
        if(object.getString("type").equals("prey")) {
            world.addAnimal(new Prey(object.getInt("xCoord"), object.getInt("yCoord")));
        }
        if(object.getString("type").equals("predator")) {
            world.addAnimal(new Predator(object.getInt("xCoord"), object.getInt("yCoord")));
        }
    }
}

class OrderedPair {
    int x;
    int y;

    OrderedPair(int newX, int newY) {
        x = newX;
        y = newY;
    }
}

public int getValidX(int questionableX) {
    int newX = questionableX;

    if(questionableX >= gNumColumns) {
        newX = gNumColumns - 1;
    }
    if(questionableX < 0) {
        newX = 0;
    }

    return newX;
}

public int getValidY(int questionableY) {
    int newY = questionableY;

    if(questionableY >= gNumRows) {
        newY = gNumRows - 1;
    }
    if(questionableY < 0) {
        newY = 0;
    }

    return newY;
}
class Animal {
    int xCoord;
    int yCoord;
    String type;

    Animal(int newXCoord, int newYCoord) {
        xCoord = newXCoord;
        yCoord = newYCoord;
    }

    public void setCoordinates(int newXCoord, int newYCoord) {
        xCoord = newXCoord;
        yCoord = newYCoord;
    }

    public void fixCoordinates() {
        xCoord = getValidX(xCoord);
        yCoord = getValidY(yCoord);
    }

    public boolean isAdjacent(Animal otherAnimal) {
        if((otherAnimal.xCoord <= xCoord + 1) && (otherAnimal.xCoord >= xCoord - 1)) {
            if((otherAnimal.yCoord <= yCoord + 1) && (otherAnimal.yCoord >= yCoord - 1)) {
                return true;
            }
        }

        return false;
    }

    public ArrayList<Animal> getNeighbors() {
        ArrayList<Animal> result = new ArrayList<Animal>();

        for(Animal currentAnimal : world.animalList) {
            if(this.isAdjacent(currentAnimal)) {
                result.add(currentAnimal);
            }
        }

        return result;
    }

    public void move() {
        int xMovement = PApplet.parseInt(random(3)) - 1;
        int yMovement = PApplet.parseInt(random(3)) - 1;

        world.removeAnimal(xCoord, yCoord);

        xCoord += xMovement;
        yCoord += yMovement;
        fixCoordinates();

        world.addAnimal(this);
    }

    public void display() {
        int drawXCoord = xCoord * columnWidth;
        int drawYCoord = yCoord * columnHeight;

        fill(0, 0, 0);
        rect(drawXCoord, drawYCoord, columnWidth, columnHeight);
    }

    public void checkConditions() {

    }
}

class Predator extends Animal {
    Predator(int newXCoord, int newYCoord) {
        super(newXCoord, newYCoord);
        type = "predator";
    }

    public void display() {
        int drawXCoord = xCoord * columnWidth;
        int drawYCoord = yCoord * columnHeight;

        fill(255, 0, 0);
        rect(drawXCoord, drawYCoord, columnWidth, columnHeight);
    }

    public void checkConditions() {
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

    public void display() {
        int drawXCoord = xCoord * columnWidth;
        int drawYCoord = yCoord * columnHeight;

        fill(0, 0, 255);
        rect(drawXCoord, drawYCoord, columnWidth, columnHeight);
    }

    public void checkConditions() {
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

        boolean successfull_courtship = PApplet.parseInt(random(reproduction_factor)) == 0;
        if(significant_other != null &&  successfull_courtship) {
            world.addAnimal(new Prey(xCoord, yCoord));
        }
    }
}
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

    public void addAnimal(Animal newAnimal) {
        OrderedPair destination = getFreeSpace(newAnimal.xCoord, newAnimal.yCoord);

        if(destination == null) {
            return;
        }

        newAnimal.setCoordinates(destination.x, destination.y);
        spaces[destination.x][destination.y] = newAnimal;
        animalList.add(newAnimal);
    }

    public void removeAnimal(int x, int y) {
        animalList.remove(spaces[x][y]);
        spaces[x][y] = null;
    }

    public void display() {
        for(int i=0; i<columns; i++) {
            for(int j=0; j<rows; j++) {
                Animal currentCell = spaces[i][j];

                if(currentCell != null) {
                    currentCell.display();
                }
            }
        }
    }

    public void move() {
        for(int i=0; i<columns; i++) {
            for(int j=0; j<rows; j++) {
                Animal currentCell = spaces[i][j];

                if(currentCell != null) {
                    currentCell.move();
                }
            }
        }
    }

    public void checkConditions() {
        // for(int i=0; i<columns; i++) {
        //     for(int j=0; j<rows; j++) {
        //         Animal currentCell = spaces[i][j];

        //         if(currentCell != null) {
        //             currentCell.checkConditions();
        //         }
        //     }
        // }

        ArrayList<Animal> currentAnimals = new ArrayList<Animal>(animalList);
        for(Animal animal : currentAnimals) {
            animal.checkConditions();
        }
    }

    public OrderedPair getFreeSpace(int x, int y) {
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
            int index = PApplet.parseInt(random(freeSpaces.size()));
            return freeSpaces.get(index);
        }

        return null;
    }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Project1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
