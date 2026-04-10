using UdonSharp;
using UnityEngine;
using VRC.SDKBase;

public class LocalTriggerDisable : UdonSharpBehaviour
{
    [Header("Objects toggled locally")]
    public GameObject[] objectsToToggle;

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        if (!player.isLocal)
            return;

        SetObjects(false);
    }

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if (!player.isLocal)
            return;

        SetObjects(true);
    }

    private void SetObjects(bool state)
    {
        for (int i = 0; i < objectsToToggle.Length; i++)
        {
            if (objectsToToggle[i] != null)
                objectsToToggle[i].SetActive(state);
        }
    }
}
