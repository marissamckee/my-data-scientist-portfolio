#!/usr/bin/env python
# coding: utf-8

# ## Marissa McKee

# # Monte Carlo Simulation -- Retirement 

# #### Description 
# This is a simulation model of retirement success. The objective is to withdraw enough money over a 30 year period to 
# sustain your lifestyle before going broke. 1 = success 0 = broke. 
# The program is simulated 1000 and 100 times iterating with the variables below: 
# 
# Starting retirement funds = $1,000,000
# 
# Withdraw = $40,000,  $60,000, $80,000, $100,000
# 
# Retirement years = 30

# In[1]:


# Import packages  
import random as rand
import matplotlib.pyplot as plot
import numpy as np
import pandas as pd
from matplotlib import colors
from matplotlib.ticker import PercentFormatter


# In[11]:


# Define one monte carlo point
def OneMonteCarlo():
    
#     Initialize variables
    retirement_fund = 1000000
    retirement_years = 30
    W = 80000
    count = 0
    portfolio_success = 0

#     Portfolio values based on yearly adjusted value times portfolio percentage
    portfolio_return = [0.926497035,0.89621396,1.239844224,1.285110926,1.066418092,
                     1.078329924,1.183028985,1.327880859,0.846390067,1.124605076,
                     1.142151055,1.09373997,1.130656008,1.223866198,1.071729769,
                     1.11371127,1.126794706,1.137591685,1.086445533,1.101092067]


#     Percentiles of portfolio returns
    fifth_percentile = np.percentile(portfolio_return,5)
    twentyfifth_percentile = np.percentile(portfolio_return,25)
    fifty_percentile = np.percentile(portfolio_return,50)
    seventyfifth_percentile = np.percentile(portfolio_return,75)
    ninetyfifth_percentile = np.percentile(portfolio_return,95)

    print('Fifth Percentile',fifth_percentile)
    print('Twenty Fifth Percentile',twentyfifth_percentile)
    print('Fiftieth Percentile',fifty_percentile)
    print('Seventy Fifth Percentile',seventyfifth_percentile)
    print('Ninety Fifth Percentile',ninetyfifth_percentile)

# Iterate through 30 years and calculate 
    while count < retirement_years:
        rand_return = rand.choice(portfolio_return)
        if count < 1:
            portfolio_value = round((1000000 * rand_return) - W,2)
        else: 
            portfolio_value = round((portfolio_value * rand_return) - W,2)
#             print('Year',count,'Portfolio Percent Return',rand_return,'Portfolio Value', portfolio_value)

        if portfolio_value <= 0:
            portfolio_value = 0 
            portfolio_success = 0
        else: 
            portfolio_success = 1
        count += 1
#     print('Portfolio success',portfolio_success)
    return portfolio_success

OneMonteCarlo()


# In[3]:


# Hundred monte carlo points 
def monteCarloHundred():
    hundred_times = 100
    i = 0
    mc_hund_list = []
    while i < hundred_times:
        x = OneMonteCarlo()
        if x is None:
            x = 0
        mc_hund_list.append(x)
        i += 1
   
    
    # Calculates the average
    avg_calc = (sum(mc_hund_list)/len(mc_hund_list))/10
    print('average', avg_calc,'100x list', mc_hund_list)
    return avg_calc
    
monteCarloHundred()


# In[4]:


# Runs a hundred monte carlo points 100 times to get the distribution of the data 
# This will later be used to compare to the theoretical mean
hundred_times = 100
i = 0
mc_hund_distro_list = []
while i < hundred_times:
    mc_hund_distro_list.append(monteCarloHundred())
    i += 1

# print('distro list',mc_hund_distro_list)


# In[5]:


# Convert list into to data frame
df_hund = pd.DataFrame(mc_hund_distro_list, columns = ['Probability of Portfolio Success'])
print('df',df_hund.head())


# In[6]:


# Thousand monte carlo points 
def monteCarloThousand():
    thousand_times = 1000
    i = 0
    mc_thous_list = []
    while i < thousand_times:
        x = OneMonteCarlo()
        if x is None:
            x = 0
        mc_thous_list.append(x)
        i += 1
   
    # Calculates the average
    avg_calc = (sum(mc_thous_list)/len(mc_thous_list))/10
#     print(avg_calc, mc_thous_list)
    return avg_calc
    
monteCarloThousand()


# In[7]:


# Runs a thousand monte carlo points 100 times to get the distribution of the data 
# This will later be used to compare to the theoretical mean
hundred_times = 100
i = 0
mc_thous_distro_list = []
while i < hundred_times:
    mc_thous_distro_list.append(monteCarloThousand())
    i += 1

print('distro list',mc_thous_distro_list)


# In[8]:


# Convert list into to data frame
df_thous = pd.DataFrame(mc_thous_distro_list, columns = ['Probability of Portfolio Success'])
print('df',df_thous.head())
print(df_thous)


# In[9]:


plot.hist(df_hund['Probability of Portfolio Success'])
# plot.axvline(color='r', linestyle='dashed', linewidth=1)
mean = df_hund.mean()
print(mean)


# In[10]:


plot.hist(df_thous['Probability of Portfolio Success'])
# plot.axvline(color='r', linestyle='dashed', linewidth=1)
mean = df_thous.mean()
print(mean)

