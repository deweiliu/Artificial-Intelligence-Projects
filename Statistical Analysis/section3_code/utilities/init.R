# the runme.R file in each question of part 3 should load this init.R file
# which sets up essential variables and loads utility functions

welcome_text = cat(paste(
  strrep('*', 10),
  sprintf('Running R script runme.R for question %d', QUESTION_NUMBER),
  strrep('*', 10),
  '\n',
  sep = "\n"
))
welcome_text
source('../utilities/utilities.R')
FULLSET <- 1:160
LIVING <- 1:80
NONLIVING <- 81:160

BANANA <- 1:20
CHERRY <- 21:40
ENVELOPE <- 41:60
FLOWER <- 61:80
GOLFCLUB <- 81:100
PEAR <- 101:120
PENCIL <- 121:140
WINEGLASS <- 141:160
INDICES = list(
  FULLSET,
  LIVING,
  NONLIVING,
  BANANA,
  CHERRY,
  ENVELOPE,
  FLOWER,
  GOLFCLUB,
  PEAR,
  PENCIL,
  WINEGLASS
)
names(INDICES) = c(
  'fullset',
  'living',
  'nonliving',
  'banana',
  'cherry',
  'envelope',
  'flower',
  'golfclub',
  'pear',
  'pencil',
  'wineglass'
)

# Load feature data
FEATURES_PATH = '../../section2_features/40216004_features.csv'
feature_data <- read.csv(FEATURES_PATH, header = TRUE, sep = '\t')

# set up figure directory which stores figures
OUTPUT_DIR = './outputs'
create_dir(OUTPUT_DIR)

# define the format of figures
FIGURE_FORMAT = '.jpeg'
