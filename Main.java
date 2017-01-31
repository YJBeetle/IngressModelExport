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
        float af[];
        short aword0[];
        short aword1[];
        boolean flag;

		String _fld02CA;
		String _fld02CB;
		String _fld02CE[];

		try
		{
			FileInputStream fileIn = new FileInputStream("portalKeyResourceUnit.obj");
			ObjectInputStream in = new ObjectInputStream(fileIn);
            af = (float[])in.readObject();
            aword0 = (short[])in.readObject();
            aword1 = (short[])in.readObject();

			System.out.println(in.readInt());

			in.readInt();
			in.readInt();
			in.readUTF();

			flag = in.readBoolean();

			_fld02CA = in.readUTF();
			//_fld02CB = in.readUTF();
			//_fld02CE = (String[])in.readObject();

			in.close();
			fileIn.close();

            // for(int i=0;i<af.length;i++){
		    //     System.out.println(af[i]);
            // }
            // for(int i=0;i<aword0.length;i++){
		    //     System.out.println(aword0[i]);
            // }
            // for(int i=0;i<aword1.length;i++){
		    //     System.out.println(aword1[i]);
            // }
		
		    // System.out.println(af.length);
		    // System.out.println(aword0.length);
		    // System.out.println(aword1.length);

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
