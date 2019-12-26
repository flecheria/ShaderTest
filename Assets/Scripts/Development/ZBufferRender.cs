using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ZBufferRender : MonoBehaviour
{
    public Material _mat;
    
    private Camera _cam;

    // Start is called before the first frame update
    void Start()
    {
        _cam = GetComponent<Camera>();
        _cam.depthTextureMode = DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, _mat);
    }
}
