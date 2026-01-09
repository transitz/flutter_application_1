class LivingThing{
  void breathe(){
    print("i am breathing.");
  }

  void move(){
    print("i am moving to ...");
  }
}

class Cat extends LivingThing{
  final String name;
  final String color;

  Cat(this.name, this.color);

  //Factory constructor is used for creating multiple new objects with the same attributes.
  //example: 10-20 times to create Cat class with the same name and/or color
  //factory Cat.massCats 
  
  void printAttribute(){
    print("Cat name is:" + name);
    print("Cat color is: " + color);
  }
}

void main(){
  final garfield = Cat("Garfield", "orange");
  garfield.printAttribute();
  garfield.breathe();
  garfield.move();
}