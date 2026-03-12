public class NewStack {
    List<Object> a=new List<Object>();
    public void push(Object obj) {
        if(a.size()<1){
            this.a.add(obj);
        }
        else{
        this.a.add(0,obj);
        }

        //implement push
    }
    
    public Object pop() {
        if(this.a.size()<1){
            return null;

        }
        else{
        Object temp=a.get(0);
            this.a.remove(0);
                 return temp;
        }
        
        
   


        //implement pop
    }
    
    public Integer size() {
        return this.a.size();
        //implement size
    }
    
    public Object peek(){
        return (this.a.size()>0? this.a.get(0):null);
        //implement peek
    }
    
    public Boolean isEmpty() {
      if(this.a.size()>0)
            return false;
        return true;
        //implement isEmpty
    }
}