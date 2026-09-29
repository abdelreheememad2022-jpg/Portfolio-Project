# ============================================================
# PENGUINS DATA ANALYSIS PROJECT
# Cleaning, Transformation, Analysis & Visualization
# ============================================================


# ============================================================
# 1. LOAD PACKAGES
# ============================================================

library(tidyverse)
library(palmerpenguins)


# ============================================================
# 2. LOAD THE DATASET
# ============================================================

data("penguins")

# Create a copy so the original dataset is not changed
penguins_clean <- penguins


# ============================================================
# 3. EXPLORE THE DATA
# ============================================================

# View first rows
head(penguins_clean)

# Structure of the dataset
str(penguins_clean)

# Number of rows and columns
dim(penguins_clean)

# Column names
names(penguins_clean)

# Summary statistics
summary(penguins_clean)


# ============================================================
# 4. CHECK FOR MISSING VALUES
# ============================================================

# Total missing values
sum(is.na(penguins_clean))

# Missing values in each column
colSums(is.na(penguins_clean))


# ============================================================
# 5. REMOVE MISSING VALUES
# ============================================================

penguins_clean <- penguins_clean %>%
  drop_na()

# Check again
colSums(is.na(penguins_clean))


# ============================================================
# 6. CHECK FOR DUPLICATE ROWS
# ============================================================

sum(duplicated(penguins_clean))

# Remove duplicates if there are any
penguins_clean <- penguins_clean %>%
  distinct()


# ============================================================
# 7. CHECK DATA TYPES
# ============================================================

str(penguins_clean)


# ============================================================
# 8. TRANSFORM THE DATA
# ============================================================

# Create Body Mass in kilograms
penguins_clean <- penguins_clean %>%
  mutate(
    body_mass_kg = body_mass_g / 1000
  )


# Create Bill Length in centimeters
# Original bill length is already in mm
penguins_clean <- penguins_clean %>%
  mutate(
    bill_length_cm = bill_length_mm / 10
  )


# Create Bill Depth in centimeters
penguins_clean <- penguins_clean %>%
  mutate(
    bill_depth_cm = bill_depth_mm / 10
  )


# ============================================================
# 9. CREATE A SIZE CATEGORY
# ============================================================

penguins_clean <- penguins_clean %>%
  mutate(
    size_category = case_when(
      body_mass_g < 3500 ~ "Small",
      body_mass_g < 4500 ~ "Medium",
      TRUE ~ "Large"
    )
  )


# Check the new category
table(penguins_clean$size_category)


# ============================================================
# 10. SELECT IMPORTANT COLUMNS
# ============================================================

penguins_analysis <- penguins_clean %>%
  select(
    species,
    island,
    sex,
    year,
    body_mass_g,
    body_mass_kg,
    bill_length_mm,
    bill_length_cm,
    bill_depth_mm,
    bill_depth_cm,
    flipper_length_mm,
    size_category
  )


# View cleaned dataset
head(penguins_analysis)


# ============================================================
# 11. BASIC ANALYSIS
# ============================================================

# Number of penguins by species
penguins_clean %>%
  count(species)


# Number of penguins by island
penguins_clean %>%
  count(island)


# Number of penguins by sex
penguins_clean %>%
  count(sex)


# ============================================================
# 12. AVERAGE BODY MASS BY SPECIES
# ============================================================

penguins_clean %>%
  group_by(species) %>%
  summarise(
    average_body_mass = mean(body_mass_g),
    minimum_body_mass = min(body_mass_g),
    maximum_body_mass = max(body_mass_g),
    penguin_count = n()
  )


# ============================================================
# 13. AVERAGE FLIPPER LENGTH BY SPECIES
# ============================================================

penguins_clean %>%
  group_by(species) %>%
  summarise(
    average_flipper_length = mean(flipper_length_mm)
  )


# ============================================================
# 14. AVERAGE BILL LENGTH BY SPECIES
# ============================================================

penguins_clean %>%
  group_by(species) %>%
  summarise(
    average_bill_length = mean(bill_length_mm)
  )


# ============================================================
# 15. SPECIES + SEX ANALYSIS
# ============================================================

