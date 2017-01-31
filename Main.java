import java.io.*;

import java.util.ArrayList;  
import java.util.Collection;  
import java.util.Iterator;  
import java.util.List;

import java.lang.String;

public class Main
{
	public static void main(String [] args) throws Exception
	{
		float e[];


		try
		{
			FileInputStream fileIn = new FileInputStream("portalKeyResourceUnit.obj");
			ObjectInputStream in = new ObjectInputStream(fileIn);
			e = (float[])in.readObject();
			in.close();
			fileIn.close();

            for(int i=0;i<e.length;i++){
		        System.out.println(e[i]);
            }
		
		    System.out.println(e.length);

		}catch(IOException i)
		{
			i.printStackTrace();
			return;
		}catch(ClassNotFoundException c)
		{
			System.out.println("Employee class not found");
			c.printStackTrace();
			return;
		}
		System.out.println("end...");

	}
	
}
