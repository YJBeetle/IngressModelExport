
import java.io.*;
import java.util.*;

import java.text.SimpleDateFormat;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

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
	public enum FileType {
		obj, dae;
	}

	public static void main(String [] args) throws Exception
	{
		//init
        int i;
		int ii;
		String fileInPath = null;
		String fileOutPath = null;
		FileType fileType = FileType.obj;

		//args处理
		if(args.length <= 0)
		{
			System.out.println("error: No input file\nsee --help");
			return;
		}
		for(i = 0; i < args.length; i++)
		{
			if(args[i].equals("-h") || args[i].equals("--help"))
			{
				System.out.println("help");
				return;
			}
			else if(args[i].equals("-i") || args[i].equals("--input"))
			{
				fileInPath = args[i+1];
				i++;
			}
			else if(args[i].equals("-o") || args[i].equals("--output"))
			{
				fileOutPath = args[i+1];
				i++;
			}
			else if(args[i].equals("-t") || args[i].equals("--type"))
			{
				if(args[i+1].equalsIgnoreCase("obj"))
					fileType = FileType.obj;
				else if(args[i+1].equalsIgnoreCase("dae"))
					fileType = FileType.dae;
				i++;
			}
			else if(fileInPath == null)
			{
				fileInPath = args[i];
			}
			else if(fileOutPath == null)
			{
				fileOutPath = args[i];
			}
		}

		if(fileInPath == null)
		{
			System.out.println("error: No input file\nsee --help");
			return;
		}

		//开始读取数据
		FileInputStream fileIn;
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
			if(!new File(fileInPath).exists())
			{
				System.out.println("error: File does not exist");
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

		//拼接
		String fileOutText = "";
		if(fileType == FileType.obj)	//拼接为obj
		{
			//准备
			int vlen = 3;	//默认格式
			int vtlen = 2;
			int vnlen = 0;
			String tmpString;

			//输出注释
			fileOutText += "# Create by IngressModelExport" + "\n";
			fileOutText += "# Develop by YJBeetle" + "\n";
			fileOutText += "# Now time is " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "\n";
			fileOutText += "" + "\n";

			//原始信息输出
			fileOutText += "# ingress obj info:" + "\n";
			fileOutText += "# af.length = " + af.length + "\n";	//点数据量，格式：顶点坐标x + 顶点坐标y + 顶点坐标z + 顶点法线x + 顶点法线y + 顶点法线z + 贴图坐标x + 贴图坐标y
			fileOutText += "# aword0.length = " + aword0.length + "\n";	//表面数据量，格式：顶点序号a + 顶点序号b + 顶点序号c
			fileOutText += "# aword1.length = " + aword1.length + "\n";	//线数据量，格式：顶点序号a + 顶点序号b
			fileOutText += "# avertexattribute.length = " + avertexattribute.length + "\n";
			for(i = 0; i < avertexattribute.length; i++)
			{
				fileOutText += "# avertexattribute[" + i + "].usage = " + avertexattribute[i].usage + "\n";
				fileOutText += "# avertexattribute[" + i + "].numComponents = " + avertexattribute[i].numComponents + "\n";
				fileOutText += "# avertexattribute[" + i + "].alias = " + avertexattribute[i].alias + "\n";
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
			fileOutText += "" + "\n";

			//模型信息输出
			fileOutText += "# obj info:" + "\n";
			fileOutText += "# Vertex count: "+ af.length / (vlen+vtlen+vnlen) + "\n";
			fileOutText += "# Surface count: "+ aword0.length / 3 + "\n";
			fileOutText += "# Line count: "+ aword1.length / 2 + "\n";
			fileOutText += "" + "\n";

			//顶点(v)
			fileOutText += "# Geometric vertices (v):" + "\n";
			for(i = 0; i < (af.length / (vlen+vtlen+vnlen)); i++)
			{
				tmpString = "";
				for(ii = 0; ii < vlen; ii++)
					tmpString += af[i * (vlen+vtlen+vnlen) + ii] + " ";
				fileOutText += "v " + tmpString + "\n";
			}
			fileOutText += "" + "\n";

			//贴图坐标(vt)
			if(vtlen > 0)
			{
				fileOutText += "# Texture vertices (vt):" + "\n";
				for(i = 0; i < (af.length / (vlen+vtlen+vnlen)); i++)
				{
					tmpString = "";
					for(ii = 0; ii < vtlen; ii++)
						tmpString += af[i * (vlen+vtlen+vnlen) + vlen + vnlen + ii] + " ";
					fileOutText += "vt " + tmpString + "\n";
				}
				fileOutText += "" + "\n";
			}

			//顶点法线(vn)
			if(vnlen > 0)
			{
				fileOutText += "# Vertex normals (vn):" + "\n";
				for(i = 0; i < (af.length / (vlen+vtlen+vnlen)); i++)
				{
					tmpString = "";
					for(ii = 0; ii < vnlen; ii++)
						tmpString += af[i * (vlen+vtlen+vnlen) + vlen + ii] + " ";
					fileOutText += "vn " + tmpString + "\n";
				}
				fileOutText += "" + "\n";
			}

			//面(f)
			fileOutText += "# Surface (f):" + "\n";
			for(i = 0; i < (aword0.length/3); i++)
			{
				if(vtlen > 0 && vnlen > 0)
				{
					fileOutText += "f " + (aword0[i*3]+1) + "/" + (aword0[i*3]+1) + "/" + (aword0[i*3]+1) + " " + (aword0[i*3+1]+1) + "/" + (aword0[i*3+1]+1) + "/" + (aword0[i*3+1]+1) + " " + (aword0[i*3+2]+1) + "/" + (aword0[i*3+2]+1) + "/" + (aword0[i*3+2]+1) + "\n";
				}
				else if(vtlen > 0 && vnlen == 0)
				{
					fileOutText += "f " + (aword0[i*3]+1) + "/" + (aword0[i*3]+1) + " " + (aword0[i*3+1]+1) + "/" + (aword0[i*3+1]+1) + " " + (aword0[i*3+2]+1) + "/" + (aword0[i*3+2]+1) + "\n";
				}
				else
				{
					fileOutText += "f " + (aword0[i*3]+1) + " " + (aword0[i*3+1]+1) + " " + (aword0[i*3+2]+1) + "\n";
				}
			}
			fileOutText += "" + "\n";

			//线(l)
			fileOutText += "# Line (l):" + "\n";
			for(i = 0; i < (aword1.length/2); i++)
			{
				fileOutText += "l " + (aword1[i*2]+1) + " " + (aword1[i*2+1]+1) + "\n";
			}
			fileOutText += "" + "\n";
		}
		else if(fileType == FileType.dae)	//拼接dae
		{
			Document document = null;

			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			document = builder.newDocument();

			Element COLLADA = document.createElement("COLLADA");
			document.appendChild(COLLADA);
			Element asset = document.createElement("asset");

			Element contributor = document.createElement("contributor");
			asset.appendChild(contributor);

			Element authoring_tool = document.createElement("authoring_tool");
			authoring_tool.appendChild(document.createTextNode("IngressModelExport"));
			contributor.appendChild(authoring_tool);

			Element created = document.createElement("created");
			created.appendChild(document.createTextNode(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			asset.appendChild(created);
			Element modified = document.createElement("modified");
			modified.appendChild(document.createTextNode(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			asset.appendChild(modified);

			COLLADA.appendChild(asset);

			Source source = new DOMSource(document);
            StringWriter stringWriter = new StringWriter();
            Result result = new StreamResult(stringWriter);
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
            transformer.transform(source, result);
            fileOutText += stringWriter.getBuffer().toString();
		}

		//输出
		if(fileOutPath == null)
		{
			System.out.println(fileOutText);
		}
		else
		{
			FileOutputStream fileOut = new FileOutputStream(fileOutPath);
            fileOut.write(fileOutText.getBytes());
			fileOut.close();
		}

		return;

	}
	
}
