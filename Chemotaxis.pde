 //declare bacteria variables here   

ArrayList<Bacteria> bacteriaList = new ArrayList<Bacteria>();

 void setup()   
 {     
 	//initialize bacteria variables here   
 	size(400, 400);
 	for (int i = 0; i < 5; i++) {
 		bacteriaList.add(new Bacteria(width / 2, height / 2, color((int)(Math.random() * 256)), 5));
 	}
 }   
 void draw()   
 {    
 	//move and show the bacteria   
 	for (Bacteria bacteria : bacteriaList)
 	{
 		bacteria.move();
 		bacteria.show();
 	}
 }  
 class Bacteria    
 {     
 	//lots of java!   
 	int x, y;
 	color clr;
 	int size;

 	Bacteria (int x, int y, color clr, int size)
 	{
 		this.x = x;
 		this.y = y;
 		this.clr = clr;
 		this.size = size;
 	}


 	void show()
 	{
 		fill(this.clr);
 		ellipse(this.x, this.y, this.size, this.size);
 	}

 	void move()
 	{
 		this.x += (int)(Math.random() * 3 - 1);
 		this.y += (int)(Math.random() * 3 - 1);
 	}
 }    