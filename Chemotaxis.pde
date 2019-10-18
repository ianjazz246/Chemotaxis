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

 	for (int i = 0; i < 5; i++) {
 		switch((int)(Math.random() * 4)) {
 			case 0:
 				bacteriaList.add(new MouseFollowBacteria(width / 2, height / 2, 15));
 				break;
 			case 1: case 2:
 				bacteriaList.add(new Bacteria(width / 2, height / 2, 15));
 				break;
 			case 3:
 				bacteriaList.add(new FoodFollowBacteria(width / 2, height / 2, 15));
 		}
 		
 	}


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

class Bacteria    
{       
 	int x, y;
 	int clr;
 	int size;

 	Bacteria (int x, int y, int size)
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

 		this.y += (int)(Math.random() * 5) - 2;
 		this.x += (int)(Math.random() * 5) - 2;
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
	MouseFollowBacteria (int x, int y, int size)
 	{
 		super(x, y, size);
 		this.clr = color(20, 240, 20);
 	}

	@Override
	void move()
	{
		double moveSpeed = 30. / this.size;
 		//value to subtract from Math.random()to scale it evenly.
 		int shift = (int)(moveSpeed / 2);

 		// System.out.println(moveSpeed);
 		// System.out.println(shift);
 		//System.out.println((int)(Math.random() * moveSpeed) - shift);

 		this.y += (int)(Math.random() * 5) - 2 + Integer.signum(mouseY - this.y);
		this.x += (int)(Math.random() * 5) - 2 + Integer.signum(mouseX - this.x);
	}
} 

class FoodFollowBacteria extends Bacteria
{
	Food targetedFood;
	FoodFollowBacteria (int x, int y, int size)
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



			this.x += (int)(Math.random() * 5) - 2 + Integer.signum(this.targetedFood.getX() - this.x);
	 		this.y += (int)(Math.random() * 5) - 2 + Integer.signum(this.targetedFood.getY() - this.y);
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
	int x, y, nutrition;
	boolean eaten;
	Food(int x, int y, int nutrition)
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

	int getX() {
		return this.x;
	}

	int getY() {
		return this.y;
	}
}