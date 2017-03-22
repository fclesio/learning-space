# prophet: Automatic Forecasting Procedure

# Implements a procedure for forecasting time series data based on an additive model where 
# non-linear trends are fit with yearly and weekly seasonality, plus holidays. 
# It works best with daily periodicity data with at least one year of historical data. 
# Prophet is robust to missing data, shifts in the trend, and large outliers.

# Link: https://cran.r-project.org/web/packages/prophet/index.html

# Paper: https://facebookincubator.github.io/prophet/static/prophet_paper_20170113.pdf


# Install
install.packages('prophet')

# load libraries
library(prophet)
library(dplyr)

# Load data
df <- read.csv('https://raw.githubusercontent.com/facebookincubator/prophet/master/examples/example_wp_peyton_manning.csv') %>%
  mutate(y = log(y))

# Fit the model using prophet
m <- prophet(df)

# STAN OPTIMIZATION COMMAND (LBFGS)
# init = user
# save_iterations = 1
# init_alpha = 0.001
# tol_obj = 1e-12
# tol_grad = 1e-08
# tol_param = 1e-08
# tol_rel_obj = 10000
# tol_rel_grad = 1e+07
# history_size = 5
# seed = 1040960818
# initial log joint probability = -19.4685
# Optimization terminated normally: 
#   Convergence detected: relative gradient magnitude is below tolerance


# See summary of the model
summary(m)

# Length Class      Mode     
# growth                   1     -none-     character
# changepoints            25     Date       numeric  
# n.changepoints           1     -none-     numeric  
# yearly.seasonality       1     -none-     logical  
# weekly.seasonality       1     -none-     logical  
# holidays                 0     -none-     NULL     
# seasonality.prior.scale  1     -none-     numeric  
# changepoint.prior.scale  1     -none-     numeric  
# holidays.prior.scale     1     -none-     numeric  
# mcmc.samples             1     -none-     numeric  
# interval.width           1     -none-     numeric  
# uncertainty.samples      1     -none-     numeric  
# start                    1     Date       numeric  
# end                      1     Date       numeric  
# y.scale                  1     -none-     numeric  
# stan.fit                 0     -none-     NULL     
# params                   6     -none-     list     
# history                  4     data.frame list  

m$growth

m$changepoints

m$n.changepoints

m$yearly.seasonality

m$weekly.seasonality

m$holidays

m$seasonality.prior.scale

m$changepoint.prior.scale

m$holidays.prior.scale

m$mcmc.samples

m$interval.width

m$uncertainty.samples

m$start

m$end

m$y.scale

m$stan.fit

m$params

m$params$k

m$params$m

m$params$delta

m$params$sigma_obs

m$params$beta

m$params$gamma

m$history

# Produce a new dataframe with future predictions
future <- make_future_dataframe(m, periods = 365)

# New dataframe
tail(future)

# Using the predict function to use the 'm' model over the 'future' object/dataframe 
forecast <- predict(m, future)

# To see the predictions
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

# Plot the forecasting
plot(m, forecast)

# See the forecast components 
prophet_plot_components(m, forecast)

# Forecasting Growth: https://facebookincubator.github.io/prophet/docs/forecasting_growth.html

# By default, Prophet uses a linear model for its forecast. When forecasting growth, there is usually some maximum achievable point: total market size, total population size, etc. 
# This is called the carrying capacity, and the forecast should saturate at this point.
# Prophet allows you to make forecasts using a logistic growth trend model, with a specified carrying capacity. 

# Load data
df <- read.csv('https://raw.githubusercontent.com/facebookincubator/prophet/master/examples/example_wp_R.csv')

# Transform variable in log
df$y <- log(df$y)

# Put carrying capacity in the model
df$cap <- 8.5

# The important things to note are that cap must be specified for every row in the dataframe, and that it does not have to be constant. 
# If the market size is growing, then cap can be an increasing sequence.

# Logistic Growth
m <- prophet(df, growth = 'logistic')

# STAN OPTIMIZATION COMMAND (LBFGS)
# init = user
# save_iterations = 1
# init_alpha = 0.001
# tol_obj = 1e-12
# tol_grad = 1e-08
# tol_param = 1e-08
# tol_rel_obj = 10000
# tol_rel_grad = 1e+07
# history_size = 5
# seed = 1126718309
# initial log joint probability = -67.9808
# Optimization terminated normally: 
#   Convergence detected: relative gradient magnitude is below tolerance

