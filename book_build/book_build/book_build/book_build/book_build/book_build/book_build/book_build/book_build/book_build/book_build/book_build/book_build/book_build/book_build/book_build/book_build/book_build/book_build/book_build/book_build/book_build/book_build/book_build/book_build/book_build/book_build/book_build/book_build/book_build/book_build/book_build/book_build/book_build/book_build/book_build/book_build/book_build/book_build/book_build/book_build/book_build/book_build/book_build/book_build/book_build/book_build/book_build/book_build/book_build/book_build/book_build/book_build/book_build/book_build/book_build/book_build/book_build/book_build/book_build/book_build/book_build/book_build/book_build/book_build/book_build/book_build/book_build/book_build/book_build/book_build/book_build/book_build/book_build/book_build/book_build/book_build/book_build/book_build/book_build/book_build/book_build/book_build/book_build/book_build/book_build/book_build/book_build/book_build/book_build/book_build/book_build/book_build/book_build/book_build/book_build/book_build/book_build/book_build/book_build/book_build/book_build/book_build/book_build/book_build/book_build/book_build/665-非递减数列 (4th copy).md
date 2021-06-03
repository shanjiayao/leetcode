### [665\. 非递减数列](https://leetcode-cn.com/problems/non-decreasing-array/)

Difficulty: **简单**

给你一个长度为 `n` 的整数数组，请你判断在 **最多** 改变 `1` 个元素的情况下，该数组能否变成一个非递减数列。

我们是这样定义一个非递减数列的： 对于数组中任意的 `i` `(0 <= i <= n-2)`，总满足 `nums[i] <= nums[i + 1]`。

**示例 1:**

```
输入: nums = [4,2,3]
输出: true
解释: 你可以通过把第一个4变成1来使得它成为一个非递减数列。
```

**示例 2:**

```
输入: nums = [4,2,1]
输出: false
解释: 你不能在只改变一个元素的情况下将其变为非递减数列。
```

**提示：**

- `1 <= n <= 10 ^ 4`
- `10 ^ 5 <= nums[i] <= 10 ^ 5`

### Solution

关于数组的非递减性，可以认为每个元素按顺序前后相等或递增，如下所示

![](https://raw.githubusercontent.com/shmilywh/PicturesForBlog/master/2021/03/31-00-15-19-2021-03-31-00-15-15-image.png)

那么如果其中有一个元素或多个元素破坏了这种递增，我们以一个元素为例，如下

![](https://raw.githubusercontent.com/shmilywh/PicturesForBlog/master/2021/03/31-00-16-29-2021-03-31-00-16-25-image.png)

这时，整个数组被分成了两部分，0-1是单调递增的，2-4也是单调递增的，只有中间部分1-2是递减的，这时我们需要判断，当前这种递减可否通过改变一个元素来消除。具体分为以下几个部分

1. 改变哪个元素？
   
   当然是选取临界点的值，可以看到，上图中要么改变nums[i-1]，要么改变nums[i]。

2. 如何改变？
   
   目前的情况是nums[i-1]比nums[i]对应的数值大，所以有两种方案：
   
   - nums[i-1]减小，目标区间是 [nums[i-2], nums[i]]，如果nums[i-2]小于nums[i]，则此方案不成立
   - nums[i]增大，目标区间是 [nums[i-1], nums[i+1]]，如果nums[i-1]小于nums[i+1]，则此方案不成立
   - 如果以上两种方案均不成立，则返回`False`

3. 特殊情况判断？
   
   - 递减情况发生在数组的前两个数或最后两个数？
     
     比如[4, 2, 3]，这时应该把nums[i-2]设成负无穷，把num[i+1]设为正无穷，这样就可以通过了

4. 最后别忘了，上述情况只是一个递减的数字，若有多个，还是要返回False的

```python
class Solution:
    def checkPossibility(self, nums: List[int]) -> bool:
        last_ = nums[0]
        decrease = 0
        for i in range(1, len(nums)):
            if last_ > nums[i]:
                left_ = nums[i-2] if i > 1 else float('-inf')
                right_ = nums[i+1] if i < len(nums)-1 else float('inf')
                if left_ > nums[i] and last_ > right_:
                    return False
                decrease += 1
            last_ = nums[i]
        return True if decrease <= 1 else False
```

**复杂度分析**

令 n 为数组长度。

- 时间复杂度：O(n)
- 空间复杂度：O(1)