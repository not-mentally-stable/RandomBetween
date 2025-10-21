# 🎲 RandomBetween
A **universal randomization utility** for Roblox Luau that supports multiple Roblox datatypes powered by `Random.new()` for *unpredictable, high-quality randomness* (unlike `math.random`, which is deterministic).  
This function simplifies random value generation for `number`, `Vector3`, `Color3`, `CFrame`, `UDim2`, `BrickColor`, and even `boolean` types all in one unified API.

---
# ✨ Features
- ✅ Supports **multiple Roblox datatypes**
- ⚙️ Optional `step` parameter for **discrete stepped random values**
- 🔒 Uses **`Random.new()`** avoids the predictability of `math.random`
- 💡 Clean, consistent interface inspired by Roblox-style APIs
- 🧩 Can be globally accessed via `_G.RandomBetween`

---
# 📘 Function Signature
```Luau
RandomBetween(a: any, b: any, step: Number?): any
```

# ⚙️ Supported Types

Type | Description

`number`	Random integer or float

`Vector3`	Randomized 3D vector between two vectors

`Color3`	Random RGB color between two colors

`CFrame`	Random position-only CFrame between two CFrames

`UDim2`	Random UDim2 between two UDim2 values

`BrickColor`	Random BrickColor within the ID range

`boolean`	Random `true` / `false` when inputs differ

---
# 🧠 Behavior Overview
Uses Random.new() internally & each call is independent.

If both numbers are integers and no step is given → returns integer.
If step is provided → values are snapped to step increments.
When used with compound types (e.g., Vector3, Color3), stepping is applied per component.
For CFrame, only position is randomized rotation is ignored.

---
# 💻 Examples

**Numbers:**

```Luau
local RandomBetween = _G.RandomBetween

print(RandomBetween(1, 5))              
--> e.g. 3

print(RandomBetween(1.5, 1.9))          
--> e.g. 1.742948273

print(RandomBetween(1.5, 1.9, 0.1))     
--> 1.5, 1.6, 1.7, 1.8, or 1.9
```

**Vector3:**
```Luau
local a = Vector3.new(0, 0, 0)
local b = Vector3.new(5, 5, 5)

print(RandomBetween(a, b))
--> Vector3.new(3.24, 1.88, 4.71)
```

**Color3:**
```Luau
print(RandomBetween(Color3.new(0, 0, 0), Color3.new(1, 1, 1)))
--> Color3.new(0.42, 0.87, 0.15)
```

**CFrame:**
```Luau
local c1 = CFrame.new(0, 0, 0)
local c2 = CFrame.new(10, 10, 10)
print(RandomBetween(c1, c2))
--> CFrame.new(7.23, 2.94, 8.11)
```

**Booleans:**
```Luau
print(RandomBetween(true, false))
--> true or false

print(RandomBetween(true, true))
--> true
```

---
# 🧩 Implementation
The function is globally registered in [_G](https://devforum.roblox.com/t/how-do-i-use-g-in-roblox-scripting/2116907) you can call it anywere with this:
```Luau
_G.RandomBetween(a, b, c?): any?
```
you dont need to require it like a module

---
# 🛡️ Notes
``Random.new()`` seeds itself automatically, providing stronger randomness.
Each call is independent; results are not influenced by previous calls.
For reproducible randomness (e.g., deterministic generation), modify the script to accept a seeded Random object.

---
# Q&A
## 🎲 Why `Random.new()` Is Better Than `math.random()`
Most developers assume `math.random()` gives truly random results but in Roblox (and Lua in general), it **does not**.  

### 🔍 How `math.random()` Works
`math.random()` uses a **shared global pseudo-random number generator (PRNG)** that is initialized by `math.randomseed()`.  
When the Roblox engine starts, the global generator is **seeded deterministically**, often based on the system clock at startup.

This means:
- Every new server or Studio session **starts with the same seed** pattern.
- Unless you call `math.randomseed(os.time())` (or something similar), the sequence of values from `math.random()` is **the same every time** you run your code.
- Even if reseeded, results remain **predictable** once the seed is known, because the PRNG algorithm is deterministic.

In Roblox, `math.random` is implemented with a **Linear Congruential Generator (LCG)** a simple algorithm that is *fast*, but **not cryptographically secure** and **not statistically strong**.  
That makes it unsuitable for things like procedural generation, fairness mechanics, or any system relying on *unbiased* randomness.

### 🧠 Why `Random.new()` Is Better
Roblox introduced the [`Random`](https://create.roblox.com/docs/reference/engine/datatypes/Random) datatype to solve these issues.
When you call:
```Luau
local rng = Random.new()
```
before you say "wait Isn’t `Random.new()` Still Pseudo-Random?"
Yes, absolutely! Both `math.random()` and `Random.new()` are **PRNGs** (*pseudo-random number generators*).  
However, Roblox’s `Random` class uses a **different implementation** that provides **much higher-quality randomness**.

---
### ⚙️ The Difference Explained

| Aspect | `math.random` | `Random.new()` |
|--------|----------------|----------------|
| Type | Global PRNG (LCG-based) | Instance-based PRNG (Roblox internal generator) |
| Seeding | Shared global state | Each instance is uniquely and internally seeded |
| Predictability | High repeats across sessions | Low new seed each time |
| Independence | Shared by all scripts | Each `Random` object is isolated |
| Random Quality | Lower statistical uniformity | Higher-quality distribution |
| Reproducible | Only via `math.randomseed()` | Via `Random.new(seed)` |

---
### 🔍 Why This Matters
- `math.random()` uses a **linear congruential generator (LCG)**, a simple, old algorithm that repeats predictable patterns.  
  Once its seed is known, anyone can predict all future values.

- `Random.new()` also uses a PRNG — but a **different algorithm**, with **better entropy**, and seeded internally using **engine-level randomness sources**.  
  This makes it *far less predictable* and *less likely to repeat patterns* unintentionally.

- Each call to `Random.new()` creates a **new, independent stream** of random numbers.  
  This isolation prevents cross-script interference — an issue that occurs when multiple scripts rely on `math.random()`’s global state.

---
### 🧩 True Random vs. Pseudo-Random
| Type | Description | Source |
|:-----|:------------|:-------|
| **True Random** | Generated from physical or environmental noise (e.g., hardware RNGs, atmospheric sensors) | Hardware |
| **Pseudo-Random (PRNG)** | Generated by a deterministic algorithm from a seed | Software 

Roblox does **not** expose a true random source so all randomness in Studio and runtime scripts is **pseudo-random**.  
`Random.new()` simply provides a **better, isolated, higher-quality** PRNG compared to the old `math.random()`.

---
### 💡 In Short
> Both are pseudo-random,  
> but `Random.new()` is **less predictable**, **more statistically uniform**, and **safer** for modern game systems.
> but 100% true randomness is impossible in pure Luau but this is asclose we can get really
---
# Misc...
[![License: ](https://img.shields.io/badge/License%3A-MIT-green?style=plastic)](https://github.com/not-mentally-stable/RandomBetween/blob/main/LICENSE)

[![Scripting Language: LUAU](https://img.shields.io/badge/Scripting%20Language%3A-LUAU-blue?style=plastic)](https://github.com/luau-lang/luau)
