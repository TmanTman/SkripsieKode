package client;
import java.io.*;

public class ClientListenThread implements Runnable {
	String lineFromServer = null;
	BufferedReader in = null;

	public ClientListenThread (BufferedReader ServerIn){
		this.in = ServerIn;
	}

	public void run(){
		while(true){
			try {
				if ((lineFromServer = in.readLine()) != null){
					System.out.println("Server: " + lineFromServer);
				}
			} catch (IOException e) {
				System.out.println("Error encountered in ClientListenThread: " + e.toString());
				break;
			}
		}
	}
}


