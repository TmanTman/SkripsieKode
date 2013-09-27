package server;
/*

* Copyright (c) 1995, 2008, Oracle and/or its affiliates. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*
* - Redistributions of source code must retain the above copyright
* notice, this list of conditions and the following disclaimer.
*
* - Redistributions in binary form must reproduce the above copyright
* notice, this list of conditions and the following disclaimer in the
* documentation and/or other materials provided with the distribution.
*
* - Neither the name of Oracle or the names of its
* contributors may be used to endorse or promote products derived
* from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;

public class ServerThread extends Thread{
    private Socket socket = null;
    //Receives from Server a list of all threads running
    private ArrayList<ServerThread> cl = null;
    public int id = 0;
    //Sets up output for thread
    PrintWriter out = null;
    

    public ServerThread(Socket socket, ArrayList<ServerThread> clientList) {
		super("ServerThread");
		this.socket = socket;
		this.cl = clientList;
    }
    
    public void setId(int assignedId){
    	this.id = assignedId;
    }

    public void run() {

		try {
			out = new PrintWriter(socket.getOutputStream(), true);
			BufferedReader in = new BufferedReader( new InputStreamReader(socket.getInputStream()));

			String inputLine;
			System.out.println("TmanServer received client");
			out.println("TmanServer Received Client");

			while ((inputLine = in.readLine()) != null) {
				if (inputLine.equals("exit")){ break; }
				else if (inputLine.equals("matlabreq")) {
					double[] a = new double[]{4.3, 2.4, 4.3};
					try {
						matlaboperations.MatlabOps.callMatlab(a);
					} catch (Exception e){
						System.out.println("Error in Serverthread while calling Matlab: " + e.toString());
					}
				}
				else {
					System.out.println("TmanServer Received: "+ inputLine);
					out.println("TmanServer Received message");
				}
			}

			System.out.println("Closing Server Thread");
			out.close();
			in.close();
			socket.close();

		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}	

