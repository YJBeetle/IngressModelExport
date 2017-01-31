
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

	public static final class _cls02CA
	{
//		public final int paramArrayOfVertexAttribute16;
//		private final int vertexSizef4;
//		private final int paramArrayOfVertexAttribute1;
		public final float[] paramArrayOfFloat;
		public final short[] paramArrayOfShort1;
		public final short[] paramArrayOfShort2;
//		public final VertexAttributes paramArrayOfVertexAttribute;
		public final paramif paramif;
		
		_cls02CA(float[] paramArrayOfFloat, short[] paramArrayOfShort1, short[] paramArrayOfShort2, VertexAttribute[] paramArrayOfVertexAttribute, paramif paramif)
		{
			this.paramArrayOfFloat = paramArrayOfFloat;
			this.paramArrayOfShort1 = paramArrayOfShort1;
			this.paramArrayOfShort2 = paramArrayOfShort2;
	//		this.paramArrayOfVertexAttribute = new VertexAttributes(paramArrayOfVertexAttribute);
			this.paramif = paramif;
	//		this.vertexSizef4 = (this.paramArrayOfVertexAttribute.vertexSize / 4);
	//		this.paramArrayOfVertexAttribute1 = gp.ˊ(this.paramArrayOfVertexAttribute, 1);
	//		this.paramArrayOfVertexAttribute16 = gp.ˊ(this.paramArrayOfVertexAttribute, 16);
		}
		
		// public final Vector2 V2(short paramShort, Vector2 paramVector2)
		// {
		// 	int i;
		// 	if (this.paramArrayOfVertexAttribute16 != -1) {
		// 		i = 1;
		// 	} else {
		// 		i = 0;
		// 	}
		// 	if (i == 0) {
		// 		throw new IllegalStateException(String.valueOf("Mesh does not have texture coord data"));
		// 	}
		// 	paramShort = this.vertexSizef4 * paramShort + this.paramArrayOfVertexAttribute16;
		// 	return paramVector2.set(this.paramArrayOfFloat[(paramShort + 0)], this.paramArrayOfFloat[(paramShort + 1)]);
		// }
		
		// public final Vector3 V3(short paramShort, Vector3 paramVector3)
		// {
		// 	int i;
		// 	if (this.paramArrayOfVertexAttribute1 != -1) {
		// 		i = 1;
		// 	} else {
		// 		i = 0;
		// 	}
		// 	if (i == 0) {
		// 		throw new IllegalStateException(String.valueOf("Mesh does not have position data"));
		// 	}
		// 	paramShort = this.vertexSizef4 * paramShort + this.paramArrayOfVertexAttribute1;
		// 	return paramVector3.set(this.paramArrayOfFloat[(paramShort + 0)], this.paramArrayOfFloat[(paramShort + 1)], this.paramArrayOfFloat[(paramShort + 2)]);
		// }
	}


	public static void main(String [] args) throws Exception
	{
		String s = "portalKeyResourceUnit.obj";

		FileInputStream fileIn;
        //InputStream inputstream = aq._mth02CF(s);
        int i;
        boolean flag;
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

        for(i = 0; i < avertexattribute.length; i++)
		{
	        avertexattribute[i] = new VertexAttribute(objectinputstream.readInt(), objectinputstream.readInt(), objectinputstream.readUTF());
		}
        flag = objectinputstream.readBoolean();
		if(flag)
		{
			paramif paramif = new paramif();
			paramif._fld02CA = objectinputstream.readUTF();
			paramif._fld02CB = objectinputstream.readUTF();
			paramif._fld02CE = (String[])objectinputstream.readObject();
		}
        objectinputstream.close();
		fileIn.close();

        //_cls02CA cls = new _cls02CA(af, aword0, aword1, avertexattribute, paramif);

		System.out.println("== af ==");
        for(i = 0; i < af.length; i++)
		{
			System.out.println(af[i]);
		}

		System.out.println("== aword0 ==");
		for(i = 0; i < aword0.length; i++)
		{
			System.out.println(aword0[i]);
		}

		System.out.println("== aword1 ==");
		for(i = 0; i < aword1.length; i++)
		{
			System.out.println(aword1[i]);
		}

		System.out.println("== avertexattribute ==");
		for(i = 0; i < avertexattribute.length; i++)
		{
			System.out.println("usage = " + avertexattribute[i].usage + " ; numComponents = " + avertexattribute[i].numComponents + " ; alias = " + avertexattribute[i].alias);
		}

		System.out.println("== count ==");
		System.out.println("af.length = " + af.length);
		System.out.println("aword0.length = " + aword0.length);
		System.out.println("aword1.length = " + aword1.length);
		System.out.println("avertexattribute.length = " + avertexattribute.length);
		System.out.println("end...");
		
		return;


	}
	
}
