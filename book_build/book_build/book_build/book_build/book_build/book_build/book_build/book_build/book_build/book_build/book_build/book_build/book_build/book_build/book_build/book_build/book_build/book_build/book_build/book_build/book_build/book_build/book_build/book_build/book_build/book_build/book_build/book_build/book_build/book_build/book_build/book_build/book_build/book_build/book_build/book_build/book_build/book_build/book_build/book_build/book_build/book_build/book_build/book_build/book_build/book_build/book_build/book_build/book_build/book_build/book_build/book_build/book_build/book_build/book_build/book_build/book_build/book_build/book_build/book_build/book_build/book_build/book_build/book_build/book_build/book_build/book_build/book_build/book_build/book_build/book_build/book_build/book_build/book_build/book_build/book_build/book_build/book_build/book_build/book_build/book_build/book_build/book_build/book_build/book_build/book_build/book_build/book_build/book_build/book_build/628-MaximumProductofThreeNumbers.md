### [628\. 三个数的最大乘积](https://leetcode-cn.com/problems/maximum-product-of-three-numbers/)

Difficulty: **简单**

给你一个整型数组 `nums` ，在数组中找出由三个数组成的最大乘积，并输出这个乘积。

**示例 1：**

```
输入：nums = [1,2,3]
输出：6
```

**示例 2：**

```
输入：nums = [1,2,3,4]
输出：24
```

**示例 3：**

```
输入：nums = [-1,-2,-3]
输出：-6
```

**提示：**

- `3 <= nums.length <= 10<sup>4</sup>`
- `1000 <= nums[i] <= 1000`

### Solution

首先考虑好，最大的三数乘积都存在哪几种情况

1. 全为非正数
2. 全为非负数
3. 有正有负

那么，为了更好的区分正负，我们先对列表排序，使用python内置的sort函数，默认升序排列

下一步就是分两步判断：

- 如果全为非负数或者非正数，那么排序后的最大三数乘积，就是最大值
- 如果有负有正，那么需要对比，最大三数与最小两个数乘以最大数，这两组乘积的结果

## Code

```python
class Solution:
    def maximumProduct(self, nums: List[int]) -> int:
        if len(nums) == 3:
            return nums[0] * nums[1] * nums[2]
        nums.sort()   # 升序排列
        return max(nums[0] * nums[1] * nums[-1], nums[-1] * nums[-2] * nums[-3])
```

**复杂度分析**

令 n 为数组长度。

- 时间复杂度：$O(nlogn)$ `Timsort`
- 空间复杂度：$O(n)$