# Forecasting function and future predictions with carrying capacity of 8.5
future <- make_future_dataframe(m, periods = 1826)
future$cap <- 8.5
fcst <- predict(m, future)
plot(m, fcst);


# Trend Changepoints: https://facebookincubator.github.io/prophet/docs/trend_changepoints.html

# You may have noticed in the earlier examples in this documentation that real time series frequently have abrupt changes in their trajectories. 
# By default, Prophet will automatically detect these changepoints and will allow the trend to adapt appropriately. However, 
# if you wish to have finer control over this process (e.g., Prophet missed a rate change, or is overfitting rate changes in the history), 
# then there are several input arguments you can use.

# Automatic changepoint detection in Prophet

# Prophet detects changepoints by first specifying a large number of potential changepoints at which the rate is allowed to change. 
# It then puts a sparse prior on the magnitudes of the rate changes (equivalent to L1 regularization) - this essentially means that Prophet has a large 
# number of possible places where the rate can change, but will use as few of them as possible

# The number of potential changepoints can be set using the argument n_changepoints, but this is better tuned by adjusting the regularization.


# Adjusting trend flexibility

# If the trend changes are being overfit (too much flexibility) or underfit (not enough flexiblity), you can adjust the strength of the
# sparse prior using the input argument changepoint_prior_scale. By default, this parameter is set to 0.05. Increasing it will make the trend more flexibile:

m <- prophet(df, changepoint.prior.scale = 0.5)
forecast <- predict(m, future)
plot(m, forecast);

# STAN OPTIMIZATION COMMAND (LBFGS)
# init = user
# save_iterations = 1
# init_alpha = 0.001
# tol_obj = 1e-12
# tol_grad = 1e-08
# tol_param = 1e-08
# tol_rel_obj = 10000
# tol_rel_grad = 1e+07
# history_size = 5
# seed = 979246171
# initial log joint probability = -24.8456
# Optimization terminated normally: 
#   Convergence detected: relative gradient magnitude is below tolerance

m <- prophet(df, changepoint.prior.scale = 0.001)
forecast <- predict(m, future)
plot(m, forecast);

# STAN OPTIMIZATION COMMAND (LBFGS)
# init = user
# save_iterations = 1
# init_alpha = 0.001
# tol_obj = 1e-12
# tol_grad = 1e-08
# tol_param = 1e-08
# tol_rel_obj = 10000
# tol_rel_grad = 1e+07
# history_size = 5
# seed = 1091881533
# initial log joint probability = -24.8456
# Optimization terminated normally: 
#   Convergence detected: absolute parameter change was below tolerance


# Specifying the locations of the changepoints

# If you wish, rather than using automatic changepoint detection you can manually specify the locations of potential changepoints with the changepoints argument.

m <- prophet(df, changepoints = c(as.Date('2014-01-01')))
forecast <- predict(m, future)
plot(m, forecast);


# Holiday Effects

# Modeling Holidays

# If you have holidays that you’d like to model, you must create a dataframe for them. It has two columns (holiday and ds) and a row for each occurrence of the holiday. 
# It must include all occurrences of the holiday, both in the past (back as far as the historical data go) and in the future (out as far as the forecast is being made). 
# If they won’t repeat in the future, Prophet will model them and then not include them in the forecast.

# You can also include columns lower_window and upper_window which extend the holiday out to [lower_window, upper_window] days around the date. 
# For instance, if you wanted to included Christmas Eve in addition to Christmas you’d include lower_window=-1,upper_window=0. 
# If you wanted to use Black Friday in addition to Thanksgiving, you’d include lower_window=0,upper_window=1.

library(dplyr)

playoffs <- data_frame(
  holiday = 'playoff',
  ds = as.Date(c('2008-01-13', '2009-01-03', '2010-01-16',
                 '2010-01-24', '2010-02-07', '2011-01-08',
                 '2013-01-12', '2014-01-12', '2014-01-19',
                 '2014-02-02', '2015-01-11', '2016-01-17',
                 '2016-01-24', '2016-02-07')),
  lower_window = 0,
  upper_window = 1
)

superbowls <- data_frame(
  holiday = 'superbowl',
  ds = as.Date(c('2010-02-07', '2014-02-02', '2016-02-07')),
  lower_window = 0,
  upper_window = 1
)

