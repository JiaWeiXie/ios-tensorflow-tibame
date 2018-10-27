import tensorflow as tf

#  建立運算圖
hello = tf.constant('hello world')

# 進行運算
session = tf.Session()
print(session.run(hello))

session.close()