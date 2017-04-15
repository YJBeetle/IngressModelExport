
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
			String tmpString;
			int [] tmpintArray;
			Document document = null;
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			document = builder.newDocument();

			//开始
			Element COLLADA = document.createElement("COLLADA");
			document.appendChild(COLLADA);
			COLLADA.setAttribute("xmlns", "http://www.collada.org/2005/11/COLLADASchema");
			COLLADA.setAttribute("version", "1.4.1");

				Element asset = document.createElement("asset");
				COLLADA.appendChild(asset);

					Element contributor = document.createElement("contributor");
					asset.appendChild(contributor);

						Element authoring_tool = document.createElement("authoring_tool");
						contributor.appendChild(authoring_tool);
						authoring_tool.appendChild(document.createTextNode("IngressModelExport Develop by YJBeetle"));

					Element created = document.createElement("created");
					asset.appendChild(created);
					created.appendChild(document.createTextNode(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(new Date())));

					Element modified = document.createElement("modified");
					asset.appendChild(modified);
					modified.appendChild(document.createTextNode(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(new Date())));

					Element keywords = document.createElement("keywords");
					asset.appendChild(keywords);
					keywords.appendChild(document.createTextNode("ingress " + fileInPath.replaceAll(".*[/\\\\]", "").replaceAll("\\..*", "") ));

					Element title = document.createElement("title");
					asset.appendChild(title);
					title.appendChild(document.createTextNode(fileInPath.replaceAll(".*[/\\\\]", "").replaceAll("\\..*", "")));
					
					Element unit = document.createElement("unit");
					asset.appendChild(unit);
					unit.setAttribute("meter", "0.01");
					unit.setAttribute("name", "centimeter");

					Element up_axis = document.createElement("up_axis");
					asset.appendChild(up_axis);
					up_axis.appendChild(document.createTextNode("Y_UP"));

				Element library_images = document.createElement("library_images");
				COLLADA.appendChild(library_images);

					Element image = document.createElement("image");
					library_images.appendChild(image);
					image.setAttribute("id", "genericModTexture_image");

						Element init_from = document.createElement("init_from");
						image.appendChild(init_from);
						init_from.appendChild(document.createTextNode("genericModTexture.png"));

				Element library_effects = document.createElement("library_effects");
				COLLADA.appendChild(library_effects);

					Element effect = document.createElement("effect");
					library_effects.appendChild(effect);
					effect.setAttribute("id", "genericModTexture_effect");

						Element profile_COMMON = document.createElement("profile_COMMON");
						effect.appendChild(profile_COMMON);

							Element newparam1 = document.createElement("newparam");
							profile_COMMON.appendChild(newparam1);
							newparam1.setAttribute("sid", "genericModTexture_newparam1");

								Element surface = document.createElement("surface");
								newparam1.appendChild(surface);
								surface.setAttribute("type", "2D");

									Element init_from2 = document.createElement("init_from");
									surface.appendChild(init_from2);
									init_from2.appendChild(document.createTextNode("genericModTexture_image"));
							
							Element newparam2 = document.createElement("newparam");
							profile_COMMON.appendChild(newparam2);
							newparam2.setAttribute("sid", "genericModTexture_newparam2");

								Element sampler2D = document.createElement("sampler2D");
								newparam2.appendChild(sampler2D);

									Element source2 = document.createElement("source");
									sampler2D.appendChild(source2);
									source2.appendChild(document.createTextNode("genericModTexture_newparam1"));

							Element technique = document.createElement("technique");
							profile_COMMON.appendChild(technique);
							technique.setAttribute("sid", "COMMON");

								Element blinn = document.createElement("blinn");
								technique.appendChild(blinn);
								
									Element diffuse = document.createElement("diffuse");
									blinn.appendChild(diffuse);

										Element texture = document.createElement("texture");
										diffuse.appendChild(texture);
										texture.setAttribute("texture", "genericModTexture_newparam2");
										texture.setAttribute("texcoord", "UVSET0");

				Element library_materials = document.createElement("library_materials");
				COLLADA.appendChild(library_materials);

					Element material = document.createElement("material");
					library_materials.appendChild(material);
					material.setAttribute("id", "genericModTexture");
					material.setAttribute("name", "genericModTexture");
						
						Element instance_effect = document.createElement("instance_effect");
						material.appendChild(instance_effect);
						instance_effect.setAttribute("url", "#genericModTexture_effect");

				Element library_geometries = document.createElement("library_geometries");
				COLLADA.appendChild(library_geometries);

					Element geometry = document.createElement("geometry");
					library_geometries.appendChild(geometry);
					geometry.setAttribute("id", "geometry");

						Element mesh = document.createElement("mesh");
						geometry.appendChild(mesh);

							if(vlen > 0)
							{
								Element source_v = document.createElement("source");
								mesh.appendChild(source_v);
								source_v.setAttribute("id", "source_v");

									Element float_array_v = document.createElement("float_array");
									source_v.appendChild(float_array_v);
									float_array_v.setAttribute("id", "float_array_v");
									float_array_v.setAttribute("count", String.valueOf(v.length));
									float_array_v.appendChild(document.createTextNode(Arrays.toString(v).replaceAll("[\\,\\[\\]]", "")));

									Element technique_common_v = document.createElement("technique_common");
									source_v.appendChild(technique_common_v);

										Element accessor_v = document.createElement("accessor");
										technique_common_v.appendChild(accessor_v);
										accessor_v.setAttribute("count", String.valueOf(v.length / vlen));
										accessor_v.setAttribute("source", "#float_array_v");
										accessor_v.setAttribute("stride", String.valueOf(vlen));
										
											Element [] param_v = new Element[vlen];
											for(i = 0; i < vlen; i++)
											{
												switch(i)
												{
													case 0:
														tmpString = "X";
														break;
													case 1:
														tmpString = "Y";
														break;
													case 2:
														tmpString = "Z";
														break;
													case 3:
														tmpString = "W";
														break;
													default:
														tmpString = String.valueOf(i);
														break;
												}
												param_v[i] = document.createElement("param");
												accessor_v.appendChild(param_v[i]);
												param_v[i].setAttribute("name", tmpString);
												param_v[i].setAttribute("type", "float");
											}
							}

							if(vnlen > 0)
							{
								Element source_vn = document.createElement("source");
								mesh.appendChild(source_vn);
								source_vn.setAttribute("id", "source_vn");

									Element float_array_vn = document.createElement("float_array");
									source_vn.appendChild(float_array_vn);
									float_array_vn.setAttribute("id", "float_array_vn");
									float_array_vn.setAttribute("count", String.valueOf(vn.length));
									float_array_vn.appendChild(document.createTextNode(Arrays.toString(vn).replaceAll("[\\,\\[\\]]", "")));

									Element technique_common_vn = document.createElement("technique_common");
									source_vn.appendChild(technique_common_vn);

										Element accessor_vn = document.createElement("accessor");
										technique_common_vn.appendChild(accessor_vn);
										accessor_vn.setAttribute("count", String.valueOf(vn.length / vnlen));
										accessor_vn.setAttribute("source", "#float_array_vn");
										accessor_vn.setAttribute("stride", String.valueOf(vnlen));
										
											Element [] param_vn = new Element[vnlen];
											for(i = 0; i < vnlen; i++)
											{
												switch(i)
												{
													case 0:
														tmpString = "X";
														break;
													case 1:
														tmpString = "Y";
														break;
													case 2:
														tmpString = "Z";
														break;
													default:
														tmpString = String.valueOf(i);
														break;
												}
												param_vn[i] = document.createElement("param");
												accessor_vn.appendChild(param_vn[i]);
												param_vn[i].setAttribute("name", tmpString);
												param_vn[i].setAttribute("type", "float");
											}
							}

							if(vtlen > 0)
							{
								Element source_vt = document.createElement("source");
								mesh.appendChild(source_vt);
								source_vt.setAttribute("id", "source_vt");

									Element float_array_vt = document.createElement("float_array");
									source_vt.appendChild(float_array_vt);
									float_array_vt.setAttribute("id", "float_array_vt");
									float_array_vt.setAttribute("count", String.valueOf(vt.length));
									float_array_vt.appendChild(document.createTextNode(Arrays.toString(vt).replaceAll("[\\,\\[\\]]", "")));

									Element technique_common_vt = document.createElement("technique_common");
									source_vt.appendChild(technique_common_vt);

										Element accessor_vt = document.createElement("accessor");
										technique_common_vt.appendChild(accessor_vt);
										accessor_vt.setAttribute("count", String.valueOf(vt.length / vtlen));
										accessor_vt.setAttribute("source", "#float_array_vt");
										accessor_vt.setAttribute("stride", String.valueOf(vtlen));
										
											Element [] param_vt = new Element[vtlen];
											for(i = 0; i < vtlen; i++)
											{
												switch(i)
												{
													case 0:
														tmpString = "S";
														break;
													case 1:
														tmpString = "T";
														break;
													default:
														tmpString = String.valueOf(i);
														break;
												}
												param_vt[i] = document.createElement("param");
												accessor_vt.appendChild(param_vt[i]);
												param_vt[i].setAttribute("name", tmpString);
												param_vt[i].setAttribute("type", "float");
											}
							}

							Element vertices = document.createElement("vertices");
							mesh.appendChild(vertices);
							vertices.setAttribute("id", "vertices");

								Element vertices_input = document.createElement("input");
								vertices.appendChild(vertices_input);
								vertices_input.setAttribute("semantic", "POSITION");
								vertices_input.setAttribute("source", "#source_v");

							Element polylist = document.createElement("polylist");
							mesh.appendChild(polylist);
							polylist.setAttribute("count", String.valueOf(f.length / 3));
							polylist.setAttribute("material", "Material1");

								i = 0;
								if(vlen > 0)
								{
									Element polylist_input1 = document.createElement("input");
									polylist.appendChild(polylist_input1);
									polylist_input1.setAttribute("offset", String.valueOf(i));
									polylist_input1.setAttribute("semantic", "VERTEX");
									polylist_input1.setAttribute("source", "#vertices");
									i++;
								}

								if(vnlen > 0)
								{
									Element polylist_input2 = document.createElement("input");
									polylist.appendChild(polylist_input2);
									polylist_input2.setAttribute("offset", String.valueOf(i));
									polylist_input2.setAttribute("semantic", "NORMAL");
									polylist_input2.setAttribute("source", "#source_vn");
									i++;
								}

								if(vtlen > 0)
								{
									Element polylist_input3 = document.createElement("input");
									polylist.appendChild(polylist_input3);
									polylist_input3.setAttribute("offset", String.valueOf(i));
									polylist_input3.setAttribute("semantic", "TEXCOORD");
									polylist_input3.setAttribute("source", "#source_vt");
									polylist_input3.setAttribute("set", "0");
									i++;
								}

								Element vcount = document.createElement("vcount");
								polylist.appendChild(vcount);
								tmpintArray = new int[f.length / 3];
								Arrays.fill(tmpintArray, 3);
								vcount.appendChild(document.createTextNode(Arrays.toString(tmpintArray).replaceAll("[\\,\\[\\]]", "")));

								Element polylist_p = document.createElement("p");
								polylist.appendChild(polylist_p);
								tmpString = "";
								for(i = 0; i < f.length; i++)
								{
									if(vlen > 0)
									{
										tmpString += String.valueOf(f[i]) + " ";
									}
									if(vnlen > 0)
									{
										tmpString += String.valueOf(f[i]) + " ";
									}
									if(vtlen > 0)
									{
										tmpString += String.valueOf(f[i]);
									}
									if(i+1 < f.length)
										tmpString += " ";
								}
								polylist_p.appendChild(document.createTextNode(tmpString));
   
				Element library_visual_scenes = document.createElement("library_visual_scenes");
				COLLADA.appendChild(library_visual_scenes);

					Element visual_scene = document.createElement("visual_scene");
					library_visual_scenes.appendChild(visual_scene);
					visual_scene.setAttribute("id", "visual_scene");

						Element node = document.createElement("node");
						visual_scene.appendChild(node);
						node.setAttribute("name", "Default");
						node.setAttribute("id", "node");

							Element translate = document.createElement("translate");
							node.appendChild(translate);
							translate.setAttribute("sid", "translate");
							translate.appendChild(document.createTextNode("0 0 -0"));

							Element rotate1 = document.createElement("rotate");
							node.appendChild(rotate1);
							rotate1.setAttribute("sid", "rotateY");
							rotate1.appendChild(document.createTextNode("0 1 0 -0"));

							Element rotate2 = document.createElement("rotate");
							node.appendChild(rotate2);
							rotate2.setAttribute("sid", "rotateX");
							rotate2.appendChild(document.createTextNode("1 0 0 0"));

							Element rotate3 = document.createElement("rotate");
							node.appendChild(rotate3);
							rotate3.setAttribute("sid", "rotateZ");
							rotate3.appendChild(document.createTextNode("0 0 1 -0"));

							Element scale = document.createElement("scale");
							node.appendChild(scale);
							scale.setAttribute("sid", "scale");
							scale.appendChild(document.createTextNode("1 1 1"));

							Element instance_geometry = document.createElement("instance_geometry");
							node.appendChild(instance_geometry);
							instance_geometry.setAttribute("url", "#geometry");

								Element bind_material = document.createElement("bind_material");
								instance_geometry.appendChild(bind_material);

									Element technique_common = document.createElement("technique_common");
									bind_material.appendChild(technique_common);

										Element instance_material = document.createElement("instance_material");
										technique_common.appendChild(instance_material);
										instance_material.setAttribute("symbol", "Material1");
										instance_material.setAttribute("target", "#genericModTexture");

											Element bind_vertex_input = document.createElement("bind_vertex_input");
											instance_material.appendChild(bind_vertex_input);
											bind_vertex_input.setAttribute("semantic", "UVSET0");
											bind_vertex_input.setAttribute("input_semantic", "TEXCOORD");
											bind_vertex_input.setAttribute("input_set", "0");

				Element scene = document.createElement("scene");
				COLLADA.appendChild(scene);

					Element instance_visual_scene = document.createElement("instance_visual_scene");
					scene.appendChild(instance_visual_scene);
					instance_visual_scene.setAttribute("url", "#visual_scene");


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
