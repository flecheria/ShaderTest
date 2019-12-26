using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class MeshData : MonoBehaviour
{
    
    void Start()
    {
        Mesh m = GetComponent<MeshFilter>().mesh;
        Vector3[] vs = m.vertices;

        foreach (Vector3 v in vs)
        {
            Debug.Log(v);
        }

        float max = vs.Select(v => v.x).Max();
        float min = vs.Select(v => v.x).Min();

        Debug.LogFormat("min: {0} max: {1}", min, max);
    }
}
