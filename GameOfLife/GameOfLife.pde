int height = 500;
int width = 500;
int panel_width = 200;
int gNumColumns = 50;
int gNumRows = 50;
int columnWidth = width/gNumColumns;
int columnHeight = height/gNumRows;

int prey_reproduction_factor;
int prey_maximum_neighbors;
int prey_smell_radius;
int predator_smell_radius;
int prey_mutation_factor;

float average_prey_speed;
int slowest_prey_speed;
int animals_eaten;

Grid world;
DataManager dataManager;

void setup() {
    size(width + panel_width, height);
    world = new Grid(gNumColumns, gNumRows);
    dataManager = new DataManager();

    configure();
    initializeAnimals();
    run_generation();
}

void draw() {
    if(mousePressed) {
        run_generation();
    }
}

void keyPressed() {
    if(key == RETURN || key == ENTER) {
        run_generation();
    }
}

void run_generation() {
    background(255);
    rect(width, height, panel_width, height);
    world.move();
    world.display();
    world.checkConditions();
    dataManager.compile_data(world);
    dataManager.display_data();
    dataManager.end_cycle();
}

void configure() {
    JSONObject config = loadJSONObject("config.json");

    width = config.getInt("width");
    height = config.getInt("height");
    columnWidth = width/gNumColumns;
    columnHeight = height/gNumRows;

    gNumColumns = config.getInt("num_columns");
    gNumRows = config.getInt("num_rows");
    columnWidth = width/gNumColumns;
    columnHeight = height/gNumRows;

    prey_reproduction_factor = config.getInt("prey_reproduction_factor");
    prey_maximum_neighbors = config.getInt("prey_maximum_neighbors");
    prey_smell_radius = config.getInt("prey_smell_radius");
    predator_smell_radius = config.getInt("predator_smell_radius");
    prey_mutation_factor = config.getInt("prey_mutation_factor");
}

void initializeAnimals() {
    JSONArray data = loadJSONArray("initial_animals.json");

    for(int i=0; i<data.size(); i++) {
        JSONObject object = data.getJSONObject(i);
        if(object.getString("type").equals("prey")) {
            world.addAnimal(new Prey(object.getInt("xCoord"), object.getInt("yCoord"), object.getInt("speed")));
        }
        if(object.getString("type").equals("predator")) {
            world.addAnimal(new Predator(object.getInt("xCoord"), object.getInt("yCoord"), object.getInt("speed")));
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
