class DataManager {
    float average_prey_speed;
    int slowest_prey_speed;
    int animals_eaten;
    float moving_animals_eaten;
    int max_animals_eaten = 0;
    int window = 50;
    int counter = 0;
    float speed_history[] = new float[window];
    int animals_eaten_history[] = new int[window];

    DataManager() {
        animals_eaten = 0;
    }

    void log_dinner() {
        animals_eaten++;
    }

    void compile_data(Grid currentWorld) {
        int total_prey_speed = 0;
        int num_prey = 0;
        int tmp_slowest_prey_speed = 0;

        for(Animal animal : currentWorld.animalList) {
            if(animal.type.equals("prey")) {
                total_prey_speed += animal.speed;
                num_prey++;
                if(animal.speed > tmp_slowest_prey_speed) {
                    tmp_slowest_prey_speed = animal.speed;
                }
            }
        }

        slowest_prey_speed = tmp_slowest_prey_speed;
        average_prey_speed = float(total_prey_speed)/float(num_prey);
    }

    void end_cycle() {
        this.move_average();
        if(max_animals_eaten < moving_animals_eaten) {
            max_animals_eaten = int(moving_animals_eaten);
        }
        animals_eaten = 0;
    }

    void display_data() {
        int speed_bar_height = 0;
        if(average_prey_speed != 0) {
            speed_bar_height = int(height * (1.0/pow(average_prey_speed, 0.5)));
        }

        int eaten_bar_height = 0;
        if(moving_animals_eaten != 0) {
            eaten_bar_height = int(height * (moving_animals_eaten/max_animals_eaten));
            print("bar height: ", eaten_bar_height, '\n');
        }

        fill(55);
        rect(width, height - speed_bar_height, panel_width/2, speed_bar_height);

        textSize(16);
        fill(255);
        text(average_prey_speed, int(width + panel_width/8.0), int(height - speed_bar_height/4.0));

        fill(120);
        rect(width + panel_width/2, height - eaten_bar_height, panel_width/2, eaten_bar_height);

        textSize(16);
        fill(255);
        text(moving_animals_eaten, int(width + panel_width/2.0), int(height - eaten_bar_height/4.0));
    }

    void move_average() {
        int sum = 0;

        animals_eaten_history[counter] = animals_eaten;
        print("added ", animals_eaten, "\n");

        if(++counter >= window) {
            counter = 0;
        }

        for(int i=0; i<window; i++) {
            sum += animals_eaten_history[i];
        }

        print("sum: ", sum, "\n");
        moving_animals_eaten = sum;
    }
}