public class HelloWorld {
    public static void main(String[] args) {
        int count = 1;
        while (true) {  // Infinite loop to keep the application running
            System.out.println("Eagle Bird is soaring high! " + count);
            count++;
            try {
                Thread.sleep(5000);  // Print every 5 seconds
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
