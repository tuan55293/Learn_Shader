using JetBrains.Annotations;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    public int health;

    public void GetDamaged(int damage)
    {
        health = Mathf.Max(health - damage, 0);
    }
}
