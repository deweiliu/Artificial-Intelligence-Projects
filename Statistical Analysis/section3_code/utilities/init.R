# the runme.R file in each question of part 3 should load this init.R file
# which sets up essential variables and loads utility functions

welcome_text <- cat(paste(
  strrep('*', 10),
  sprintf('Running R script runme.R for question %d', QUESTION_NUMBER),
  strrep('*', 10),
  '\n',
  sep = "\n"
))
welcome_text
source('../utilities/utilities.R')
INDICES <- list(
  fullset=1:160,
  living=1:80,
  nonliving=81:160,
  banana=1:20,
  cherry=21:40,
  envelope=41:60,
  flower=61:80,
  golfclub=81:100,
  pear=101:120,
  pencil=121:140,
  wineglass=141:160
)

# Load feature data
FEATURES_PATH <- '../../section2_features/40216004_features.csv'
feature_data <- read.csv(FEATURES_PATH, header = TRUE, sep = '\t')

# set up figure directory which stores figures
OUTPUT_DIR <- './outputs'
create_dir(OUTPUT_DIR)

# define the format of figures
FIGURE_FORMAT = '.jpeg'