holidays <- bind_rows(playoffs, superbowls)


# Predict with Holydays
m <- prophet(df, holidays = holidays)
forecast <- predict(m, future)

# STAN OPTIMIZATION COMMAND (LBFGS)
# init = user
# save_iterations = 1
# init_alpha = 0.001
# tol_obj = 1e-12
# tol_grad = 1e-08
# tol_param = 1e-08
# tol_rel_obj = 10000
# tol_rel_grad = 1e+07
# history_size = 5
# seed = 1008163644
# initial log joint probability = -24.8456
# Optimization terminated normally: 
#   Convergence detected: relative gradient magnitude is below tolerance

forecast %>% 
  select(ds, playoff, superbowl) %>% 
  filter(abs(playoff + superbowl) > 0) %>%
  tail(10)

# Holyday effect in plot
prophet_plot_components(m, forecast);

# Prior scale for holidays and seasonality

# If you find that the holidays are overfitting, you can adjust their prior scale to smooth them using the parameter holidays_prior_scale, which by default is 10:

m <- prophet(df, holidays = holidays, holidays.prior.scale = 1)
forecast <- predict(m, future)
forecast %>% 
  select(ds, playoff, superbowl) %>% 
  filter(abs(playoff + superbowl) > 0) %>%
  tail(10)




# Uncertainty Intervals: https://facebookincubator.github.io/prophet/docs/uncertainty_intervals.html

# By default Prophet will return uncertainty intervals for the forecast yhat. There are several important assumptions behind these uncertainty intervals.
# There are three sources of uncertainty in the forecast: uncertainty in the trend, uncertainty in the seasonality estimates, and additional observation noise.

# Uncertainty in the trend

# The biggest source of uncertainty in the forecast is the potential for future trend changes. 
# The time series we have seen already in this documentation show clear trend changes in the history. Prophet is able to detect and fit these, 
# but what trend changes should we expect moving forward? It’s impossible to know for sure, so we do the most reasonable thing we can, and we assume 
# that the future will see similar trend changes as the history. In particular, we assume that the average frequency and magnitude of trend changes in 
# the future will be the same as that which we observe in the history. We project these trend changes forward and by computing their distribution we obtain uncertainty intervals.
# One property of this way of measuring uncertainty is that allowing higher flexibility in the rate, by increasing changepoint_prior_scale, 
# will increase the forecast uncertainty. This is because if we model more rate changes in the history then we will expect more in the future, 
# and makes the uncertainty intervals a useful indicator of overfitting.
# The width of the uncertainty intervals (by default 80%) can be set using the parameter interval_width:
  
m <- prophet(df, interval.width = 0.95)
forecast <- predict(m, future)

# STAN OPTIMIZATION COMMAND (LBFGS)
# init = user
# save_iterations = 1
# init_alpha = 0.001
# tol_obj = 1e-12
# tol_grad = 1e-08
# tol_param = 1e-08
# tol_rel_obj = 10000
# tol_rel_grad = 1e+07
# history_size = 5
# seed = 1438976275
# initial log joint probability = -24.8456
# Optimization terminated normally: 
#   Convergence detected: relative gradient magnitude is below tolerance

# Uncertainty in seasonality

# By default Prophet will only return uncertainty in the trend and observation noise. To get uncertainty in seasonality, you must do full Bayesian sampling. 
# This is done using the parameter mcmc.samples (which defaults to 0). We do this here for the Peyton Manning data from the Quickstart:

m <- prophet(df, mcmc.samples = 500)
forecast <- predict(m, future)


