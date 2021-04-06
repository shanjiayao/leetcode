### [697\. 数组的度](https://leetcode-cn.com/problems/degree-of-an-array/)

Difficulty: **简单**

给定一个非空且只包含非负数的整数数组 `nums`，数组的度的定义是指数组里任一元素出现频数的最大值。

你的任务是在 `nums` 中找到与 `nums` 拥有相同大小的度的最短连续子数组，返回其长度。

**示例 1：**

```
输入：[1, 2, 2, 3, 1]
输出：2
解释：
输入数组的度是2，因为元素1和2的出现频数最大，均为2.
连续子数组里面拥有相同度的有如下所示:
[1, 2, 2, 3, 1], [1, 2, 2, 3], [2, 2, 3, 1], [1, 2, 2], [2, 2, 3], [2, 2]
最短连续子数组[2, 2]的长度为2，所以返回2.
```

**示例 2：**

```
输入：[1,2,2,3,1,4,2]
输出：6
```

**提示：**

- `nums.length` 在1到 50,000 区间范围内。
- `nums[i]` 是一个在 0 到 49,999 范围内的整数。

### Solution

先明白数组的度，然后对于本题来说，需要先计算频数，再计算频数**最大**时，对应的**最小**子数组的长度。

使用哈希表，为了方便，每个元素作为key，对应的value是一个列表，分别是：

1. 第一次出现的索引
2. 最长长度（两索引之差）
3. 出现次数

然后对哈希表的values进行遍历，维护两个值，分别是最大频数和最小长度，最终输出最小长度即可

```python
class Solution:
    def findShortestSubArray(self, nums: List[int]) -> int:
        hash_dict = {}
        for i in range(len(nums)):
            if nums[i] not in hash_dict:
                hash_dict.update({nums[i]: [i, 0, 1]})
            elif nums[i] in hash_dict:
                dist = i - hash_dict[nums[i]][0] if i - hash_dict[nums[i]][0] > hash_dict[nums[i]][1] else hash_dict[nums[i]][1]
                hash_dict.update({nums[i]: [hash_dict[nums[i]][0], dist, hash_dict[nums[i]][-1]+1]})

        max_freq = 0
        min_dist = 50001
        for _, dist, freq in hash_dict.values():
            if freq > max_freq:
                max_freq = freq
                min_dist = dist
            elif freq == max_freq:
                if min_dist > dist:
                    min_dist = dist

        return min_dist+1
```

**复杂度分析**

令 n 为数组长度。

- 时间复杂度：O(n)
- 空间复杂度：O(n)