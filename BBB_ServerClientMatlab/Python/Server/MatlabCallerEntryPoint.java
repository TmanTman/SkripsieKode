//University of Stellenbosch
//Faculty Engineering 
//Department of Electrics and Electronics Engineering
//Skripsie
//Author: Tielman Nieuwoudt
//Date of first revision: 2 Oct 2013

import py4j.GatewayServer;

public class MatlabCallerEntryPoint {

    private MatlabCaller matlabCaller;

    public MatlabCallerEntryPoint() {
      matlabCaller = new MatlabCaller();
    }

    public MatlabCaller getMatlabCaller() {
        return matlabCaller;
    }

    public static void main(String[] args) {
        GatewayServer gatewayServer = new GatewayServer(new MatlabCallerEntryPoint());
        gatewayServer.start();
        System.out.println("Gateway Server Started");
    }

}