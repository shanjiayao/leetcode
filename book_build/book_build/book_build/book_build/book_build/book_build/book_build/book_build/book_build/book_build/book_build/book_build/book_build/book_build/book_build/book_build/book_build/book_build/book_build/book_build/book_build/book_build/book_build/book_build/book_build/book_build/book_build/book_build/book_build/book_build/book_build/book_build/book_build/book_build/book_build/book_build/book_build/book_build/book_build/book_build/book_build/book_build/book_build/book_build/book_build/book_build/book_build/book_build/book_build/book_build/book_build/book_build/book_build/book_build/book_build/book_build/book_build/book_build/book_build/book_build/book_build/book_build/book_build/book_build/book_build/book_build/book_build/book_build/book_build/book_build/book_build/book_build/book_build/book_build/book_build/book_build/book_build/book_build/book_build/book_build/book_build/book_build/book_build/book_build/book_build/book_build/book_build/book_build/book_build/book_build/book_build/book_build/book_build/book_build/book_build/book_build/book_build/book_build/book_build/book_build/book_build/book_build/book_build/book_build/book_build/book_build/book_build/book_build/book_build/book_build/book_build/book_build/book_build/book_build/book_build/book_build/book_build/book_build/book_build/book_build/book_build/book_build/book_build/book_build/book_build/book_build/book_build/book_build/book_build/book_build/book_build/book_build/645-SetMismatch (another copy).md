- ### [645\. 错误的集合](https://leetcode-cn.com/problems/set-mismatch/)

  Difficulty: **简单**

  集合 `s` 包含从 `1` 到 `n` 的整数。不幸的是，因为数据错误，导致集合里面某一个数字复制了成了集合里面的另外一个数字的值，导致集合 **丢失了一个数字** 并且 **有一个数字重复** 。

  给定一个数组 `nums` 代表了集合 `S` 发生错误后的结果。

  请你找出重复出现的整数，再找到丢失的整数，将它们以数组的形式返回。

  **示例 1：**

  ```
  输入：nums = [1,2,2,4]
  输出：[2,3]
  ```

  **示例 2：**

  ```
  输入：nums = [1,1]
  输出：[1,2]
  ```

  **提示：**

  - `2 <= nums.length <= 10<sup>4</sup>`
  - `1 <= nums[i] <= 10<sup>4</sup>`

  ## Solution

  本题可以有多种解法，下面从时间复杂度以及空间复杂度的综合降序排列

  ### 1. 暴力遍历对比

  先遍历从1到n，然后对比每个数在nums中的出现次数，出现两次代表重复数字，出现0次代表消失

  ```python
  class Solution:
      def findErrorNums(self, nums: List[int]) -> List[int]:
          length = len(nums)
          repeat, miss = 0, 0
          # 两次遍历，第一层是从1到n的模板,第二层是数组中的数字，注意顺序，必须外层是模板，这样才能起到对比的作用
          for i in range(1, length+1):
              cnt = 0
              for j in nums:
                  if i == j:
                      cnt += 1
                  if cnt == 2:
                      repeat = i
              if cnt == 0:
                  miss = i
              if repeat != 0 and miss != 0:
                  return [repeat, miss]
  ```

  **复杂度分析**

  令 n 为数组长度。**超出时间限制**

  - 时间复杂度：$O(n^2)$
  - 空间复杂度：$O(1)$

  ### 2. 巧妙运用nums与真值的关系

  将nums转化为集合，那么集合中的元素是不包括重复元素的，可以得到

  丢失的元素 = nums - 集合

  重复的元素 = 丢失的元素  + nums - 前n项和

  ```python
  class Solution:
      def findErrorNums(self, nums: List[int]) -> List[int]:
          length = len(nums)
          miss = int((1 + length)*length/2.0) - sum(set(nums))
          repeat = miss + sum(nums) - int((1 + length)*length/2.0)
          return [repeat, miss]
  ```

  **复杂度分析**

  令 n 为数组长度。

  - 时间复杂度：$O(n)$
  - 空间复杂度：$O(n)$

  ### 3. 排序

  先排序，然后问题就变成了，判断前后数字是否相同

  注意：

  - 丢失的数与重复的数有很多中位置关系，即便排序了，丢失的数也有可能是最后一个，所以需要额外判断

  ```python
  class Solution:
      def findErrorNums(self, nums: List[int]) -> List[int]:
          nums.sort()
          repeat, miss = 0, 0
          last = 0
          for i in nums:
              if i - last == 0:
                  repeat = i
              if i - last > 1:
                  miss = i - 1
              if miss > 0 and repeat > 0:
                  return [repeat, miss]
              last = i
          # 如果遍历完，miss还是0，那说明，最后一个丢了，直接miss等于数组长度即可
          if miss == 0:
              return [repeat, len(nums)]
  ```

  **复杂度分析**

  令 n 为数组长度。

  - 时间复杂度：$O(nlogn)$
  - 空间复杂度：$O(logn)$

  ### 4. 利用哈希表

  可以利用哈希表，先遍历一遍输入的nums，然后把每个元素出现的次数记录下来，元素为 key，次数为value
  
  然后第二遍遍历从1到n的排列，判断当前的数字是否在哈希表的key里面，如果在，判断是否次数大于1.这样即可找到对应的repeat和miss
  
  ```python
  class Solution:
      def findErrorNums(self, nums: List[int]) -> List[int]:
          nums_repeat_dict = {}
          repeat, miss = 0, 0
          for i in nums:
              if nums_repeat_dict.__contains__(i):
                  nums_repeat_dict.update({i:nums_repeat_dict[i]+1})
              else:
                  nums_repeat_dict.update({i:1})
          
          for i in range(1, len(nums)+1):
              if not nums_repeat_dict.__contains__(i):
                  miss = i
              else:
                  if nums_repeat_dict[i] > 1:
                      repeat = i
          
          return [repeat, miss]
  ```
  
  **复杂度分析**
  
  令 n 为数组长度。
  
  - 时间复杂度：$O(n)$
  - 空间复杂度：$O(n)$
  
  ### 5. 利用位运算
  
  个人认为，这道题考的就是位运算的操作，因为这么做，时间和空间复杂度都是最优的。
  
  **关于位运算**，就是把每个数字元素转换为二进制，然后按位对比，一些前置知识如下：
  
  - 位运算与顺序无关，即 a ^ b = b ^ a     a ^ c ^ b ^ d = d ^ a ^ b ^ c
  - python中的位运算符有
    1. 按位与 `&`
    2. 按位或 `|`
    3. 按位异或 `^`
    4. 按位取反 `~`
    5. 左移、右移 `<<` `>>`  高位丢弃，低位补0
  
  ------
  
  这里使用位运算的**异或操作**，异或操作的一些特点如下：
  
  - 两个不同的数做异或，输出1
  - 相同的数做异或，输出0
  - 任何数与0做异或，等于自身
  
  **本题思路：**
  
  首先定义一些概念，重复的元素为`repeat`，丢失的数为`miss`，输入的列表为`nums`，无丢失情况的列表为`truth`
  
  解题思路如下：
  
  - 找到`miss ^ repeat`的结果：
  
    使用位运算的思想，就是根据异或运算的特性，一个数与自身异或，结果为0，而如果将`nums`与`truth`两个数组混合在一起，从第一个数开始，逐元素异或到最后一个数。得到的结果必定等于重复元素`repeat`与丢失元素`miss`的异或结果，因为在这个过程中，其他元素均可以找到与自身相同的数字，从而使异或结果为0.
  
  - 寻找最右比特位：
  
    我们可以先忽略最右比特位的定义，在知道`miss ^ repeat` 的结果后，实际上我们可以做一些推理，比如说，针对其中某一位，如果其等于1，那么说明 `miss` 和 `repeat` 在这一位上，一定不相同，进一步，也可以理解成，`nums` 与 `truth`所有元素混合在一起做异或后，在这一位上一定存在两个不一样的数字，使最终异或结果为1，其余数字都会两两抵消。 根据这个现象，我们就可以进一步寻找`miss`和`repeat`的值，具体做法就是对混合元素做分类，分为对应位为0或者为1两类，而上述所谓的某一位为1的情况，就可以作为分类的指标。所以，我们要寻找这个异或后结果为1的位，通常选取最右面的1，也就是**最右比特位**。
  
    总结以下就是，寻找最右比特位，然后根据最右比特位，将`nums`和`truth`所有的数字分为两类，这两类中的元素分别异或后，得到的就是`repeat`和`miss`了
  
  - 最后再遍历一次nums，根据得到的`repeat`和`miss`出现的次数，就可以判断哪个是`repeat`，哪个是`miss`了
  
  ```python
  class Solution:
      def findErrorNums(self, nums: List[int]) -> List[int]:
          xor = 0
          length = len(nums)
          # 1. 找到 repeat ^ miss的值,为了减少耗时，遍历一次
          for i in range(length):
              xor ^= i+1
              xor ^= nums[i]
          # 2. 寻找最右面的值为1的位，这里有两种方法，一种是直接用公式 right_bit = xor & (xor ^ (xor - 1))
          #    另外一种是while循环
          right_bit = 1
          while xor & right_bit == 0:
              right_bit <<= 1
          # 3. 分类，维护两个异或结果，分别是 zero_ 和 one_
          zero_, one_ = 0, 0
          for i in range(length):
              if (i+1) & right_bit:
                  one_ ^= i+1
              else:
                  zero_ ^= i+1
  
              if nums[i] & right_bit:
                  one_ ^= nums[i]
              else:
                  zero_ ^= nums[i]
          # 4. 最后一次遍历，根据出现次数，判断哪个是miss，in操作的时间复杂度等于 O(n)，所以这里简写了
          return [zero_, one_] if one_ not in nums else [one_, zero_]
  ```
  
  **复杂度分析**
  
  令 n 为数组长度。
  
  - 时间复杂度：$O(n)$
  - 空间复杂度：$O(1)$