//University of Stellenbosch
//Faculty Engineering 
//Department of Electrics and Electronics Engineering
//Skripsie
//Author: Tielman Nieuwoudt
//Date of first revision: 2 Oct 2013

import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.MatlabProxyFactory;
import matlabcontrol.MatlabProxyFactoryOptions;

public class RequestMatlab {

/**
 * @param args
 */
public static int[] callOpt() throws MatlabConnectionException, MatlabInvocationException
	{
		// Proxy options
        MatlabProxyFactoryOptions options =
            new MatlabProxyFactoryOptions.Builder()
                .setUsePreviouslyControlledSession(true)
                .build();
		//Create a proxy, which we will use to control MATLAB
		MatlabProxyFactory factory = new MatlabProxyFactory();
		MatlabProxy proxy = factory.getProxy();

		// Add path to file in Matlab
        proxy.eval("addpath('C:\\Users\\T Nieuwoudt\\My Documents\\GitHub\\SkripsieKode\\BBB_ServerClientMatlab\\Python\\Server')");
		//Test calling a m file with an argument
		Object[] out = proxy.returningFeval("myfunc3", 1);
		out = (Object[])out[0];
		double[] temp = (double[])out[0];
		//Loop is the slow but only way to convert to int array
		final int[] retVal = new int[temp.length];
		System.out.println("Requested values from Matlab");
		for (int i = 0; i < retVal.length; ++i){
			retVal[i] = (int) temp[i];
			System.out.println("Index: " + i + " Value: " + retVal[i]);
		}
		//Remove path to file from Matlab
        proxy.eval("rmpath('C:\\Users\\T Nieuwoudt\\My Documents\\GitHub\\SkripsieKode\\BBB_ServerClientMatlab\\Python\\Server')");

		//Disconnect the proxy from MATLAB
		proxy.disconnect();
		return retVal;
	}
public static int[] test() throws MatlabConnectionException, MatlabInvocationException
	{
		double[] temp = {5.4, 3.2, 5.2, 5.2, 6.5};
		//Loop is the slow but only way to convert to int array
		final int[] intArray = new int[temp.length];
		for (int i = 0; i < intArray.length; ++i){
			intArray[i] = (int) temp[i];
			System.out.println("Index: " + i + " Value: " + intArray[i]);
		}
		return intArray;
	}
	
public static void main (String[] args) throws MatlabConnectionException, MatlabInvocationException
	{
		// Proxy options
        MatlabProxyFactoryOptions options =
            new MatlabProxyFactoryOptions.Builder()
                .setUsePreviouslyControlledSession(true)
                .build();
		//Create a proxy, which we will use to control MATLAB
		MatlabProxyFactory factory = new MatlabProxyFactory();
		MatlabProxy proxy = factory.getProxy();

		// Add path to file in Matlab
        proxy.eval("addpath('C:\\Users\\T Nieuwoudt\\My Documents\\GitHub\\SkripsieKode\\BBB_ServerClientMatlab\\Python\\Server')");
		//Test calling a m file with an argument
		Object[] out = proxy.returningFeval("myfunc3", 1);
		out = (Object[])out[0];
		double[] temp = (double[])out[0];
		//Loop is the slow but only way to convert to int array
		final int[] retVal = new int[temp.length];
		System.out.println("Requested values from Matlab");
		for (int i = 0; i < retVal.length; ++i){
			retVal[i] = (int) temp[i];
			System.out.println("Index: " + i + " Value: " + retVal[i]);
		}
		//Remove path to file from Matlab
        proxy.eval("rmpath('C:\\Users\\T Nieuwoudt\\My Documents\\GitHub\\SkripsieKode\\BBB_ServerClientMatlab\\Python\\Server')");

		//Disconnect the proxy from MATLAB
		proxy.disconnect();
	}
	
}
