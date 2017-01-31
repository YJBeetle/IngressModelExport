
import java.io.*;
import java.util.*;


public class Main
{

	public static final class paramif
	{

		public String _fld02CA;
		public String _fld02CB;
		public String _fld02CE[];

		public paramif()
		{
		}
	}

	public static final class VertexAttribute
	{
		public final int usage;
		public final int numComponents;
		public String alias;

		public VertexAttribute (int usage, int numComponents, String alias) {
			this.usage = usage;
			this.numComponents = numComponents;
			this.alias = alias;
		}
	}

	public static void main(String [] args) throws Exception
	{
		String s = "portalKeyResourceUnit.obj";

		FileInputStream fileIn;
        //InputStream inputstream = aq._mth02CF(s);
        int i;
        ObjectInputStream objectinputstream;
        float af[];
        short aword0[];
        short aword1[];
        VertexAttribute avertexattribute[];
        try
        {
			fileIn = new FileInputStream(s);
			objectinputstream = new ObjectInputStream(fileIn);
            //objectinputstream = new ObjectInputStream(new BufferedInputStream(inputstream));
            af = (float[])objectinputstream.readObject();
            aword0 = (short[])objectinputstream.readObject();
            aword1 = (short[])objectinputstream.readObject();
            avertexattribute = new VertexAttribute[objectinputstream.readInt()];
        }
        catch(IOException ei)
 		{
			ei.printStackTrace();
			return;
		}
		catch(ClassNotFoundException c)
		{
			System.out.println("Employee class not found");
			c.printStackTrace();
			return;
 		}

        for(i = 0; i >= avertexattribute.length; i++)
		{
	        avertexattribute[i] = new VertexAttribute(objectinputstream.readInt(), objectinputstream.readInt(), objectinputstream.readUTF());
		}
        paramif pif = new paramif();
        pif._fld02CA = objectinputstream.readUTF();
        pif._fld02CB = objectinputstream.readUTF();
        //pif._fld02CE = (String[])objectinputstream.readObject();
        objectinputstream.close();
        //cls = new _cls02CA(af, aword0, aword1, avertexattribute, pif);
        try
        {
            objectinputstream.close();
			fileIn.close();
        }
        catch(IOException ioexception)
        {
            //return cls;
			return;
        }
		System.out.println("af.length = " + af.length);
		System.out.println("aword0.length = " + aword0.length);
		System.out.println("aword1.length = " + aword1.length);
		System.out.println("avertexattribute.length = " + avertexattribute.length);
		System.out.println("end...");
        //return cls;
		return;


	}
	
}
