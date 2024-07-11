using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    private Vector3 _cameraPosition;
    private Quaternion _cameraRotation;

    [Header("Camera Settings")]
    [SerializeField]
    private float _cameraSpeed;

    [SerializeField]
    private Quaternion _rotationSpeed;

    private void Start()
    {
        _cameraPosition = transform.position;
        _cameraRotation = transform.rotation;
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.W))
        {
            _cameraPosition.z += _cameraSpeed / 10;
        }

        if (Input.GetKey(KeyCode.S))
        {
            _cameraPosition.z -= _cameraSpeed / 10;
        }

        if (Input.GetKey(KeyCode.A))
        {
            _cameraPosition.x += _cameraSpeed / 10;
        }

        if (Input.GetKey(KeyCode.D))
        {
            _cameraPosition.x -= _cameraSpeed / 10;
        }

        transform.position = _cameraPosition;
        transform.rotation = _cameraRotation;
    }
}
