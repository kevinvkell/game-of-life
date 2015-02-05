int height = 500;
int width = 500;
int gNumColumns = 50;
int gNumRows = 50;
int columnWidth = width/gNumColumns;
int columnHeight = height/gNumRows;
int reproduction_factor;
int overcrowding_factor;
Grid world;

void setup() {
    size(width, height);
    world = new Grid(gNumColumns, gNumRows);

    configure();
    initializeAnimals();
}

void draw() {
    background(255);
    world.move();
    world.display();
    world.checkConditions();
}

void configure() {
    JSONObject config = loadJSONObject("config.json");

    reproduction_factor = config.getInt("reproduction_factor");
    overcrowding_factor = config.getInt("overcrowding_factor");
}

void initializeAnimals() {
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

int getValidX(int questionableX) {
    int newX = questionableX;

    if(questionableX >= gNumColumns) {
        newX = gNumColumns - 1;
    }
    if(questionableX < 0) {
        newX = 0;
    }

    return newX;
}

int getValidY(int questionableY) {
    int newY = questionableY;

    if(questionableY >= gNumRows) {
        newY = gNumRows - 1;
    }
    if(questionableY < 0) {
        newY = 0;
    }

    return newY;
}
