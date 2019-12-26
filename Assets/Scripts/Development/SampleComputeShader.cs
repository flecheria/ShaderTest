using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SampleComputeShader : MonoBehaviour
{
    public ComputeShader _cShader;
    public RenderTexture _result;

    // Start is called before the first frame update
    void Start()
    {
        int kernel = _cShader.FindKernel("CSMain");

        _result = new RenderTexture(512, 512, 24);
        _result.enableRandomWrite = true;
        _result.Create();

        _cShader.SetTexture(kernel, "Result", _result);
        _cShader.Dispatch(kernel, 512/8, 512/8, 1);
    }

}
