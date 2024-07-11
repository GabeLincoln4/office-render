using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PointLightAdjuster : MonoBehaviour
{
    [SerializeField]
    private Transform _pointLights;

    [Range(0f, 75f)]
    public float _pointLightsRange;

    private void AdjustPointLights()
    {
        Light pointLight = _pointLights.GetComponentInChildren<Light>();

        if (pointLight != null)
        {
            pointLight.range = _pointLightsRange;
        }
        else
        {
            Debug.Log("Point light is null.");
        }
    }
}
