import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxyFactory;
import matlabcontrol.MatlabProxy;
import matlabcontrol.MatlabTypeConverter;
import matlabcontrol.MatlabNumericArray;

public class HelloMatlab{	
	public static void main(String[] args) throws MatlabConnectionException, MatlabInvocationException{
    //Create a proxy, which we will use to control MATLAB
    MatlabProxyFactory factory = new MatlabProxyFactory();
    MatlabProxy proxy = factory.getProxy();

    //Create a 4x3x2 array filled with random values
    proxy.eval("array = randn(4,3,2)");

    //Print a value of the array into the MATLAB Command Window
    proxy.eval("disp(['entry: ' num2str(array(3, 2, 1))])");

    //Get the array from MATLAB
    MatlabTypeConverter processor = new MatlabTypeConverter(proxy);
    MatlabNumericArray array = processor.getNumericArray("array");
    
    //Print out the same entry, using Java's 0-based indexing
    System.out.println("entry: " + array.getRealValue(2, 1, 0));
    
    //Convert to a Java array and print the same value again    
    double[][][] javaArray = array.getRealArray3D();
    System.out.println("entry: " + javaArray[2][1][0]);

    //Disconnect the proxy from MATLAB
    proxy.disconnect();
	}
}