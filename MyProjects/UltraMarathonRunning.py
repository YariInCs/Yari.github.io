import pandas as pd
import seaborn as sns
df = pd.read_csv("TWO_CENTURIES_OF_UM_RACES.csv")
df.head(10)
df.shape
df.dtypes
#clean up data
#only want usa races, 50k or 50 mi, 2020
#step 1 show 50mi or 50k
#50km
#50mi
df[df['Event distance/length'] == '50km']
#combine 50k and 50 mi with isin
df[(df['Event distance/length'].isin(['50km','50mi'])) & (df['Year of event'] == 2020)]
df[df['Event name'] == 'Everglades 50 Mile Ultra Run (USA)']['Event name'].str.split('(').str.get(1).str.split(')').str.get(0)
df[df['Event name'].str.split('(').str.get(1).str.split(')').str.get(0) == 'USA']
#combine all the fillters
df[(df['Event distance/length'].isin(['50km','50mi'])) & (df['Year of event'] == 2020) & (df['Event name'].str.split('(').str.get(1).str.split(')').str.get(0) == 'USA')]
df2 = df[(df['Event distance/length'].isin(['50km','50mi'])) & (df['Year of event'] == 2020) & (df['Event name'].str.split('(').str.get(1).str.split(')').str.get(0) == 'USA')]
df2.head(10)
df2.shape 
#remove (USA) from event name
df2['Event name'] = df2['Event name'].str.split('(').str.get(0)
df2.head()
#clean up athlete age
df2['athlete_age'] = 2020 - df2['Athlete year of birth']
#remove h from athlete performance
df2['Athlete performance'] = df2['Athlete performance'].str.split(' ').str.get(0)
df2.head(5)
#drop columns: Athlete clubs, Athlete country, Athlete year of birth, Athlete age category
df2.dtypes
df2 = df2.drop(['Athlete club', 'Athlete country', 'Athlete year of birth', 'Athlete age category'], axis = 1)
df2.head()
#clean up null
df2.isna().sum()
df2.dtypes
df2[df2['athlete_age'].isna()==1]
df2 = df2.dropna()
df2.shape  
#check for dupes
df2[df2.duplicated() == True]
#reset  index
df2.reset_index(drop = True)
#fix types
df2.dtypes
df2['athlete_age'] = df2['athlete_age'].astype(int)
df2['Athlete average speed'] = df2['Athlete average speed'].astype(float)
df2.dtypes
df2.head()
#rename columns
#Year of event                  int64
#Event dates                   object
#Event name                    object
#Event distance/length         object
#Event number of finishers      int64
#Athlete performance           object
#Athlete gender                object
#Athlete average speed        float64
#Athlete ID                     int64
#athlete_age                    int64
df2 = df2.rename(columns = {'Year of event': 'year', 
                            'Event dates': 'race_day',
                            'Event name': 'race_name',
                            'Event distance/length': 'race_length',
                            'Event number of finishers': 'race_number_of_finishers',
                            'Athlete performance': 'Athlete_performance',
                            'Athlete gender': 'Athlete_gender',
                            'Athlete average speed': 'Athlete_average_speed',
                            'Athlete ID': 'Athlete_ID'
                            })
df2.head()                  
#reoreder columns   
      
df3 = df2[['race_day', 'race_name', 'race_length', 'race_number_of_finishers', 'Athlete_performance', 'Athlete_gender', 'Athlete_average_speed', 'Athlete_ID', 'athlete_age']]                          
df3.head()                     
#find 2 races that i ran in 2020 - sarasota | everglades 
df3[df3['race_name'] == 'Everglades 50 Mile Ultra Run ']
#222509
df3[df3['Athlete_ID'] == 222509]
#charts and graphs
sns.histplot(df3['race_length'])
import matplotlib.pyplot as plt
plt.show()
sns.histplot(df3, x = 'race_length', hue = 'Athlete_gender')
plt.show()
sns.displot(df3[df3['race_length'] == '50mi']['Athlete_average_speed'])
plt.show()
sns.violinplot(data = df3, x = 'race_length', y = 'Athlete_average_speed', hue =  'Athlete_gender', split = True, inner = 'quart', linewidth = 1)
plt.show()
sns.lmplot(data = df3, x = 'athlete_age', y = 'Athlete_average_speed', hue='Athlete_gender')
plt.show()
#questions i wanna find from the data
    #race_day
    #race_name 
    #race_length 
    #race_number_of_finishers 
    #Athlete_performance
    #Athlete_gender
    #Athlete_average_speed
    #Athlete_ID
    #athlete_age'

#Diffremce in speed for the 50k, 50 mi male to female
df3.groupby(['race_length', 'Athlete_gender'])['Athlete_average_speed'].mean()
#what age group are the best in the 50 m race (20 + races min)(show 15)
df3.query('race_length == "50mi"').groupby('athlete_age')['Athlete_average_speed'].agg(['mean', 'count']).sort_values('mean', ascending=False).query('count>19').head(15)
#what age group are the worst in the 50 m race (20 + races min)(show 15)
df3.query('race_length == "50mi"').groupby('athlete_age')['Athlete_average_speed'].agg(['mean', 'count']).sort_values('mean', ascending=True).query('count>19').head(15)
#seasons for the data -> slower in summer than winter?

#spring 3-5
#summer 6-8
#fall 9-11
#winter 12-2

#split between two decimals
df3['race_month'] = df3['race_day'].str.split('.').str.get(1).astype(int)
df3.head()
df3['race_season'] = df3['race_month'].apply(lambda x: 'Wintert' if x > 11 else 'Fall' if x > 8 else 'Summer' if x > 5 else 'Spring' if x > 2 else 'automn')
df3.head(25)
df3.groupby('race_season')['Athlete_average_speed'].agg(['mean', 'count']).sort_values('mean', ascending=False)
#50 miler only
df3.query('race_length == "50mi"').groupby('race_season')['Athlete_average_speed'].agg(['mean', 'count']).sort_values('mean', ascending=False)