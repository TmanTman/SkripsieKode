package client;
import java.io.*;

public class ClientWriteThread implements Runnable {
	PrintWriter out = null;
	String lineFromUser = null;
	BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));

	public ClientWriteThread (PrintWriter printToServer){
		this.out = printToServer;
	}

	public void run(){
		while(true){
			try {
				lineFromUser = stdIn.readLine();
				if (lineFromUser != null){
					System.out.println("Sent to server: " + lineFromUser);
					out.println(lineFromUser);
				}
			} catch (IOException e) {
				System.out.println("Error encountered in ClientWriteThread: " + e.toString());
			}
		}
	}
}
