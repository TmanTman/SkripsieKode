package matlaboperations;
import java.util.Arrays;

import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.MatlabProxyFactory;
import matlabcontrol.MatlabProxyFactoryOptions;
import matlabcontrol.extensions.MatlabNumericArray;
import matlabcontrol.extensions.MatlabTypeConverter;

public class MatlabOps
{
    public static double[] callMatlab(double[] arr_in) throws MatlabConnectionException, MatlabInvocationException {
    	// create proxy
        MatlabProxyFactoryOptions options =
           new MatlabProxyFactoryOptions.Builder()
               .setUsePreviouslyControlledSession(true)
               .build();
	    //Create a proxy, which we will use to control MATLAB
	    MatlabProxyFactory factory = new MatlabProxyFactory(options);
	    MatlabProxy proxy = factory.getProxy();

	     //send and receive an array from a m-file
	     double[] sendArr = {3, 4, 2};
	     Object[] recArray = proxy.returningFeval("myfunc", 1, sendArr);
	     recArray = (Object[])recArray[0];
	     double[] arr = (double[])recArray[0];
	     System.out.println("Array received from matlab: " + Arrays.toString(arr));

	    //Disconnect the proxy from MATLAB
	    proxy.disconnect();
	    return arr;
    }
}