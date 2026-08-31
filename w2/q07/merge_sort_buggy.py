# 原始缺陷版本（第 7 题题目给定）：else 分支误用 left 指针 i 索引 right 列表
def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i]); i += 1
        else:
            result.append(right[i]); j += 1  # 缺陷：应为 right[j]，写成 right[i]
    return result + left[i:] + right[j:]


def merge_sort(a):
    if len(a) <= 1:
        return a
    m = len(a) // 2
    return merge(merge_sort(a[:m]), merge_sort(a[m:]))


if __name__ == "__main__":
    print(merge_sort([3, 1, 4, 1, 5, 9, 2, 6]))