penguins_clean %>%
  group_by(species, sex) %>%
  summarise(
    average_body_mass = mean(body_mass_g),
    average_flipper_length = mean(flipper_length_mm),
    count = n(),
    .groups = "drop"
  )


# ============================================================
# 16. SPECIES + ISLAND ANALYSIS
# ============================================================

penguins_clean %>%
  group_by(species, island) %>%
  summarise(
    penguin_count = n(),
    average_body_mass = mean(body_mass_g),
    .groups = "drop"
  )


# ============================================================
# 17. FIND THE HEAVIEST PENGUINS
# ============================================================

penguins_clean %>%
  arrange(desc(body_mass_g)) %>%
  select(species, island, sex, body_mass_g) %>%
  head(10)


# ============================================================
# 18. FIND THE LONGEST FLIPPERS
# ============================================================

penguins_clean %>%
  arrange(desc(flipper_length_mm)) %>%
  select(species, island, sex, flipper_length_mm) %>%
  head(10)


# ============================================================
# 19. VISUALIZATION 1
# COUNT OF PENGUINS BY SPECIES
# ============================================================

ggplot(penguins_clean, aes(x = species)) +
  geom_bar() +
  labs(
    title = "Number of Penguins by Species",
    x = "Species",
    y = "Number of Penguins"
  )


# ============================================================
# 20. VISUALIZATION 2
# BODY MASS BY SPECIES
# ============================================================

ggplot(penguins_clean, aes(x = species, y = body_mass_g)) +
  geom_boxplot() +
  labs(
    title = "Body Mass Distribution by Species",
    x = "Species",
    y = "Body Mass (g)"
  )


# ============================================================
# 21. VISUALIZATION 3
# FLIPPER LENGTH BY SPECIES
# ============================================================

ggplot(penguins_clean, aes(x = species, y = flipper_length_mm)) +
  geom_boxplot() +
  labs(
    title = "Flipper Length by Species",
    x = "Species",
    y = "Flipper Length (mm)"
  )


# ============================================================
# 22. VISUALIZATION 4
# BODY MASS VS FLIPPER LENGTH
# ============================================================

ggplot(
  penguins_clean,
  aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point() +
  labs(
    title = "Body Mass vs Flipper Length",
    x = "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Species"
  )


# ============================================================
# 23. VISUALIZATION 5
# BILL LENGTH VS BILL DEPTH
# ============================================================

ggplot(
  penguins_clean,
  aes(
    x = bill_length_mm,
    y = bill_depth_mm,
    color = species
  )
) +
  geom_point() +
  labs(
    title = "Bill Length vs Bill Depth",
    x = "Bill Length (mm)",
    y = "Bill Depth (mm)",
    color = "Species"
  )


# ============================================================
# 24. VISUALIZATION 6
# BODY MASS BY SEX
# ============================================================

ggplot(
  penguins_clean,
  aes(x = sex, y = body_mass_g)
) +
  geom_boxplot() +
  labs(
    title = "Body Mass by Sex",
    x = "Sex",
    y = "Body Mass (g)"
  )


# ============================================================
# 25. VISUALIZATION 7
# PENGUINS BY ISLAND
# ============================================================

ggplot(penguins_clean, aes(x = island)) +
  geom_bar() +
  labs(
    title = "Number of Penguins by Island",
    x = "Island",
    y = "Number of Penguins"
  )


# ============================================================
# 26. VISUALIZATION 8
# SPECIES BY ISLAND
# ============================================================

ggplot(
  penguins_clean,
  aes(x = island, fill = species)
) +
  geom_bar() +
  labs(
    title = "Penguin Species by Island",
    x = "Island",
    y = "Number of Penguins",
    fill = "Species"
  )


# ============================================================
# 27. CORRELATION BETWEEN NUMERIC VARIABLES
# ============================================================

penguins_clean %>%
  select(
    bill_length_mm,
    bill_depth_mm,
    flipper_length_mm,
    body_mass_g
  ) %>%
  cor()


# ============================================================
# 28. FINAL DATASET
# ============================================================

# Number of rows and columns after cleaning
dim(penguins_clean)

# Final structure
str(penguins_clean)

# Final summary
summary(penguins_clean)
