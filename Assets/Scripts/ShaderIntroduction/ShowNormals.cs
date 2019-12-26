using UnityEngine;

[ExecuteInEditMode]
public class ShowNormals : MonoBehaviour {

    [Range(-10, 10)]
    public float nx;

    [Range(-10, 10)]
    public float ny;

    [Range(-10, 10)]
    public float nz;

    //to display length
    public float normal_length;

    // Update is called once per frame
    void Update() {

        Mesh mesh = GetComponent<MeshFilter>().sharedMesh;

        Vector3[] vertices = mesh.vertices;
        Vector3[] normals = mesh.normals;

        Vector3 modNormal = new Vector3(normals[0].x * nx, normals[0].y * ny, normals[0].z * nz);
        normal_length = modNormal.magnitude;

        for (var i = 0; i < normals.Length; i++) {
            Vector3 pos = vertices[i];

            // scale
            pos.x *= transform.localScale.x;
            pos.y *= transform.localScale.y;
            pos.z *= transform.localScale.z;
            // position
            pos += transform.localPosition;
            // rotation
            //pos = Vector3.Scale(pos, transform.rotation.eulerAngles);
            //Vector3 posRot = transform.rotation * pos;

            normals[i].x *= nx;
            normals[i].y *= ny;
            normals[i].z *= nz;

            Debug.DrawLine(pos, pos + normals[i], Color.red);
        }
    }
}
