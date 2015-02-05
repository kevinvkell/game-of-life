class DataManager {
    float average_prey_speed;
    float moving_average_prey_speed;
    int slowest_prey_speed;
    int animals_eaten;
    int window = 10;
    int counter = 0;
    float speed_history[] = new float[window];

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
        animals_eaten = 0;
        this.move_average(average_prey_speed);
    }

    void display_data() {
        print("average: ", average_prey_speed, "\n");
        print("slowest: ", slowest_prey_speed, "\n");
        print("moving: ", moving_average_prey_speed, "\n");
        int bar_height = 0;
        if(average_prey_speed != 0) {
            bar_height = int(height * (1.0/pow(average_prey_speed, 0.5)));
            print("bar height: ", bar_height, '\n');
        }

        fill(55);
        rect(width, height - bar_height, panel_width, bar_height);

        textSize(32);
        fill(255);
        text(average_prey_speed, int(width + panel_width/4.0), int(height - bar_height/4.0)); 
    }

    void move_average(float new_item) {
        float sum = 0;

        speed_history[counter] = new_item;
        if(++counter >= window) {
            counter = 0;
        }

        for(int i=0; i<window; i++){
            sum += speed_history[i];
        }

        moving_average_prey_speed = sum/window;
    }
}