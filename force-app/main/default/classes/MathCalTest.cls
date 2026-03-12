@isTest
public class MathCalTest{

@isTest
    public static void MathCalTest(){
        
        
        MathCal a=new MathCal();
         Integer add=a.add();
         
         Integer mul=a.mult();
        System.assertEquals(3,add,'value is not matching for add');
        Integer sub=a.sub();
         System.assertEquals(1,sub,'value is not matching for sub');
    }
    
}