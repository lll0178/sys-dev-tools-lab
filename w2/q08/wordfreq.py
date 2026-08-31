# wordfreq.py —— 原始版本（去重用 list + in，O(n^2) 复杂度）
words = open("words.txt", encoding="utf-8").read().split()
unique = []
for word in words:
    if word not in unique:   # list 的 in 是线性扫描，整体 O(n^2)
        unique.append(word)
print("count=", len(unique))
