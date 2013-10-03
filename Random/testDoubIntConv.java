class testDoubIntConv {
	public static void main (String[] args) {
		double[] temp = {5.4, 3.2, 5.2, 5.2, 6.5};
		//Loop is the slow but only way to convert to int array
		final int[] intArray = new int[temp.length];
		for (int i = 0; i < intArray.length; ++i){
			intArray[i] = (int) temp[i];
			System.out.println("Index: " + i + " Value: " + intArray[i]);
		}
	}		
}