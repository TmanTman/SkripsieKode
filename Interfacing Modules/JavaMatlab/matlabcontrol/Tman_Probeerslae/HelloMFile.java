import matlabcontrol.*;
import java.util.Arrays;

public class HelloMFile
{
    public static void main(String[] args)
        throws MatlabConnectionException, MatlabInvocationException
    {
         // create proxy
         MatlabProxyFactoryOptions options =
            new MatlabProxyFactoryOptions.Builder()
                .setUsePreviouslyControlledSession(true)
                .build();
        MatlabProxyFactory factory = new MatlabProxyFactory(options);
        MatlabProxy proxy = factory.getProxy();

        // call builtin function
        proxy.eval("disp('hello world')");
		
		//set the variables in the Matlab environment
		proxy.setVariable("a", 5);

        // call user-defined function (must be on the path)
        proxy.eval("addpath('C:\\Users\\T Nieuwoudt\\My Documents\\Try_MatlabConnect_Mfile')");
        //Test calling a standard matlab function
		proxy.feval("disp", "Hello from argument called function");
		//Test calling a m file with an argument
		proxy.feval("myfunc", "Hello, from argument called custom function");
		//Test calling a m file and receiving a value
        proxy.eval("rmpath('C:\\Users\\T Nieuwoudt\\My Documents\\Try_MatlabConnect_Mfile')");
		
		//read the modified variables from the matlab environment
		double result = ((double[])proxy.getVariable("a"))[0];
		System.out.println("Matlab changed the value of a to: " + result);

        // close connection
        proxy.disconnect();
    }
}