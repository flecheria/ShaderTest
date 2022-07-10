using UnityEngine;

public class FishMotion : MonoBehaviour
{
    [Header("Axis for sin Displacement calculation:\n0 = X | 1 = Y | 2 = Z")]
    [Range(0, 2)]
    [SerializeField]
    private int _axisForSinDisplacement;

    private Material fishMaterial;

    void Start()
    {
        fishMaterial = GetComponent<Renderer>().material;
        fishMaterial.SetFloat("_MoveOffset", Random.Range(0.0f, 3.14f));
    }
}