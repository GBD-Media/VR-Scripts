using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class BallSpawner : UdonSharpBehaviour
{
    public GameObject ballPrefab;
    public Transform spawnPoint;
    public float spawnInterval = 2.0f;
    public float ballLifetime = 5.0f;  // Time before the oldest ball is removed
    public int maxBalls = 10; // Limit to prevent overflow

    private GameObject[] balls;
    private int nextIndex = 0;
    private bool initialized = false;

    void Start()
    {
        balls = new GameObject[maxBalls];
        initialized = true;
        SendCustomEventDelayedSeconds(nameof(SpawnBall), spawnInterval);
    }

    public void SpawnBall()
    {
        if (!initialized) return;

        // Destroy or disable the oldest ball if max is reached
        if (balls[nextIndex] != null)
        {
            balls[nextIndex].SetActive(false);  // Or Destroy(balls[nextIndex]);
        }

        // Spawn new ball
        GameObject newBall = VRCInstantiate(ballPrefab);
        newBall.transform.position = spawnPoint.position;
        balls[nextIndex] = newBall;

        // Move to next index (circular buffer)
        nextIndex = (nextIndex + 1) % maxBalls;

        // Schedule the next spawn
        SendCustomEventDelayedSeconds(nameof(SpawnBall), spawnInterval);
    }
}