# SAMPLING FOR MODEL 'prophet_linear_growth' NOW (CHAIN 1).
# 
# Chain 1, Iteration:   1 / 500 [  0%]  (Warmup)
# Chain 1, Iteration:  50 / 500 [ 10%]  (Warmup)
# Chain 1, Iteration: 100 / 500 [ 20%]  (Warmup)
# Chain 1, Iteration: 150 / 500 [ 30%]  (Warmup)
# Chain 1, Iteration: 200 / 500 [ 40%]  (Warmup)
# Chain 1, Iteration: 250 / 500 [ 50%]  (Warmup)
# Chain 1, Iteration: 251 / 500 [ 50%]  (Sampling)
# Chain 1, Iteration: 300 / 500 [ 60%]  (Sampling)
# Chain 1, Iteration: 350 / 500 [ 70%]  (Sampling)
# Chain 1, Iteration: 400 / 500 [ 80%]  (Sampling)
# Chain 1, Iteration: 450 / 500 [ 90%]  (Sampling)
# Chain 1, Iteration: 500 / 500 [100%]  (Sampling)
# Elapsed Time: 337.863 seconds (Warm-up)
# 485.457 seconds (Sampling)
# 823.32 seconds (Total)
# 
# The following numerical problems occured the indicated number of times on chain 1
# count
# Exception thrown at line 46: normal_log: Scale parameter is 0, but must be > 0!     5
# When a numerical problem occurs, the Hamiltonian proposal gets rejected.
# See http://mc-stan.org/misc/warnings.html#exception-hamiltonian-proposal-rejected
# If the number in the 'count' column is small, do not ask about this message on stan-users.
# 
# SAMPLING FOR MODEL 'prophet_linear_growth' NOW (CHAIN 2).
# 
# Chain 2, Iteration:   1 / 500 [  0%]  (Warmup)
# Chain 2, Iteration:  50 / 500 [ 10%]  (Warmup)



prophet_plot_components(m, forecast);


# Outliers: https://facebookincubator.github.io/prophet/docs/outliers.html
# There are two main ways that outliers can affect Prophet forecasts. 

df <- read.csv('https://raw.githubusercontent.com/facebookincubator/prophet/master/examples/example_wp_R_outliers1.csv')
df$y <- log(df$y)
m <- prophet(df)
future <- make_future_dataframe(m, periods = 1096)
forecast <- predict(m, future)
plot(m, forecast);
 
  
# Dealing with outliers

outliers <- (as.Date(df$ds) > as.Date('2010-01-01')
             & as.Date(df$ds) < as.Date('2011-01-01'))
df$y[outliers] = NA
m <- prophet(df)
forecast <- predict(m, future)
plot(m, forecast);

# STAN OPTIMIZATION COMMAND (LBFGS)
# init = user
# save_iterations = 1
# init_alpha = 0.001
# tol_obj = 1e-12
# tol_grad = 1e-08
# tol_param = 1e-08
# tol_rel_obj = 10000
# tol_rel_grad = 1e+07
# history_size = 5
# seed = 13967331
# initial log joint probability = -21.2638
# Error evaluating model log probability: Non-finite gradient.
# Error evaluating model log probability: Non-finite gradient.
# Optimization terminated normally: 
#   Convergence detected: relative gradient magnitude is below tolerance


# In the above example the outliers messed up the uncertainty estimation but did not impact the main forecast yhat. 
# This isn’t always the case, as in this example with added outliers:

df <- read.csv('https://raw.githubusercontent.com/facebookincubator/prophet/master/examples/example_wp_R_outliers2.csv')
df$y = log(df$y)
m <- prophet(df)
future <- make_future_dataframe(m, periods = 1096)
forecast <- predict(m, future)
plot(m, forecast);


# Here a group of extreme outliers in June 2015 mess up the seasonality estimate, so their effect 
# reverberates into the future forever. Again the right approach is to remove them:

outliers <- (as.Date(df$ds) > as.Date('2015-06-01')
             & as.Date(df$ds) < as.Date('2015-06-30'))
df$y[outliers] = NA
m <- prophet(df)
forecast <- predict(m, future)
plot(m, forecast);


# Non-Daily Data: https://facebookincubator.github.io/prophet/docs/non-daily_data.html
# Prophet doesn’t strictly require daily data, but you can get strange results if 
# you ask for daily forecasts from non-daily data and fit seasonalities. Here we forecast US retail sales volume for the next 10 years:
 
df <- read.csv('https://raw.githubusercontent.com/facebookincubator/prophet/master/examples/example_retail_sales.csv')
m <- prophet(df)
future <- make_future_dataframe(m, periods = 3652)
fcst <- predict(m, future)
plot(m, fcst);


# The forecast here seems very noisy. What’s happening is that this particular data set only provides monthly data. 
# When we fit the yearly seasonality, it only has data for the first of each month and the seasonality components 
# for the remaining days are unidentifiable and overfit. When you are fitting Prophet to monthly data, only make monthly 
# forecasts, which can be done by passing the frequency into make_future_dataframe:

future <- make_future_dataframe(m, periods = 120, freq = 'm')
fcst <- predict(m, future)
plot(m, fcst)
