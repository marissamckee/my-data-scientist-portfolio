#!/usr/bin/env python
# coding: utf-8

# ## Marissa McKee 

# # Monte Carlo Simulation - Gambler's Ruin

# #### Description 
# This is a simulation model of the gambler’s ruin problem. The gambler’s objective is to meet the goal before being ruined. 
# In other words, go broke. If the gambler succeeds it is said that he or she wins the game. The gambler can play timidly or
# boldly. Timid play is described as making the minimum bet every time, $1. Bold play is described as betting the entire 
# fortune or just enough to meet the goal. The game is played 100 and 100 times iterating with the variables below: 
# 
# p = .25, .50, .75
# starting fortune = $2, $5, $8, $20, $50, $80
# goal = 10, 100
# broke = 0 

# In[1]:


# Code Smell:
#     One monte carlo point function occasionally returns a 'None' value. 
#     The 'None' value is replaced by the number 0. 
#     Results may be less accurate because of this. 


# In[2]:


# Import packages  
import random as rand
import matplotlib.pyplot as plot
import numpy as np
import pandas as pd
from matplotlib import colors
from matplotlib.ticker import PercentFormatter


# In[3]:


# One monte carlo point
def oneMonteCarlo(fortune,wager,times_through):
    p = .5 # Change for new runs
    count = 0
    goal = 10 # Change for new runs
    broke = 0
    while count < times_through: 
#       probability of winning plus/minus wager
        prob_w = rand.random()
        if prob_w <= p: 
            fortune += wager
        elif prob_w > p:
            fortune -= wager
            
#       sets fortune if beyond 0 or 10
        if fortune >= goal:
            fortune = goal
            return fortune
            break
        elif fortune <= broke:
            fortune = broke
            return fortune
            break
        count += 1
        if fortune is None:
            fortune = 0
            break

# Execute oneMonteCarlo function 
# Define your starting fortune, increment, iterative times 
oneMonteCarlo(5,4,10)


# In[13]:


# Hundred monte carlo points 
def monteCarloHundred():
    hundred_times = 100
    i = 0
    mc_hund_list = []
    while i < hundred_times:
        x = oneMonteCarlo(5,4,10)
        if x is None:
            x = 0
        mc_hund_list.append(x)
        i += 1
   
    
    # Calculates the average
    avg_calc = (sum(mc_hund_list)/len(mc_hund_list))/10
#     print('average', avg_calc,'100x list', mc_hund_list)
    return avg_calc
    
monteCarloHundred()


# In[14]:


# Runs a hundred monte carlo points several times (20 to start with) to get the distribution of the data 
# This will later be used to compare to the theoretical mean
hundred_times = 100
i = 0
mc_hund_distro_list = []
while i < hundred_times:
    mc_hund_distro_list.append(monteCarloHundred())
    i += 1

# print('distro list',mc_hund_distro_list)


# In[6]:


# Convert list into to data frame
df_hund = pd.DataFrame(mc_hund_distro_list, columns = ['Probability Win'])
print('df',df_hund.head())


# In[7]:


# Thousand monte carlo points 
def monteCarloThousand():
    thousand_times = 1000
    i = 0
    mc_thous_list = []
    while i < thousand_times:
        x = oneMonteCarlo(5,4,10)
        if x is None:
            x = 0
        mc_thous_list.append(x)
        i += 1
   
    # Calculates the average
    avg_calc = (sum(mc_thous_list)/len(mc_thous_list))/10
#     print(avg_calc, mc_thous_list)
    return avg_calc
    
monteCarloThousand()


# In[15]:


# Runs a thousand monte carlo points several times (20 to start with) to get the distribution of the data 
# This will later be used to compare to the theoretical mean
hundred_times = 100
i = 0
mc_thous_distro_list = []
while i < hundred_times:
    mc_thous_distro_list.append(monteCarloThousand())
    i += 1

# print('distro list',mc_thous_distro_list)


# In[9]:


# Convert list into to data frame
df_thous = pd.DataFrame(mc_thous_distro_list, columns = ['Probability Win'])
print('df',df_thous.head())


# In[10]:


# Theoretical calculation 
f = 5
prob = .50000001
g = 10
r = ((1-prob)/prob)
theory_calc = float((1.0-pow(r, f))/float((1.0-pow(r, g))))
print(theory_calc)


# In[19]:


plot.hist(df_hund['Probability Win'])
plot.axvline(theory_calc, color='r', linestyle='dashed', linewidth=1)
mean = df_hund.mean()
print(mean)
print('Theory mean', theory_calc)


# In[22]:


plot.hist(df_thous['Probability Win'])
plot.axvline(theory,l_calc, color='r', linestyle='dashed', linewidth=1)
mean = df_thous.mean()
print(mean)
print('Theory mean', theory_calc)


# In[ ]:





# In[ ]:




