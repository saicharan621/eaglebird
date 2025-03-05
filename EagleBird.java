public class EagleBird {
    public static void main(String[] args) {
        for (int i = 1; i <= 5; i++) {
            System.out.println("Eagle Bird is soaring high! " + i);
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
