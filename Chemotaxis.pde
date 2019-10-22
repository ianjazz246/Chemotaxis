 //declare bacteria variables here   

ArrayList<Bacteria> bacteriaList = new ArrayList<Bacteria>();

ArrayList<Food> foodList = new ArrayList<Food>();

 void setup()   
 {     
 	//initialize bacteria variables here   
 	size(400, 400);

 	for (int i = 0; i < 5; i++) {
 		foodList.add(new Food((int)(Math.random() * 400), (int)(Math.random() * 400), 10));
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

 	Bacteria (float x, float y, int size)
 	{
 		this.x = x;
 		this.y = y;
 		this.size = size;
 		this.clr = color(240, 20, 20);
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
 		float rangeMax = Math.max(0.5, 60 / (2 * this.size));
 		System.out.println(rangeMax);
 		float rangeMin = -rangeMax;

 		this.y += rangeMin + (rangeMax - rangeMin) * Math.random() * rangeMax;
 		this.x += rangeMin + (rangeMax - rangeMin) * Math.random() * rangeMax;
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

	@Override
	void move()
	{
		float moveSpeed = 30. / this.size;
 		//value to subtract from Math.random()to scale it evenly.
 		float shift = moveSpeed / 2.;

 		// System.out.println(moveSpeed);
 		// System.out.println(shift);
 		//System.out.println((int)(Math.random() * moveSpeed) - shift);

 		float rangeMax = Math.max(0.5, 60 / (2 * this.size));
 		System.out.println(rangeMax);
 		float rangeMin = -rangeMax;

 		// float rangeMin = -2.0;
 		// float rangeMax = 2.0;

 		this.x += rangeMin + (rangeMax - rangeMin) * Math.random() + Math.signum(mouseX - this.x) * rangeMax;
 		this.y += rangeMin + (rangeMax - rangeMin) * Math.random() + Math.signum(mouseY - this.y) * rangeMax; 
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

 	@Override
	void move()
	{
		double moveSpeed = 30. / this.size;
 		//value to subtract from Math.random()to scale it evenly.
 		double shift = moveSpeed / 2.;

 		if (dist(this.x, this.y, mouseX, mouseY) < 70)
 		{
 			// float rangeMin = -2.0;
 			// float rangeMax = 2.0;

 			float rangeMax = Math.max(0.5, 60 / (2 * this.size));
	 		float rangeMin = -rangeMax;

 			this.x += rangeMin + (rangeMax - rangeMin) * Math.random() - Math.signum(mouseX - this.x) * rangeMax;
 			this.y += rangeMin + (rangeMax - rangeMin) * Math.random() - Math.signum(mouseY - this.y) * rangeMax; 
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

 	@Override
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

			float rangeMax = Math.max(0.5, 60 / (2 * this.size));
	 		float rangeMin = -rangeMax;
	 		System.out.println(rangeMax);

 			this.x += rangeMin + (rangeMax - rangeMin) * Math.random() + Math.signum(this.targetedFood.getX() - this.x) * rangeMax;
 			this.y += rangeMin + (rangeMax - rangeMin) * Math.random() + Math.signum(this.targetedFood.getY() - this.y) * rangeMax; 

	 		this.keepInBounds();
 		}
 		else
 		{
 			super.move();
 		}

 	}

 	private Food findNewFood()
 	{
 		double minDist = Double.MAX_VALUE;
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