/*
 *  ClassTest
 *
 *  An arduino program that showcases that arduino can handle classes.
 *
 *
 *    2022 - Jakub Stachurski - github.com/Wilkuu-2
 *
 */

// -- Simple class that has a number you can retrieve or increment
class c_example {
  private:
    long m_bignum;

  //Constructor
  public:
    c_example() { 
      m_bignum = 0;
      Serial.println("Object constructed");
    }
    
    void inc_bignum() {
      m_bignum ++;
    }
    
    long get_bignum() {
      return m_bignum;
    }
};


c_example example_object; //Object allocated globally


// -- Entry 
void setup() {
  Serial.begin(9600);
  example_object = c_example();

}

// -- Loop 
void loop() {
  example_object.inc_bignum();
  Serial.println(" | " + String(example_object.get_bignum()));

}
