import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxyFactory;
import matlabcontrol.MatlabProxy;

public class HelloMatlab{	
	public static void main(String[] args) throws MatlabConnectionException, MatlabInvocationException{
		//Create a proxy, which we will use to control MATLAB
		MatlabProxyFactory factory = new MatlabProxyFactory();
		MatlabProxy proxy = factory.getProxy();

		//Display 'hello world' just like when using the demo
		proxy.eval("disp('hello matlab')");

		//Disconnect the proxy from MATLAB
		proxy.disconnect();
	}
}