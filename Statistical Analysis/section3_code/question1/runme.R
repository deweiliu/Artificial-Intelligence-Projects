QUESTION_NUMBER = 1
source('../utilities/init.R')
source('functions.R')
features = c('nr_pix', 'height', 'cols_with_5')
sets = c('living',  'fullset')
for (feature_name in features) {
  for (set in sets) {
    q1_draw_histogram(feature_name, set)
    
  }
}

finish()