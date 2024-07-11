# python implementation of OLAP operation
import pandas as pd
import sqlite3

data={
    'year': [2020, 2020, 2021, 2021, 2022, 2022],
    'month': [1, 2, 1, 3, 4, 5],
    'price': [1000, 2000, 5000, 3000, 4000,2000],
    'city': ['Kolkata', 'Mumbai','Pune', 'Hydrabad','Digha', 'Pune'],
    'State': ['WestBengal','Maharashtra','Maharashtra','MadhyaPradesh','WestBengal','Maharashtra']
}

sales_df = pd.DataFrame(data)
conn = sqlite3.connect('sales_df.db')
sales_df.to_sql('data', conn,if_exists='replace',index=False)

#quaries
quary = 'select * from data'
quary1 = 'select sum(price) Total_Price, state from data group by state'
quary2 = 'select sum(price) Total_Price, year from data group by year'

#for slice
quary3 = 'select * from data where city = "Kolkata" '

# get results
result = pd.read_sql_query(quary,conn)
result1 = pd.read_sql_query(quary1, conn)
result2 = pd.read_sql_query(quary2, conn)
result3 = pd.read_sql_query(quary3, conn)

# print results
print(f"The complete table is : \n{result}")
print(f"\nThe sales stateswise : \n{result1}")
print(f"\nThe sales yearswise : \n{result2}")
print(f"\nThe table citywise : \n{result3}")

conn.close()