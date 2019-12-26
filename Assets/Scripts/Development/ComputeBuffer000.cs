using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class ComputeBuffer000 : MonoBehaviour
{
    const int _totalPoints = 4;
    public Material _geometryMaterial;
    ComputeBuffer _computeBuffer;

    [StructLayout(LayoutKind.Sequential)]
    struct ComputeBufferData
    {
        public const int size =
            sizeof(float) * 3 +
            sizeof(float) * 3 +
            sizeof(float) * 1;

        public Vector3 centerPosition;
        public Vector3 color;
        public float scale;
    }

    // Start is called before the first frame update
    void Start()
    {
        // Generate 4 individual points.  Each point will be expanded into a quad made up
        // of two triangles via the Geometry Shader.  Each quad will have its own position,
        // color, and scale.  We will be using instancing to submit a single draw call with all 4 points.
        ComputeBufferData[] computeBufferData = new ComputeBufferData[_totalPoints];

        computeBufferData[0] = new ComputeBufferData();
        computeBufferData[0].centerPosition = new Vector3(-2, 0, 3);
        computeBufferData[0].color = new Vector3(1, 0, 0);
        computeBufferData[0].scale = 0.5f;

        computeBufferData[1] = new ComputeBufferData();
        computeBufferData[1].centerPosition = new Vector3(0, 1, 3);
        computeBufferData[1].color = new Vector3(0, 1, 0);
        computeBufferData[1].scale = 0.3f;

        computeBufferData[2] = new ComputeBufferData();
        computeBufferData[2].centerPosition = new Vector3(0, -1, 3);
        computeBufferData[2].color = new Vector3(0, 0, 1);
        computeBufferData[2].scale = 0.3f;

        computeBufferData[3] = new ComputeBufferData();
        computeBufferData[3].centerPosition = new Vector3(2, 0, 3);
        computeBufferData[3].color = new Vector3(1, 1, 0);
        computeBufferData[3].scale = 0.5f;
        
        // Create the compute buffer and assign it our custom data.
        // SetData will only copy our data to CPU memory.
        // The data will be uploaded to the GPU later when
        // we bind the compute buffer to the shader via the material.
        _computeBuffer = new ComputeBuffer(_totalPoints, ComputeBufferData.size);
        _computeBuffer.SetData(computeBufferData);
    }

    // Update is called once per frame
    void OnPostRender()
    {
        // Use the geometry shader and bind the compute buffer data to the shader
        // as a structured buffer resource that can be indexed via the current instancce id.
        _geometryMaterial.SetPass(0);
        _geometryMaterial.SetBuffer("_ComputeBufferData", _computeBuffer);

        // Instanced draw call which will contain all 4 point's data.
        Graphics.DrawProceduralNow(MeshTopology.Points, 1, _totalPoints);
    }
}
