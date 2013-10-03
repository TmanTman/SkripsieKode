//University of Stellenbosch
//Faculty Engineering 
//Department of Electrics and Electronics Engineering
//Skripsie
//Author: Tielman Nieuwoudt
//Date of first revision: 2 Oct 2013

import java.util.LinkedList;
import java.util.List;

public class MatlabCaller {
//Tydelike comments terwyl Java/Python array sending getoets word
	public static int[] requestSchedule(){
		int[] retVal = new int[5];
		try {
			retVal = RequestMatlab.callOpt();
		} catch (Exception e) {
			System.out.println("Error: " + e.toString());
		}
		return retVal;
	}
	
	//Test function to test python array receive capability
	//public static int[] getArray(){
	//	int[] retVal = {1, 2, 5, 3, 5};
	//	return retVal;
	//	}
}