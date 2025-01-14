 //declare bacteria variables here   

ArrayList<Bacteria> bacteriaList = new ArrayList<Bacteria>();

ArrayList<Food> foodList = new ArrayList<Food>();

 void setup()   
 {     
 	//initialize bacteria variables here   
 	size(400, 400);

 	for (int i = 0; i < 5; i++) {
 		foodList.add(new Food((int)(Math.random() * width), (int)(Math.random() * height), 10));
 	}

 	for (int i = 0; i < 7; i++) {
 		addNewBacteria();
 	}


 }

 Bacteria addNewBacteria()
 {
 	Bacteria newBacteria;
 	double rand = Math.random();


 	if (rand < 0.2)
 	{
 		newBacteria = new MouseFollowBacteria(width / 2, height / 2, 15);
 	}
 	else if (rand < 0.6)
 	{
 		newBacteria = new Bacteria(width / 2, height / 2, 15);
 	}
 	else if (rand < 0.8)
 	{
 		newBacteria = new FoodFollowBacteria(width / 2, height / 2, 15);
 	}
 	else
 	{
 		newBacteria = new MouseRepelBacteria(width / 2, height / 2, 15);
 	}
	bacteriaList.add(newBacteria);
	return newBacteria;
 } 

 void draw()   
 {   
 	background(125); 
 	//move and show the bacteria   
 	for (Bacteria bacteria : bacteriaList)
 	{
 		bacteria.move();
 		bacteria.eat();
 		bacteria.show();

 	}

 	for (int i = 0; i < foodList.size(); i++) {
 		Food food = foodList.get(i);
 		if (food.getEaten())
 		{
 			foodList.remove(i);
 		}
 		else
 		{
 			food.show();
 		}
 	}

 	//randomly add more food if less than 8 food
 	if (foodList.size() < 8) {
 		if (Math.random() < 0.05) {
	 		foodList.add(new Food((int)(Math.random() * 400), (int)(Math.random() * 400), 10));
	 	}
 	}
 	
 }  

 void mouseClicked()
 {
 	addNewBacteria();
 }

class Bacteria    
{       
 	float x, y;
 	int clr;
 	int size;

 	static final float START_SPEED = 3.75; //speed at nutrition 0. Bacteria start at nutrition 15
 	static final float SPEED_DECREASE_FACTOR = 20; //multiplier for speed decrease per nutrition

 	Bacteria (float x, float y, int size)
 	{
 		this.x = x;
 		this.y = y;
 		this.size = size;
 		this.clr = color(240, 240, 240);
 	}


 	void show()
 	{
 		fill(this.clr);
 		ellipse(this.x, this.y, this.size, this.size);
 	}

 	void move()
 	{

 		int moveSpeed = this.size / 3;
 		//value to subtract from Math.random()to scale it evenly.
 		int shift = moveSpeed / 2;

 		//this.y += Math.random() * 5.0 - 2.0;
 		float rangeMax = Math.max(0.5, Bacteria.START_SPEED - this.size / Bacteria.SPEED_DECREASE_FACTOR);
 		float rangeMin = -rangeMax;

 		this.y += rangeMin + (rangeMax - rangeMin) * Math.random();
 		this.x += rangeMin + (rangeMax - rangeMin) * Math.random();
 		this.keepInBounds();
 		
 	}

 	void keepInBounds() {
 		if (this.x > 400)
 		{
 			this.x = 400;
 		}
 		else if (this.x < 0)
 		{
 			this.x = 0;
 		}

 		if (this.y > 400)
 		{
 			this.y = 400;
 		}
 		else if (this.y < 0)
 		{
 			this.y = 0;
 		}
 	}

 	void eat()
 	{
 		for (int i = 0; i < foodList.size(); i++)
 		{
 			Food food = foodList.get(i);
 			if (dist(food.getX(), food.getY(), this.x, this.y) < this.size / 2 + food.nutrition / 2)
 			{
 				this.size += food.eat() / 5;
 			}
 		}
 	}
 }    

class MouseFollowBacteria extends Bacteria
{
	MouseFollowBacteria (float x, float y, int size)
 	{
 		super(x, y, size);
 		this.clr = color(20, 240, 20);
 	}

