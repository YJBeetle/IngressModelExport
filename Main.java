
import java.io.*;
import java.util.*;
import java.util.regex.*;

import java.text.SimpleDateFormat;

import javax.xml.bind.annotation.XmlNs;
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

		//解析
		int vlen = 0;
		int vtlen = 0;
		int vnlen = 0;
		float [] v = null;
		float [] vt = null;
		float [] vn = null;
        short [] f = null;
        short [] l = null;

		//读取v/vt/vn分别的位数
		for(i = 0; i < avertexattribute.length; i++)
		{
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

		v = new float[af.length / (vlen+vtlen+vnlen) * vlen];
		vt = new float[af.length / (vlen+vtlen+vnlen) * vtlen];
		vn = new float[af.length / (vlen+vtlen+vnlen) * vnlen];
		f = aword0;
		l = aword1;

		//读取具体点数据
		for(i = 0; i < (af.length / (vlen+vtlen+vnlen)); i++)
		{
			for(ii = 0; ii < vlen; ii++)
				v[i*vlen + ii] = af[i * (vlen+vtlen+vnlen) + ii];
			for(ii = 0; ii < vtlen; ii++)
				vt[i*vtlen + ii] = af[i * (vlen+vtlen+vnlen) + vlen + vnlen + ii];
			for(ii = 0; ii < vnlen; ii++)
				vn[i*vnlen + ii] = af[i * (vlen+vtlen+vnlen) + vlen + ii];
		}

		//拼接
		String fileOutText = "";
		if(fileType == FileType.obj)	//拼接为obj
		{
			//输出头注释
			fileOutText += "# Create by IngressModelExport" + "\n";
			fileOutText += "# Develop by YJBeetle" + "\n";
			fileOutText += "# Model name: " + fileInPath.replaceAll(".*[/\\\\]", "").replaceAll("\\..*", "") + "\n";
			fileOutText += "# Created: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "\n";
			fileOutText += "\n";

			//原始信息输出
			fileOutText += "# Ingress obj info:" + "\n";
			fileOutText += "# af.length = " + af.length + "\n";	//点数据量
			fileOutText += "# aword0.length = " + aword0.length + "\n";	//面数据量
			fileOutText += "# aword1.length = " + aword1.length + "\n";	//线数据量
			fileOutText += "# avertexattribute.length = " + avertexattribute.length + "\n";
			for(i = 0; i < avertexattribute.length; i++)
			{
				fileOutText += "# avertexattribute[" + i + "].usage = " + avertexattribute[i].usage + "\n";
				fileOutText += "# avertexattribute[" + i + "].numComponents = " + avertexattribute[i].numComponents + "\n";
				fileOutText += "# avertexattribute[" + i + "].alias = " + avertexattribute[i].alias + "\n";
			}
			fileOutText += "\n";

			//模型基本信息输出
			fileOutText += "# Model info:" + "\n";
			fileOutText += "# Vertex count: "+ af.length / (vlen+vtlen+vnlen) + "\n";
			fileOutText += "# Surface count: "+ aword0.length / 3 + "\n";
			fileOutText += "# Line count: "+ aword1.length / 2 + "\n";
			fileOutText += "\n";

			//顶点(v)
			fileOutText += "# Geometric vertices (v):" + "\n";
			for(i = 0; i < v.length; i++)
			{
				if(i % vlen == 0)
				{
					fileOutText += "v";
				}
				fileOutText += " " + v[i];
				if((i+1) % vlen == 0)
				{
					fileOutText += "\n";
				}
			}
			fileOutText += "\n";

			//贴图坐标(vt)
			fileOutText += "# Texture vertices (vt):" + "\n";
			for(i = 0; i < vt.length; i++)
			{
				if(i % vtlen == 0)
				{
					fileOutText += "vt";
				}
				fileOutText += " " + vt[i];
				if((i+1) % vtlen == 0)
				{
					fileOutText += "\n";
				}
			}
			fileOutText += "\n";

			//顶点法线(vn)
			fileOutText += "# Vertex normals (vn):" + "\n";
			for(i = 0; i < vn.length; i++)
			{
				if(i % vnlen == 0)
				{
					fileOutText += "vn";
				}
				fileOutText += " " + vn[i];
				if((i+1) % vnlen == 0)
				{
					fileOutText += "\n";
				}
			}
			fileOutText += "\n";

			//面(f)
			fileOutText += "# Surface (f):" + "\n";
			for(i = 0; i < f.length; i++)
			{
				if(i % 3 == 0)
				{
					fileOutText += "f";
				}
				fileOutText += " " + (f[i]+1);
				if(vtlen > 0 || vnlen > 0)
				{
					fileOutText += "/";
					if(vtlen > 0)
					{
						fileOutText += (f[i]+1);
					}
					if(vnlen > 0)
					{
						fileOutText += "/";
						fileOutText += (f[i]+1);
					}
				}
				if((i+1) % 3 == 0)
				{
					fileOutText += "\n";
				}
			}
			fileOutText += "\n";

			//线(l)
			fileOutText += "# Line (l):" + "\n";
			for(i = 0; i < (l.length/2); i++)
			{
				fileOutText += "l " + (l[i*2]+1) + " " + (l[i*2+1]+1) + "\n";
			}
			fileOutText += "\n";
		}
		else if(fileType == FileType.dae)	//拼接dae
		{
			//准备
			Document document = null;
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			document = builder.newDocument();

			//开始
			Element COLLADA = document.createElement("COLLADA");
			COLLADA.setAttribute("xmlns", "http://www.collada.org/2005/11/COLLADASchema");
			COLLADA.setAttribute("version", "1.4.1");
			document.appendChild(COLLADA);

				Element asset = document.createElement("asset");
				COLLADA.appendChild(asset);

					Element contributor = document.createElement("contributor");
					asset.appendChild(contributor);

						Element authoring_tool = document.createElement("authoring_tool");
						authoring_tool.appendChild(document.createTextNode("IngressModelExport Develop by YJBeetle"));
						contributor.appendChild(authoring_tool);

					Element created = document.createElement("created");
					created.appendChild(document.createTextNode(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(new Date())));
					asset.appendChild(created);

					Element modified = document.createElement("modified");
					modified.appendChild(document.createTextNode(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(new Date())));
					asset.appendChild(modified);

					Element keywords = document.createElement("keywords");
					keywords.appendChild(document.createTextNode("ingress " + fileInPath.replaceAll(".*[/\\\\]", "").replaceAll("\\..*", "") ));
					asset.appendChild(keywords);

					Element title = document.createElement("title");
					title.appendChild(document.createTextNode(fileInPath.replaceAll(".*[/\\\\]", "").replaceAll("\\..*", "")));
					asset.appendChild(title);
					
					Element unit = document.createElement("unit");
					unit.setAttribute("meter", "0.01");
					unit.setAttribute("name", "centimeter");
					asset.appendChild(unit);

					Element up_axis = document.createElement("up_axis");
					up_axis.appendChild(document.createTextNode("Y_UP"));
					asset.appendChild(up_axis);

				Element library_images = document.createElement("library_images");
				COLLADA.appendChild(library_images);

					Element image = document.createElement("image");
					image.setAttribute("id", "genericModTexture_image");
					library_images.appendChild(image);

						Element init_from = document.createElement("init_from");
						init_from.appendChild(document.createTextNode("genericModTexture.png"));
						image.appendChild(init_from);

				Element library_effects = document.createElement("library_effects");
				COLLADA.appendChild(library_effects);

					Element effect = document.createElement("effect");
					effect.setAttribute("id", "genericModTexture_effect");
					library_effects.appendChild(effect);

						Element profile_COMMON = document.createElement("profile_COMMON");
						effect.appendChild(profile_COMMON);

							Element newparam1 = document.createElement("newparam");
							newparam1.setAttribute("sid", "genericModTexture_newparam1");
							profile_COMMON.appendChild(newparam1);

								Element surface = document.createElement("surface");
								surface.setAttribute("type", "2D");
								newparam1.appendChild(surface);

									Element init_from2 = document.createElement("init_from");
									init_from2.appendChild(document.createTextNode("genericModTexture_image"));
									surface.appendChild(init_from2);
							
							Element newparam2 = document.createElement("newparam");
							newparam2.setAttribute("sid", "genericModTexture_newparam2");
							profile_COMMON.appendChild(newparam2);

								Element sampler2D = document.createElement("sampler2D");
								newparam2.appendChild(sampler2D);

									Element source2 = document.createElement("source");
									source2.appendChild(document.createTextNode("genericModTexture_newparam1"));
									sampler2D.appendChild(source2);

							Element technique = document.createElement("technique");
							technique.setAttribute("sid", "COMMON");
							profile_COMMON.appendChild(technique);

								Element blinn = document.createElement("blinn");
								technique.appendChild(blinn);
								
									Element diffuse = document.createElement("diffuse");
									blinn.appendChild(diffuse);

										Element texture = document.createElement("texture");
										texture.setAttribute("texture", "genericModTexture_newparam2");
										texture.setAttribute("texcoord", "UVSET0");
										diffuse.appendChild(texture);

				Element library_materials = document.createElement("library_materials");
				COLLADA.appendChild(library_materials);

					Element material = document.createElement("material");
					material.setAttribute("id", "genericModTexture");
					material.setAttribute("name", "genericModTexture");
					library_materials.appendChild(material);
						
						Element instance_effect = document.createElement("instance_effect");
						instance_effect.setAttribute("url", "#genericModTexture_effect");
						material.appendChild(instance_effect);

				Element library_geometries = document.createElement("library_geometries");
				COLLADA.appendChild(library_geometries);

					Element geometry = document.createElement("geometry");
					geometry.setAttribute("id", "geometry");
					library_geometries.appendChild(geometry);

						Element mesh = document.createElement("mesh");
						geometry.appendChild(mesh);

							Element source3 = document.createElement("source");
							geometry.setAttribute("id", "geometry_v");
							mesh.appendChild(source3);

			//输出字符串
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
