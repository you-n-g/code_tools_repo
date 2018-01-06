#!/usr/bin/env python
#-*- coding:utf8 -*-

''' TODO 理解这一段话
NumPy是一个定义了数值数组和矩阵类型和它们的基本运算的语言扩展。
SciPy是另一种使用NumPy来做高等数学、信号处理、优化、统计和许多其它科学任务的语言扩展。
Matplotlib是一个帮助绘图的语言扩展。
'''

# 我们来搞定科学计算

import numpy as np
from scipy import stats

XXX_ar = stats.pearsonr([XXX])
print stats.tvar(XXX_ar), stats.tstd(XXX_ar), stats.tmean(XXX_ar)

# pearson product moment efficent
print stats.pearsonr(XXX_LISTA, XXX_LISTB)


print np.log2(1024)
print np.log10(0)
print np.log(XXX)  #it's ln

print np.exp(1)

print np.e, np.pi


def softmax(x, axis=-1):
    """Compute softmax values for each sets of scores in x on axis `axis`."""
    e_x = np.exp(x - np.max(x, axis=axis, keepdims=True))
    return e_x / e_x.sum(axis=axis, keepdims=True)



# 数学公式 # 不明白为什么叫special啊
import scipy.special as S
print S.log1p(1e-20)  ## 计算 ln(1 + 1e-20)




# 矩阵相关
# 我觉得这里有很多工具 http://blog.sina.com.cn/s/blog_70586e000100moen.html
x = np.array([
    [0, 0, 0],
    [1, 0, 0],
    [1, 1, 0],
    [1, 0, 1],
]).T  # 样本向量都按标准的列的形式给出

print np.cov(x, bias=1) # 如果需要除以 N 而不是 N-1， 则 bias=1

x = np.array([[2, 0], [0, 2]])
y = linalg.inv(x)  # 求逆矩阵


# 大概瞧一瞧数据长啥样
from scipy import stats
print stats.describe(data.astype(np.float).flatten())


# 存取数据要注意的问题
# 数据都会被转化为 array，如果是list大概感觉不到太大区别，如果是dict则需要调用下面的方法
np.load('dict_data.npy').item()




# 数据选择相关
a = np.array(range(10))
a[np.logical_and(3 < a, a < 8)] # 因为 a < 3 会返回是否满足要求的 boolean 矩阵， 这个矩阵作为选择， 最终得到筛选之后的数据。
# 但是array之间无法直接运行 and 或者 or 运算， 


# 排序相关

from scipy.stats.mstats import rankdata
# rankdata  得到的rank是从1开始的，而且相同排名时会显示排名的平均
# 数值越大 rank值越大

np.argsort



# pandas 相关  =========================================================================================
# pandas中，一张表是 pandas.core.frame.DataFrame, 一行或一列数据是pandas.core.series.Series
# 用pandas可以让数据本身包含很多信息，不用单独再对行列再进行描述
import pandas as pd
import os

csv_list = []
for fname in os.listdir(STOCK_PRICE_PATH):
    if fname.endswith('.csv'):
        fpath = os.path.join(STOCK_PRICE_PATH, fname)
        csv_list.append(pd.read_csv(fpath, encoding='utf8')) # 事后去逐行encoding会非常非常慢. 不加encoding，得到的str列都是str，而不是utf8
df = pd.concat(csv_list)
pd.reset_index(drop=True, inplace=True)

# selecting is supported.  loc只支持label来 index, 如果想按下标顺序index， 必须用iloc
df.loc[BEGIN_ROW:END_ROW, BEGIN_COL:END_COL]  # such as df.loc[1:2, 'InnerCode':'IfWeekEnd']
# 用 df.loc[A:B]和df[A:B] 是完全不一样的
# - loc会包含B，否则不包含B
# df[A] 和 df[A:B] 做的是完全不一样的事情！！ 前者是在列里面选，  后者是在行里面选
# df[A] 和 df.loc[A] 做的是完全不一会的事情！！！ 前者是在列里面选， 后者是在行里面选

for index, row in df.iterrows():
    print row["c1"], row["c2"]
# 如果是想对index进行filter，直接对 df.index 进行计算转化为boolean index就行


# 如何操作Groupby的数据: groupby后会出现多重索引
grouped_top_data = df.groupby('date')['score'].nlargest(N_LARGEST) # This will return a pandas.core.series.Series
# If you want to get index by group
for groupby_name, group in grouped_top_data.groupby(level=0):
    gidx = []
    for midx, score in group.iteritems():
        date, idx = midx
        gidx.append(idx)
    # the ineex in the group will be in gidx now
# If you want to get index directly
for midx, score in grouped_top_data.iteritems():
    date, idx = midx
    

# groupby会压缩数据，transform会变成长度相等的新的列。  http://pbpython.com/pandas_transform.html
df["total_price"] = df.groupby('order')["price"].transform('sum')


# 处理好 read_csv
## read_csv  load_csv 处理好多出来的索引列
df.to_csv("CSV_FILE")
df = pd.read_csv("CSV_FILE", index_col=0)
# OR
df.to_csv("CSV_FILE", index=False, header=False)
df = pd.read_csv("CSV_FILE")

## pandas 默认会把 na_values 中的所有字符串匹配的值都当成 NAN，如果想都把特殊列都当成字符串，不处理Nan，必须如下处理
df = pd.read_csv("CSV_FILE", keep_default_na=False, dtype={'word': np.str})