	void move()
	{
		float moveSpeed = 30. / this.size;
 		//value to subtract from Math.random()to scale it evenly.
 		float shift = moveSpeed / 2.;

 		// System.out.println(moveSpeed);
 		// System.out.println(shift);
 		//System.out.println((int)(Math.random() * moveSpeed) - shift);

 		float rangeMax = Math.max(0.5, Bacteria.START_SPEED - this.size / Bacteria.SPEED_DECREASE_FACTOR);
 		float rangeMin = -rangeMax;

 		// float rangeMin = -2.0;
 		// float rangeMax = 2.0;

 		this.x += rangeMin + (rangeMax - rangeMin) * Math.random() + sigNum(mouseX - this.x) * rangeMax;
 		this.y += rangeMin + (rangeMax - rangeMin) * Math.random() + sigNum(mouseY - this.y) * rangeMax; 
		this.keepInBounds();
	}
}

class MouseRepelBacteria extends Bacteria
{
	MouseRepelBacteria (float x, float y, int size)
 	{
 		super(x, y, size); 
 		this.clr = color(20, 240, 240);
 	}

 	
	void move()
	{
		double moveSpeed = 30. / this.size;
 		//value to subtract from Math.random()to scale it evenly.
 		double shift = moveSpeed / 2.;

 		if (dist(this.x, this.y, mouseX, mouseY) < 70)
 		{
 			// float rangeMin = -2.0;
 			// float rangeMax = 2.0;

 			float rangeMax = Math.max(0.5, Bacteria.START_SPEED - this.size / Bacteria.SPEED_DECREASE_FACTOR);
	 		float rangeMin = -rangeMax;

 			this.x += rangeMin + (rangeMax - rangeMin) * Math.random() - sigNum(mouseX - this.x) * rangeMax;
 			this.y += rangeMin + (rangeMax - rangeMin) * Math.random() - sigNum(mouseY - this.y) * rangeMax; 
 		}
 		else
 		{
 			super.move();
 		}

 		this.keepInBounds();
	}

}

class FoodFollowBacteria extends Bacteria
{
	Food targetedFood;
	FoodFollowBacteria (float x, float y, int size)
 	{
 		super(x, y, size);
 		this.clr = color(20, 20, 240);
 		this.findNewFood();
 	}

 	
 	void move() {
 		if (this.targetedFood != null)
 		{
 			if (this.targetedFood.getEaten())
	 		{
	 			findNewFood();
	 			if (this.targetedFood == null) {
	 				super.move();
	 				return;
	 			}
	 		}

	 		// float rangeMin = -2.0;
 			// float rangeMax = 2.0;

			float rangeMax = Math.max(0.5, Bacteria.START_SPEED - this.size / Bacteria.SPEED_DECREASE_FACTOR);
	 		float rangeMin = -rangeMax;

 			this.x += rangeMin + (rangeMax - rangeMin) * Math.random() + sigNum(this.targetedFood.getX() - this.x) * rangeMax;
 			this.y += rangeMin + (rangeMax - rangeMin) * Math.random() + sigNum(this.targetedFood.getY() - this.y) * rangeMax; 

	 		this.keepInBounds();
 		}
 		else
 		{
 			super.move();
 		}

 	}

 	Food findNewFood()
 	{
 		double minDist = 999999999.;
 		if (foodList.size() < 1) {
 			this.targetedFood = null;
 			return null;
 		}
 		for (Food food : foodList)
 		{
 			double currDist = dist(this.x, this.y, food.getX(), food.getY());
 			if (currDist < minDist) {
 				this.targetedFood = food;
 				minDist = currDist;
 			}
 		}
 		return this.targetedFood;
 	}
}

class Food
{
	float x, y;
	int nutrition;
	boolean eaten;
	Food(float x, float y, int nutrition)
	{
		this.x = x;
		this.y = y;
		this.nutrition = nutrition;
		eaten = false;
	}

	void show()
	{
		fill(115, 96, 46);
		ellipse(this.x, this.y, this.nutrition, this.nutrition);
	}

	int eat()
	{
		eaten = true;
		return nutrition;
	}

	boolean getEaten()
	{
		return eaten;
	}

	float getX() {
		return this.x;
	}

	float getY() {
		return this.y;
	}
}

float sigNum(float n)
{
	if (n > 0)
	{
		return 1;
	}
	else if (n < 0)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}