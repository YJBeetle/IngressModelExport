
import java.io.*;
import java.util.*;
import java.text.SimpleDateFormat;

public class Main
{
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
		String fileInPath;
		FileInputStream fileIn;
        int i;
        boolean flag;
        ObjectInputStream objectinputstream;
        float af[];
        short aword0[];
        short aword1[];
        VertexAttribute avertexattribute[];
		String _fld02CA;
		String _fld02CB;
		String _fld02CE[];

        try
        {
			if(args.length <= 0)
			{
				System.out.println("# Create error: No input file");
				return;
			}
			fileInPath = args[0];
			if(!new File(fileInPath).exists())
			{
				System.out.println("# Create error: File does not exist");
				return;
			}
			fileIn = new FileInputStream(fileInPath);
			objectinputstream = new ObjectInputStream(fileIn);
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
			_fld02CA = objectinputstream.readUTF();
			_fld02CB = objectinputstream.readUTF();
			_fld02CE = (String[])objectinputstream.readObject();
		}
        objectinputstream.close();
		fileIn.close();
		
		//输出注释
		System.out.println("# Create by IngressModelExport");
		System.out.println("# Develop by YJBeetle");
		System.out.println("# Now time is " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) );
		System.out.println("");

		//概览
		System.out.println("# count");
		System.out.println("# af.length = " + af.length + "\tvertex count: "+ af.length / 5);	//点数据量，格式：顶点x + 顶点y + 顶点z + 贴图顶点x + 贴图顶点y
		System.out.println("# aword0.length = " + aword0.length + "\tface count: "+ aword0.length / 3);	//面数据量，格式：顶点a + 顶点b + 顶点c
		System.out.println("# aword1.length = " + aword1.length + "\tline count: "+ aword1.length / 2);	//线数据量，格式：顶点a + 顶点b
		System.out.println("# avertexattribute.length = " + avertexattribute.length);
		System.out.println("");

		//顶点
		System.out.println("# v");
		for(i = 0; i < (af.length/5); i++)
		{
			System.out.println("v " + af[i*5] + " " + af[i*5+1] + " " + af[i*5+2]);
		}
		System.out.println("");

		//贴图坐标
		System.out.println("# vt");
		for(i = 0; i < (af.length/5); i++)
		{
			System.out.println("vt " + af[i*5+3] + " " + af[i*5+4]);
		}
		System.out.println("");

		//面
		System.out.println("# f");
		for(i = 0; i < (aword0.length/3); i++)
		{
			System.out.println("f " + (aword0[i*3]+1) + " " + (aword0[i*3+1]+1) + " " + (aword0[i*3+2]+1));
		}
		System.out.println("");

		//线
		System.out.println("# l");
		for(i = 0; i < (aword1.length/2); i++)
		{
			System.out.println("l " + (aword1[i*2]+1) + " " + (aword1[i*2+1]+1));
		}
		System.out.println("");

		//未知数据
		System.out.println("# unknow");
		System.out.println("# avertexattribute data");
		for(i = 0; i < avertexattribute.length; i++)
		{
			System.out.println("# usage = " + avertexattribute[i].usage + " ; numComponents = " + avertexattribute[i].numComponents + " ; alias = " + avertexattribute[i].alias);
		}
		System.out.println("");

		return;

	}
	
}
