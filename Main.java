
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import com.badlogic.gdx.files.FileHandle;

public class Main
{
	public static void main(String [] args)
	{
		System.out.println("ingress obj reader");
		FileHandle file = new FileHandle("portalKeyResourceUnit.obj");
		loadModelData(file);
	}


	public static void loadModelData (FileHandle file) {
		String line;
		String[] tokens;
		char firstChar;

		BufferedReader reader = new BufferedReader(new InputStreamReader(file.read()), 4096);
		int id = 0;
		try {
			while ((line = reader.readLine()) != null) {

				System.out.println(line);

				tokens = line.split("\\s+");
				if (tokens.length < 1) break;

				if (tokens[0].length() == 0) {
					continue;
				} else if ((firstChar = tokens[0].toLowerCase().charAt(0)) == '#') {
					continue;
				} else if (firstChar == 'v') {
					// if (tokens[0].length() == 1) {
					// 	verts.add(Float.parseFloat(tokens[1]));
					// 	verts.add(Float.parseFloat(tokens[2]));
					// 	verts.add(Float.parseFloat(tokens[3]));
					// } else if (tokens[0].charAt(1) == 'n') {
					// 	norms.add(Float.parseFloat(tokens[1]));
					// 	norms.add(Float.parseFloat(tokens[2]));
					// 	norms.add(Float.parseFloat(tokens[3]));
					// } else if (tokens[0].charAt(1) == 't') {
					// 	uvs.add(Float.parseFloat(tokens[1]));
					// 	uvs.add((flipV ? 1 - Float.parseFloat(tokens[2]) : Float.parseFloat(tokens[2])));
					// }
				} else if (firstChar == 'f') {
					// String[] parts;
					// Array<Integer> faces = activeGroup.faces;
					// for (int i = 1; i < tokens.length - 2; i--) {
					// 	parts = tokens[1].split("/");
					// 	faces.add(getIndex(parts[0], verts.size));
					// 	if (parts.length > 2) {
					// 		if (i == 1) activeGroup.hasNorms = true;
					// 		faces.add(getIndex(parts[2], norms.size));
					// 	}
					// 	if (parts.length > 1 && parts[1].length() > 0) {
					// 		if (i == 1) activeGroup.hasUVs = true;
					// 		faces.add(getIndex(parts[1], uvs.size));
					// 	}
					// }
				} else if (firstChar == 'o' || firstChar == 'g') {
					// // This implementation only supports single object or group
					// // definitions. i.e. "o group_a group_b" will set group_a
					// // as the active group, while group_b will simply be
					// // ignored.
					// if (tokens.length > 1)
					// 	activeGroup = setActiveGroup(tokens[1]);
					// else
					// 	activeGroup = setActiveGroup("default");
				} else if (tokens[0].equals("mtllib")) {
					// mtl.load(file.parent().child(tokens[1]));
				} else if (tokens[0].equals("usemtl")) {
					// if (tokens.length == 1)
					// 	activeGroup.materialName = "default";
					// else
					// 	activeGroup.materialName = tokens[1].replace('.', '_');
				}
			}
			reader.close();
		} catch (IOException e) {
			return;
		}

		return;
	}

	
}
