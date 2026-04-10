using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class ToggleGroupOnTrigger : UdonSharpBehaviour
{
    [Header("Parent of objects to toggle")]
    public Transform targetParent;

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        if (player.isLocal && targetParent != null)
        {
            foreach (Transform child in targetParent)
            {
                child.gameObject.SetActive(true);
            }
        }
    }

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if (player.isLocal && targetParent != null)
        {
            foreach (Transform child in targetParent)
            {
                child.gameObject.SetActive(false);
            }
        }
    }
}