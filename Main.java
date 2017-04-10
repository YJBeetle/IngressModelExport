
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
		//开始读取数据
		String fileInPath;
		FileInputStream fileIn;
        int i;
		int ii;
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
		
		//解析准备
		int vlen = 3;	//默认格式
		int vtlen = 2;
		int vnlen = 0;
		String tmpString;

		//输出注释
		System.out.println("# Create by IngressModelExport");
		System.out.println("# Develop by YJBeetle");
		System.out.println("# Now time is " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) );
		System.out.println("");

		//原始信息输出
		System.out.println("# ingress obj info:");
		System.out.println("# af.length = " + af.length);	//点数据量，格式：顶点坐标x + 顶点坐标y + 顶点坐标z + 顶点法线x + 顶点法线y + 顶点法线z + 贴图坐标x + 贴图坐标y
		System.out.println("# aword0.length = " + aword0.length);	//表面数据量，格式：顶点序号a + 顶点序号b + 顶点序号c
		System.out.println("# aword1.length = " + aword1.length);	//线数据量，格式：顶点序号a + 顶点序号b
		System.out.println("# avertexattribute.length = " + avertexattribute.length);
		for(i = 0; i < avertexattribute.length; i++)
		{
			System.out.println("# avertexattribute[" + i + "].usage = " + avertexattribute[i].usage);
			System.out.println("# avertexattribute[" + i + "].numComponents = " + avertexattribute[i].numComponents);
			System.out.println("# avertexattribute[" + i + "].alias = " + avertexattribute[i].alias);
			if(avertexattribute[i].alias.equals("a_position"))	//v
			{
				vlen = avertexattribute[i].numComponents;
			}
			if(avertexattribute[i].alias.equals("a_texCoord0"))	//vt
			{
				vtlen = avertexattribute[i].numComponents;
			}
			if(avertexattribute[i].alias.equals("a_normal"))	//vn
			{
				vnlen = avertexattribute[i].numComponents;
			}
		}
		System.out.println("");

		//模型信息输出
		System.out.println("# obj info:");
		System.out.println("# Vertex count: "+ af.length / (vlen+vtlen+vnlen));
		System.out.println("# Surface count: "+ aword0.length / 3);
		System.out.println("# Line count: "+ aword1.length / 2);
		System.out.println("");

		//顶点(v)
		System.out.println("# Geometric vertices (v):");
		for(i = 0; i < (af.length / (vlen+vtlen+vnlen)); i++)
		{
			tmpString = "";
			for(ii = 0; ii < vlen; ii++)
				tmpString += af[i * (vlen+vtlen+vnlen) + ii] + " ";
			System.out.println("v " + tmpString);
		}
		System.out.println("");

		//贴图坐标(vt)
		if(vtlen > 0)
		{
			System.out.println("# Texture vertices (vt):");
			for(i = 0; i < (af.length / (vlen+vtlen+vnlen)); i++)
			{
				tmpString = "";
				for(ii = 0; ii < vtlen; ii++)
					tmpString += af[i * (vlen+vtlen+vnlen) + vlen + vnlen + ii] + " ";
				System.out.println("vt " + tmpString);
			}
			System.out.println("");
		}

		//顶点法线(vn)
		if(vnlen > 0)
		{
			System.out.println("# Vertex normals (vn):");
			for(i = 0; i < (af.length / (vlen+vtlen+vnlen)); i++)
			{
				tmpString = "";
				for(ii = 0; ii < vnlen; ii++)
					tmpString += af[i * (vlen+vtlen+vnlen) + vlen + ii] + " ";
				System.out.println("vn " + tmpString);
			}
			System.out.println("");
		}

		//面(f)
		System.out.println("# Surface (f):");
		for(i = 0; i < (aword0.length/3); i++)
		{
			if(vtlen > 0 && vnlen > 0)
			{
				System.out.println("f " + (aword0[i*3]+1) + "/" + (aword0[i*3]+1) + "/" + (aword0[i*3]+1) + " " + (aword0[i*3+1]+1) + "/" + (aword0[i*3+1]+1) + "/" + (aword0[i*3+1]+1) + " " + (aword0[i*3+2]+1) + "/" + (aword0[i*3+2]+1) + "/" + (aword0[i*3+2]+1));
			}
			else if(vtlen > 0 && vnlen == 0)
			{
				System.out.println("f " + (aword0[i*3]+1) + "/" + (aword0[i*3]+1) + " " + (aword0[i*3+1]+1) + "/" + (aword0[i*3+1]+1) + " " + (aword0[i*3+2]+1) + "/" + (aword0[i*3+2]+1));
			}
			else
			{
				System.out.println("f " + (aword0[i*3]+1) + " " + (aword0[i*3+1]+1) + " " + (aword0[i*3+2]+1));
			}
		}
		System.out.println("");

		//线(l)
		System.out.println("# Line (l):");
		for(i = 0; i < (aword1.length/2); i++)
		{
			System.out.println("l " + (aword1[i*2]+1) + " " + (aword1[i*2+1]+1));
		}
		System.out.println("");

		return;

	}
	
}
