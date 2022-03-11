# Can you predict popularity of a song by its audio features?

Over 40,000 new songs are added to Spotify every day; some of them are meant to become instant hits and work their way into all-time classics, and others&#39; fate is to end on the landfill of forgotten songs. But what makes a popular song? If we could answer this question, music labels would get the power of choosing which songs to promote and what artists are guaranteed to succeed in increasing their profits dramatically. Moreover, artists would know which audience likes their art more and target those regions.

Over 40,000 new songs appear on Spotify daily. While some are become instant hints and join ranks of all-time classics others never appear in search. So, what constitutes a popular song? An answer to this question would give music labels a crystal ball helping them pick artists and songs to promote.

In this work, I focused on the search data from Spotify&#39;s API. To begin, the data was collected through Spotify&#39;s API. Second, the data was cleaned and prepared. Third, an explaratory analysis was conducted in search of parameters connected to popularity. Fourth, parameter heat map was created. Fifth, I converted problem to classification by dividing popularity into 4 classes of new/unpopular, popular, very popular and hits. The data set was imbalanced, with 80% of all observation laying in region 2 &quot;popular.&quot; No technique led to reasonable improvement of the model&#39;s predictive power.

In conclusion, predicting popularity of a song by its audio features is an impossible task as popularity depends on many qualitative aspects outside available data. Nonetheless, the data showed that song has 15 days to become popular before algorithm stops showing it.

The data is available on Kaggle through the link bellow. I encourage the reader to use data set to explore new music genres!

Link to Kaggle
[https://www.kaggle.com/nikitatkachenko/19332-spotify-songs](https://www.kaggle.com/nikitatkachenko/19332-spotify-songs)

Data collection can be accessed from datasource.R and analysis from source.R
