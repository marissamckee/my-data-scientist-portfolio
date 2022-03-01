#!/usr/bin/env python
# coding: utf-8

# ### Marissa McKee
# #### Introduction to TensorFlow
# UNT ADTA 5550 Summer 2020

# In[1]:


import tensorflow as tf


# ### Question 4.1
# Declare two constant tensors that have the values of 15 and 45. Add these two tensors and print out the results.

# In[2]:


# Declare constants
const1 = tf.constant(15)
const2 = tf.constant(45)

# Sum of constants
equation = const1+const2

# tf.Session() allows to execute operations
with tf.Session() as sesh:
    result = sesh.run(equation)

# Print results
print('Sum of constants = ',result)

# Close the session
sesh.close()


# ### Question 4.2
# Declare two variable tensors, a and b, that are initialized with scalar values of 2.75 and 8.5. Find their product and print out the result.

# In[3]:


# Declare variables
a = tf.Variable(2.75)
b = tf.Variable(8.5)

# tf.global_variables_initializer() initializes variables
# Ensures the declared values are set
init = tf.global_variables_initializer()

# Product of variables
equation = tf.math.multiply(a,b)

# Execute operations
with tf.Session() as sesh:
    sesh.run(init)
    result = sesh.run(equation)
   
# Print results
print('Product of variables = ',result)

# Close the session
sesh.close()


# ### Question 4.3
# Create two placeholders: x and y - that are both scalars of 32-bit floats. Assign 5.25 to x and 12.6 to y, multiply them together, and print out the results.

# Placeholder: a variable that will be assigned data at a later point. It allows us to create operations and build without needing data.

# In[4]:


# Declare placeholders
x = tf.placeholder(tf.float32, None)
y = tf.placeholder(tf.float32, None)

# Product of variables
equation = tf.math.multiply(x,y)

# Feed placeholders with values and execute operations
with tf.Session() as sesh:
    result = sesh.run(equation,feed_dict={x: 5.25, y: 12.6})
 
# Print results
print('Product of placeholders = ', result)

# Close the session
sesh.close()


# ### Question 4.4
# Create one placeholder: z - that is an N-Dimensional array (N can be >= 1) that can have any shape (shape = None). Feed this vector [1, 3, 5, 7, 9] into z and multiply it by 3. Display the results.

# In[5]:


# Declare placeholder
z = tf.placeholder(tf.int8,shape=None)

# Product of placeholder
equation = tf.math.multiply(z,3)

# Feed placeholder with values and execute operations
with tf.Session() as sesh:
    result = sesh.run(equation,feed_dict={z: [1,3,5,7,9]})

# Print results
print('Product of vector = ',result)

# Close the session
sesh.close()


# ### Question 4.5
# Create a constant tensor that is a matrix of the shape (8, 8). The matrix is initialized with all ones (1). Create a variable tensor that is also a matrix of the shape (8, 8) and initialized with random integer values between 0 and 99. Add these two tensors and display the results.

# In[6]:


# Decalre constant and variables
matrix1 = tf.constant(1,shape=(8,8))
value = tf.random_uniform((8,8),0,99,dtype=tf.int32)
matrix2 = tf.Variable(value)

equation = matrix1+matrix2

# Initialize variables
init = tf.global_variables_initializer()

with tf.Session() as sesh:
    sesh.run(init)
    result1 = sesh.run(matrix1)
    result2 = sesh.run(matrix2)
    finalresult = sesh.run(equation)

print('Matrix 1:\n',result1,'\n\nMatrix 2:\n',result2,'\n\nSum of matrices:\n',finalresult)    

# Close the session
sesh.close()


# In[ ]:




