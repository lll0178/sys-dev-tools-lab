# wordfreq_fast.py —— 优化版本：set 去重（O(n)），count 结果与原版一致
words = open("words.txt", encoding="utf-8").read().split()
unique = set(words)          # set 去重 O(n)，且不依赖任何写死的词表大小
print("count=", len(unique))