# get date number: make it easier to plot datetime
csv['trading_day'] = pd.to_datetime(csv['trading_day'])
csv['time_num'] = map(mdates.date2num, csv['trading_day'])  # TODO: will apply be faster????


# shift by group: https://stackoverflow.com/questions/26280345/pandas-shift-down-values-by-one-row-within-a-group
data.sort_values(['SecuAbbr', 'date'], inplace=True)
data['nextRisePct'] = data.groupby(['SecuAbbr'])['risePct'].shift(1)



# left join table:
all_data = pd.merge(key_score_loss_df, data.loc[:, ('date', 'SecuAbbr', 'nextRisePct')], how='left',
                    left_on = ['date', 'sec'], right_on = ['date', 'SecuAbbr'], suffixes=('', '_y'))  # suffix is necessary when 
# 看看各种情况实际运作的例子: https://pandas.pydata.org/pandas-docs/stable/merging.html#brief-primer-on-merge-methods-relational-algebra
# NOTE: 如果合并之前有两列的名称一样，会自动改成 XXX_x, XXX_y, 下面的方法可以更好地处理这种情况
# https://stackoverflow.com/questions/19125091/pandas-merge-how-to-avoid-duplicating-columns



# equal to R table
df['col_name'].value_counts() 
# sns.countplot  #我觉得这个可能是对应的图


# processing multi index
df = pd.read_csv(fname, encoding='gbk', names=['date', 'sector'], sep='\t', index_col=(0, 1))
df.index.get_level_values(0) # get the values of specific level


# Roling : https://pandas.pydata.org/pandas-docs/stable/generated/pandas.Series.rolling.html
pd.Series(STH_LIKE_LIST).rolling(window=3, min_periods=1, center=True).mean()


## 一些要注意的点
# 在 slice 上的修改有时候会影响到 原数据的, 在 numpy 也是同样的,  numpy需要用  numpy.copy才能避免
# - 一般直接看是否有 SettingWithCopyWarning就行, http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
# - 会直接修改源数据的: a.loc[a[0] < 5, 'idx'] = False
# - 不会直接修改源数据的：a.loc[a[0] < 5]['idx'] = False
# bool index 时，如果传入的是带有index的boolean值， 取值是看 index + bool的结果， 而不是
# 
# pandas 的 to_datetime 得到的对象不是 datetime,  和datetime比较时它必须放在左边

# pandas 相关  =========================================================================================



# TODO: preprocessing
from sklearn import preprocessing
# http://scikit-learn.org/stable/modules/preprocessing.html
min_max_scaler = preprocessing.MinMaxScaler()
min_max_scaler.fit(train_total_x)
train_resc_total_x = min_max_scaler.transform(train_total_x)
test_resc_total_x = min_max_scaler.transform(test_total_x)



# 验证结果相关
from sklearn.metrics import confusion_matrix, classification_report




# 坑!!!!!
# TODO: indexing, https://docs.scipy.org/doc/numpy-1.13.0/reference/arrays.indexing.html
# Index 包括
# - Basic Slicing and Indexing: 当index是integer, slice和Ellipsis。 或者这些的组合的tuple
# - Advanced Indexing: non-tuple的sequance或者ndarray 或者是他们的tuple
#   - 如果都是ndarray:  result[i_1, ..., i_M] == x[ind_1[i_1, ..., i_M], ind_2[i_1, ..., i_M],
#                                                  ..., ind_N[i_1, ..., i_M]]
#       - 相当于会把index先都broadcast到统一维度和长度，然后从这几维选择
#   - Boolean array:  x[bool_obj] 完全相当于 x[bool_obj.nonzero()]
#       - 如果只有一个有个限制： 需要index的维度和被index的维度一致，没有broadcast
#       - 否则其他index混用时， 相当于 idx.nonzero()生成的几维替换成原来的一维。
# - 如果是basic slicing和 advanced indexing 的合并，我理解是先选出slicing，然后剩下的维度扩充成advanced indexing

# 问题  a[[1, 1]]:
# - 我理解空着都是全slicing，所以这一列是Advanced indexing.

np.eye(10)[1, 1]  # 取index是 1, 1的元素
np.eye(10)[[1, 1]] # 取第一行取两遍
np.eye(10)[(1, 1)] # 取index是 1, 1的元素

# slicing 会默认return views,  对views的直接修改会影响到元数据
# - 高级indexing 一直会返回返回copy
#  - b = a[<高级index>]; b += XXX; 不会对原ll 进行影响。
#  - 但是如果是 a[<高级index>] += XXX， 会对原来影响


# Broadcasting: https://docs.scipy.org/doc/numpy-1.13.0/reference/ufuncs.html#ufuncs-broadcasting
# 当多个array做element-wize function时，按下面的规则broadcasting
# - 对齐维度: 确定最大的dimension， 先prepend 长度为1的dimension来对齐所有dimension
# - 对齐维度长度： 所有维度要么长度相等，要么长度为1.







# Jupyter notebook 相关  --------------------------
ipython nbconvert --to=python [YOUR_NOTEBOOK].ipynb  # 会生成 [YOUR_NOTEBOOK].py 文件
jupyter nbconvert --to notebook --output OUT.ipynb --execute [YOUR_NOTEBOOK].ipynb 
# 如果没有指定 --to nbtebook，默认输出类型是html
# 不加output会生成 [YOUR_NOTEBOOK].html 或者 [YOUR_NOTEBOOK].nbconvert.ipynb

# 如果你想传参进去: 默认是无法直接传入参数到 sys.argv 中的



# 可以随意地display结果
from IPython.display import display
display(df)